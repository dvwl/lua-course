--[[ Privacy ]]
-- Many people consider privacy (also called information hiding) to be an integral part of an object-oriented language: the state of each object should be its own internal affair. In some object-oriented languages, such as C++ and Java, we can control whether a field (also called an instance variable) or a method is visible outside the object. Smalltalk, which popularized object-oriented languages, makes all variables private and all methods public. Simula, the first ever object-oriented language, did not offer any kind of protection.

-- The standard implementation of objects in Lua, which we have shown previously, does not offer privacy mechanisms. Partly, this is a consequence of our use of a general structure (tables) to represent objects. Moreover, Lua avoids redundancy and artificial restrictions. If you do not want to access something that lives inside an object, just do not do it. A common practice is to mark all private names with an underscore at the end. You immediately feel the smell when you see a marked name being used in public.

-- Nevertheless, another aim of Lua is to be flexible, offering the programmer meta-mechanisms that enable her to emulate many different mechanisms. Although the basic design for objects in Lua does not offer privacy mechanisms, we can implement objects in a different way, to have access control. Although programmers do not use this implementation frequently, it is instructive to know about it, both because it explores some interesting aspects of Lua and because it is a good solution for more specific problems.

-- The basic idea of this alternative design is to represent each object through two tables: one for its state and another for its operations, or its interface. We access the object itself through the second table, that is, through the operations that compose its interface. To avoid unauthorized access, the table representing the state of an object is not kept in a field of the other table; instead, it is kept only in the closure of the methods. For instance, to represent our bank account with this design, we could create new objects running the following factory function:

function newAccount (initialBalance)
	local self = { balance = initialBalance }
	
	local withdraw = function (v)
		self.balance = self.balance - v
	end

	local deposit = function (v)
	self.balance = self.balance + v
	end

	local getBalance = function () return self.balance end

	return {
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getBalance
	}
end

-- First, the function creates a table to keep the internal object state and stores it in the local variable self. Then, the function creates the methods of the object. Finally, the function creates and returns the external object, which maps method names to the actual method implementations. The key point here is that these methods do not get self as an extra parameter; instead, they access self directly. Because there is no extra argument, we do not use the colon syntax to manipulate such objects. We call their methods just like regular functions:
acc1 = newAccount(100.00)
acc1.withdraw(40.00)
print(acc1.getBalance()) --> 60

-- This design gives full privacy to anything stored in the self table. After the call to newAccount returns, there is no way to gain direct access to this table. We can access it only through the functions created inside newAccount. Although our example puts only one instance variable into the private table, we can store all private parts of an object in this table. We can also define private methods: they are like public methods, but we do not put them in the interface. For instance, our accounts may give an extra credit of 10% for users with balances above a certain limit, but we do not want the users to have access to the details of that computation. We can implement this functionality as follows:
function newAccount (initialBalance)
	local self = {
		balance = initialBalance,
		LIM = 10000.00,
	}

	local withdraw = function (v)
		self.balance = self.balance - v
	end

	local deposit = function (v)
		self.balance = self.balance + v
	end
 
	local extra = function ()
		if self.balance > self.LIM then
			return self.balance*0.10
		else
			return 0
		end
	end
 
	local getBalance = function ()
		return self.balance + extra()
	end

	return {
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getBalance
	}
end

-- Again, there is no way for any user to access the function extra directly.
