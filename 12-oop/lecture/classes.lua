--[[ Classes ]]
-- So far, our objects have an identity, state, and operations on this state. They still lack a class system, inheritance, and privacy. Let us tackle the first problem: how can we create several objects with similar behavior? Specifically, how can we create several accounts?

-- Most object-oriented languages offer the concept of class, which works as a mold for the creation of objects. In such languages, each object is an instance of a specific class. Lua does not have the concept of class; the concept of metatables is somewhat similar, but using it as a class would not lead us too far. Instead, we can emulate classes in Lua following the lead from prototype-based languages like Self. (Javascript also followed that path.) In these languages, objects have no classes. Instead, each object may have a prototype, which is a regular object where the first object looks up any operation that it does not know about. To represent a class in such languages, we simply create an object to be used exclusively as a prototype for other objects (its instances). Both classes and prototypes work as a place to put behavior to be shared by several objects.

-- In Lua, we can implement prototypes using the idea of inheritance that we saw in the section called “The __index metamethod”. More specifically, if we have two objects A and B, all we have to do to make B a prototype for A is this:
setmetatable(A, {__index = B})

-- After that, A looks up in B for any operation that it does not have. To see B as the class of the object A is not much more than a change in terminology.

-- Let us go back to our example of a bank account. To create other accounts with behavior similar to Account, we arrange for these new objects to inherit their operations from Account, using the __index metamethod.

local mt = {__index = Account}
 
function Account.new (o)
	o = o or {} -- create table if user does not provide one
	setmetatable(o, mt)
	return o
end

-- After this code, what happens when we create a new account and call a method on it, like this?
a = Account.new{balance = 0}
a:deposit(100.00)

-- When we create the new account, a, it will have mt as its metatable. When we call a:deposit(100.00), we are actually calling a.deposit(a, 100.00); the colon is only syntactic sugar. However, Lua cannot find a "deposit" entry in the table a; hence, Lua looks into the __index entry of the metatable. The situation now is more or less like this:
getmetatable(a).__index.deposit(a, 100.00)

-- The metatable of a is mt, and mt.__index is Account. Therefore, the previous expression evaluates to this one:
Account.deposit(a, 100.00)

-- That is, Lua calls the original deposit function, but passing a as the self parameter. So, the new account a inherited the function deposit from Account. By the same mechanism, it inherits all fields from Account.

-- We can make two small improvements on this scheme. The first one is that we do not need to create a new table for the metatable role; instead, we can use the Account table itself for that purpose. The second one is that we can use the colon syntax for the new method, too. With these two changes, method new becomes like this:
function Account:new (o)
	o = o or {}
	self.__index = self
	setmetatable(o, self)
	return o
end

-- Now, when we call Account:new(), the hidden parameter self gets Account as its value, we make Account.__index also equal to Account, and set Account as the metatable for the new object. It may seem that we do not gained much with the second change (the colon syntax); the advantage of using self will become apparent when we introduce class inheritance, in the next section.

-- The inheritance works not only for methods, but also for other fields that are absent in the new account. Therefore, a class can provide not only methods, but also constants and default values for its instance fields. Remember that, in our first definition of Account, we provided a field balance with value 0. So, if we create a new account without an initial balance, it will inherit this default value:
b = Account:new()
print(b.balance) --> 0

--  When we call the deposit method on b, it runs the equivalent of the following code, because self is b:
b.balance = b.balance + v

-- The expression b.balance evaluates to zero and the method assigns an initial deposit to b.balance. Subsequent accesses to b.balance will not invoke the index metamethod, because now b has its own balance field.
