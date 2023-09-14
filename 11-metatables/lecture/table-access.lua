--[[ Table-Access Metamethods ]]
-- The metamethods for arithmetic, bitwise, and relational operators all define behavior for otherwise erroneous situations; they do not change the normal behavior of the language. Lua also offers a way to change the behavior of tables for two normal situations, the access and modification of absent fields in a table.

--[[ The __index metamethod ]]
-- We saw earlier that, when we access an absent field in a table, the result is nil. This is true, but it is not the whole truth. Actually, such accesses trigger the interpreter to look for an __index metamethod: if there is no such method, as usually happens, then the access results in nil; otherwise, the metamethod will provide the result.

-- The archetypal example here is inheritance. Suppose we want to create several tables describing windows. Each table must describe several window parameters, such as position, size, color scheme, and the like. All these parameters have default values and so we want to build window objects giving only the non-default parameters. A first alternative is to provide a constructor that fills in the absent fields. A second alternative is to arrange for the new windows to inherit any absent field from a prototype window. First,we declare the prototype:
-- create the prototype with default values
prototype = {x = 0, y = 0, width = 100, height = 100}

-- Then, we define a constructor function, which creates new windows sharing a metatable:
local mt = {} -- create a metatable
-- declare the constructor function
function new (o)
	setmetatable(o, mt)
	return o
end

-- Now, we define the __index metamethod:
mt.__index = function (_, key)
	return prototype[key]
end

-- After this code, we create a new window and query it for an absent field:
w = new{x=10, y=20}
print(w.width) --> 100

-- Lua detects that w does not have the requested field, but has a metatable with an __index field. So, Lua calls this __index metamethod, with arguments w (the table) and "width" (the absent key). The metamethod then indexes the prototype with the given key and returns the result.

-- The use of the __index metamethod for inheritance is so common that Lua provides a shortcut. Despite being called a method, the __index metamethod does not need to be a function: it can be a table, instead. When it is a function, Lua calls it with the table and the absent key as its arguments, as we have just seen.

-- When it is a table, Lua redoes the access in this table. Therefore, in our previous example, we could declare __index simply like this:
mt.__index = prototype

-- Now, when Lua looks for the metatable's __index field, it finds the value of prototype, which is a table. Consequently, Lua repeats the access in this table, that is, it executes the equivalent of prototype["width"]. This access then gives the desired result.

-- The use of a table as an __index metamethod provides a fast and simple way of implementing single inheritance. A function, although more expensive, provides more flexibility: we can implement multiple inheritance, caching, and several other variations. We will discuss these forms of inheritance in Section 12, Object-Oriented Programming, when we will cover object-oriented programming.

-- When we want to access a table without invoking its __index metamethod, we use the function rawget. The call rawget(t, i) does a raw access to table t, that is, a primitive access without considering metatables. Doing a raw access will not speed up our code (the overhead of a function call kills any gain we could have), but sometimes we need it, as we will see later

--[[ The __newindex metamethod ]]
-- The __newindex metamethod does for table updates what __index does for table accesses. When we assign a value to an absent index in a table, the interpreter looks for a __newindex metamethod: if there is one, the interpreter calls it instead of making the assignment. Like __index, if the metamethod is a table, the interpreter does the assignment in this table, instead of in the original one. Moreover, there is a raw function that allows us to bypass the metamethod: the call rawset(t, k, v) does the equivalent to t[k] = v without invoking any metamethod.

-- The combined use of the __index and __newindex metamethods allows several powerful constructs in Lua, such as read-only tables, tables with default values, and inheritance for object-oriented programming.

--[[ Tables with default values ]]
-- The default value of any field in a regular table is nil. It is easy to change this default value with metatables:
function setDefault (t, d)
	local mt = {__index = function () return d end}
	setmetatable(t, mt)
end
 
tab = {x=10, y=20}
print(tab.x, tab.z) --> 10 nil
setDefault(tab, 0)
print(tab.x, tab.z) --> 10 0

-- After the call to setDefault, any access to an absent field in tab calls its __index metamethod, which returns zero (the value of d for this metamethod).

-- The function setDefault creates a new closure plus a new metatable for each table that needs a default value. This can be expensive if we have many tables that need default values. However, the metatable has the default value d wired into its metamethod, so we cannot use a single metatable for tables with different default values. To allow the use of a single metatable for all tables, we can store the default value of each table in the table itself, using an exclusive field. If we are not worried about name clashes, we can use a key like "___" for our exclusive field:
local mt = {__index = function (t) return t.___ end}
function setDefault (t, d)
	t.___ = d
	setmetatable(t, mt)
end

-- Note that now we create the metatable mt and its corresponding metamethod only once, outside SetDefault.

-- If we are worried about name clashes, it is easy to ensure the uniqueness of the special key. All we need is a new exclusive table to use as the key:
local key = {} -- unique key
local mt = {__index = function (t) return t[key] end}
function setDefault (t, d)
	t[key] = d
	setmetatable(t, mt)
end

-- An alternative approach for associating each table with its default value is a technique I call dual representation, which uses a separate table where the indices are the tables and the values are their default values. However, for the correct implementation of this approach, we need a special breed of table called weak tables, and so we will not use it here; we will return to the subject in Section 13, Garbage.

-- Another alternative is to memorize metatables in order to reuse the same metatable for tables with the same default. However, that needs weak tables too, so that again we will have to wait until Section 13, Garbage.

--[[ Tracking table accesses ]]
-- Suppose we want to track every single access to a certain table. Both __index and __newindex are relevant only when the index does not exist in the table. So, the only way to catch all accesses to a table is to keep it empty. If we want to monitor all accesses to a table, we should create a proxy for the real table. This proxy is an empty table, with proper metamethods that track all accesses and redirect them to the original table. The code in below implements this idea.
function track (t)
	local proxy = {} -- proxy table for 't'
	
	-- create metatable for the proxy
	local mt = {
		__index = function (_, k)
			print("*access to element " .. tostring(k))
			return t[k] -- access the original table
		end,
		
		__newindex = function (_, k, v)
			print("*update of element " .. tostring(k) .. " to " .. tostring(v))
			t[k] = v -- update original table
		end,
		
		__pairs = function ()
			return function (_, k) -- iteration function
				local nextkey, nextvalue = next(t, k)
				if nextkey ~= nil then -- avoid last value
					print("*traversing element " .. tostring(nextkey))
				end
				return nextkey, nextvalue
			end
		end,
		
		__len = function () return #t end
	}
	
	setmetatable(proxy, mt)
	
	return proxy
end

-- The following example illustrates its use:
t = {} -- an arbitrary table
t = track(t)
t[2] = "hello" --> *update of element 2 to hello
print(t[2])
--> *access to element 2
--> hello
 
-- The metamethods __index and __newindex follow the guidelines that we set, tracking each access and then redirecting it to the original table. The __pairs metamethod allows us to traverse the proxy as  if it were the original table, tracking the accesses along the way. Finally, the __len metamethod gives the length operator through the proxy:
t = track({10, 20})
print(#t) --> 2
for k, v in pairs(t) do print(k, v) end
--> *traversing element 1
--> 1 10
--> *traversing element 2
--> 2 20

-- If we want to monitor several tables, we do not need a different metatable for each one. Instead, we can somehow map each proxy to its original table and share a common metatable for all proxies. This problem is similar to the problem of associating tables to their default values, which we discussed in the previous section, and allows the same solutions. For instance, we can keep the original table in a proxy's field, using an exclusive key, or we can use a dual representation to map each proxy to its corresponding table.

--[[ Read-only tables ]]
-- It is easy to adapt the concept of proxies to implement read-only tables. All we have to do is to raise an error whenever we track any attempt to update the table. For the __index metamethod, we can use a table —the original table itself— instead of a function, as we do not need to track queries; it is simpler and rather more efficient to redirect all queries to the original table. This use demands a new metatable for each read-only proxy, with __index pointing to the original table:
function readOnly (t)
	local proxy = {}
	local mt = { -- create metatable
		__index = t,
		__newindex = function (t, k, v)
			error("attempt to update a read-only table", 2)
		end
	}
	setmetatable(proxy, mt)
	return proxy
end

-- As an example of use, we can create a read-only table for weekdays:
days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
	
print(days[1]) --> Sunday
days[2] = "Noday" --> stdin:1: attempt to update a read-only table
