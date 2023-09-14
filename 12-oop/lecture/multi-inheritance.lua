--[[ Multiple Inheritance ]]
-- Because objects are not primitive in Lua, there are several ways to do object-oriented programming in Lua. The approach that we have seen, using the index metamethod, is probably the best combination of simplicity, performance, and flexibility. Nevertheless, there are other implementations, which may be more appropriate for some particular cases. Here we will see an alternative implementation that allows multiple inheritance in Lua.

-- The key to this implementation is the use of a function for the metafield __index. Remember that, when a table's metatable has a function in the __index field, Lua will call this function whenever it cannot find a key in the original table. Then, __index can look up for the missing key in how many parents it wants.

-- Multiple inheritance means that a class does not have a unique superclass. Therefore, we should not use a (super)class method to create subclasses. Instead, we will define an independent function for this purpose, createClass, which has as arguments all superclasses of the new class; 

-- Below shows an implementation of multiple inheritance.

-- look up for 'k' in list of tables 'plist'
local function search (k, plist)
	for i = 1, #plist do
	local v = plist[i][k] -- try 'i'-th superclass
	if v then return v end
	end
end
	
function createClass (...)
	local c = {} -- new class
	local parents = {...} -- list of parents
	
	-- class searches for absent methods in its list of parents
	setmetatable(c, {__index = function (t, k)
		return search(k, parents)
	end})
	
	-- prepare 'c' to be the metatable of its instances
	c.__index = c
	
	-- define a new constructor for this new class
	function c:new (o)
		o = o or {}
		setmetatable(o, c)
		return o
	end
	
	return c -- return new class
end

-- This function creates a table to represent the new class and sets its metatable with an __index metamethod that does the multiple inheritance. Despite the multiple inheritance, each object instance still belongs to one single class, where it looks for all its methods. Therefore, the relationship between classes and superclasses is different from the relationship between instances and classes. Particularly, a class cannot be the metatable for its instances and for its subclasses at the same time. Back to the above implementation, we keep the class as the metatable for its instances, and create another table to be the metatable of the class.

-- Let us illustrate the use of createClass with a small example. Assume our previous class Account and another class, Named, with only two methods: setname and getname.
Named = {}
function Named:getname ()
	return self.name
end

function Named:setname (n)
	self.name = n
end

-- To create a new class NamedAccount that is a subclass of both Account and Named, we simply call createClass:
NamedAccount = createClass(Account, Named)

-- To create and to use instances, we do as usual:
account = NamedAccount:new{name = "Paul"}
print(account:getname()) --> Paul

-- Now let us follow how Lua evaluates the expression account:getname(); more specifically, let us follow the evaluation of account["getname"]. Lua cannot find the field "getname" in account; so, it looks for the field __index on the account's metatable, which is NamedAccount in our example. But NamedAccount also cannot provide a "getname" field, so Lua looks for the field __index of NamedAccount's metatable. Because this field contains a function, Lua calls it. This function then looks for "getname" first in Account, without success, and then in Named, where it finds a non-nil value, which is the final result of the search.

-- Of course, due to the underlying complexity of this search, the performance of multiple inheritance is not the same as single inheritance. A simple way to improve this performance is to copy inherited methods into the subclasses. Using this technique, the index metamethod for classes would be like this:
setmetatable(c, {__index = function (t, k)
	local v = search(k, parents)
	t[k] = v -- save for next access
	return v
end})

-- With this trick, accesses to inherited methods are as fast as to local methods, except for the first access. The drawback is that it is difficult to change method definitions after the program has started, because these changes do not propagate down the hierarchy chain.
