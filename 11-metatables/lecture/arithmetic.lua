--[[ Arithmetic Metamethods ]]
-- In this section, we will introduce a running example to explain the basics of metatables. Suppose we have a module that uses tables to represent sets, with functions to compute set union, intersection, and the like, as shown below.
local Set = {}
 
-- create a new set with the values of a given list
function Set.new (l)
	local set = {}
	for _, v in ipairs(l) do set[v] = true end
	return set
end

function Set.union (a, b)
	local res = Set.new{}
	for k in pairs(a) do res[k] = true end
	for k in pairs(b) do res[k] = true end
	return res
end

function Set.intersection (a, b)
	local res = Set.new{}
	for k in pairs(a) do
		res[k] = b[k]
	end
	return res
end

-- presents a set as a string
function Set.tostring (set)
	local l = {} -- list to put all elements from the set
	for e in pairs(set) do
		l[#l + 1] = tostring(e)
	end
	return "{" .. table.concat(l, ", ") .. "}"
end

return Set

-- Now, we want to use the addition operator to compute the union of two sets. For that, we will arrange for all tables representing sets to share a metatable. This metatable will define how they react to the addition operator. Our first step is to create a regular table, which we will use as the metatable for sets:
local mt = {} -- metatable for sets

-- The next step is to modify Set.new, which creates sets. The new version has only one extra line, which sets mt as the metatable for the tables that it creates:
function Set.new (l) -- 2nd version
	local set = {}
	setmetatable(set, mt)
	for _, v in ipairs(l) do set[v] = true end
	return set
end

-- After that, every set we create with Set.new will have that same table as its metatable:
s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
print(getmetatable(s1)) --> table: 0x00672B60
print(getmetatable(s2)) --> table: 0x00672B60

-- Finally, we add to the metatable the metamethod __add, a field that describes how to perform the addition:
mt.__add = Set.union

-- After that, whenever Lua tries to add two sets, it will call Set.union, with the two operands as arguments.

-- With the metamethod in place, we can use the addition operator to do set unions:
s3 = s1 + s2
print(Set.tostring(s3)) --> {1, 10, 20, 30, 50}

-- Similarly, we may set the multiplication operator to perform set intersection:
mt.__mul = Set.intersection
 
print(Set.tostring((s1 + s2)*s1)) --> {10, 20, 30, 50}

-- For each arithmetic operator there is a corresponding metamethod name. Besides addition and multiplication, there are metamethods for subtraction (__sub), float division (__div), floor division (__idiv), negation (__unm), modulo (__mod), and exponentiation (__pow). Similarly, there are metamethods for all bitwise operations: bitwise AND (__band), OR (__bor), exclusive OR (__bxor), NOT (__bnot), left shift (__shl), and right shift (__shr). We may define also a behavior for the concatenation operator, with the field __concat.

-- When we add two sets, there is no question about what metatable to use. However, we may write an expression that mixes two values with different metatables, for instance like this:
s = Set.new{1,2,3}
s = s + 8

-- When looking for a metamethod, Lua performs the following steps: if the first value has a metatable with the required metamethod, Lua uses this metamethod, independently of the second value; otherwise, if the second value has a metatable with the required metamethod, Lua uses it; otherwise, Lua raises an error. Therefore, the last example will call Set.union, as will the expressions 10 + s and "hello" + s (because both numbers and strings do not have a metamethod __add).

-- Lua does not care about these mixed types, but our implementation does. If we run the s = s + 8 example, we will get an error inside the function Set.union:
-- bad argument #1 to 'pairs' (table expected, got number)

-- If we want more lucid error messages, we must check the type of the operands explicitly before attempting to perform the operation, for instance with code like this:
function Set.union (a, b)
	if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
		error("attempt to 'add' a set with a non-set value", 2)
	end
	local res = Set.new{}
	for k in pairs(a) do res[k] = true end
	for k in pairs(b) do res[k] = true end
	return res
end

-- Remember that the second argument to error (2, in this example) sets the source location in the error message to the code that called the operation.
