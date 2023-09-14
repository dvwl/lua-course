--[[ Dual Representation ]]
-- Another interesting approach for privacy uses a dual representation. Let us start seeing what a dual representation is.

-- Usually, we associate attributes to tables using keys, like this:
table[key] = value

-- However, we can use a dual representation: we can use a table to represent a key, and use the object itself as a key in that table:
key = {}
key[table] = value

-- A key ingredient here is the fact that we can index tables in Lua not only with numbers and strings, but with any value — in particular with other tables.

-- As an example, in our Account implementation, we could keep the balances of all accounts in a table balance, instead of keeping them in the accounts themselves. Our withdraw method would become like this:
function Account.withdraw (self, v)
	balance[self] = balance[self] - v
end

-- What we gain here? Privacy. Even if a function has access to an account, it cannot directly access its balance unless it also has access to the table balance. If the table balance is kept in a local inside the module Account, only functions inside the module can access it and, therefore, only those functions can manipulate account balances.

-- Before we go on, I must discuss a big naivety of this implementation. Once we use an account as a key in the balance table, that account will never become garbage for the garbage collector. It will be anchored there until some code explicitly removes it from that table. That may not be a problem for bank accounts (as an account usually has to be formally closed before going away), but for other scenarios that could be a big drawback. 

-- Below shows again an implementation for accounts, this time using a dual representation.
local balance = {} 
Account = {}

function Account:withdraw (v)
	balance[self] = balance[self] - v
end

function Account:deposit (v)
	balance[self] = balance[self] + v
end

function Account:balance ()
	return balance[self]
end
 
function Account:new (o)
	o = o or {} -- create table if user does not provide one
	setmetatable(o, self)
	self.__index = self
	balance[o] = 0 -- initial balance
	return o
end

-- We use this class just like any other one:
a = Account:new{}
a:deposit(100.00)
print(a:balance())

-- However, we cannot tamper with an account balance. By keeping the table balance private to the module, this implementation ensures its safety.

-- Inheritance works without modifications. This approach has a cost quite similar to the standard one, both in terms of time and of memory. New objects need one new table and one new entry in each private table being used. The access balance[self] can be slightly slower than self.balance, because the latter uses a local variable while the first uses an external variable. Usually this difference is negligible.

-- As we will see later, it also demands some extra work from the garbage collector.
