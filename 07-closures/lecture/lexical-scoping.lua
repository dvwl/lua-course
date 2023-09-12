--[[ Lexical Scoping ]]
-- When we write a function enclosed in another function, it has full access to local variables from the enclosing function; we call this feature lexical scoping. Although this visibility rule may sound obvious, it is not. Lexical scoping plus nested first-class functions give great power to a programming language, but many do not support the combination.

-- Let us start with a simple example. Suppose we have a list of student names and a table that maps names to grades; we want to sort the list of names according to their grades, with higher grades first. We can do this task as follows:
names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}
table.sort(names, function (n1, n2)
	return grades[n1] > grades[n2] -- compare the grades
end)

-- Now, suppose we want to create a function to do this task:
function sortbygrade (names, grades)
	table.sort(names, function (n1, n2)
		return grades[n1] > grades[n2] -- compare the grades
		end)
end

-- The interesting point in this last example is that the anonymous function given to sort accesses grades, which is a parameter to the enclosing function sortbygrade. Inside this anonymous function, grades is neither a global variable nor a local variable, but what we call a non-local variable. (For historical reasons, non-local variables are also called upvalues in Lua.)

-- Why is this point so interesting? Because functions, being first-class values, can escape the original scope of their variables. Consider the following code:
function newCounter ()
	local count = 0
 	return function () -- anonymous function
 		count = count + 1
 		return count
 	end
end
 
c1 = newCounter()
print(c1()) --> 1
print(c1()) --> 2

-- In this code, the anonymous function refers to a non-local variable (count) to keep its counter. However, by the time we call the anonymous function, the variable count seems to be out of scope, because the function that created this variable (newCounter) has already returned. Nevertheless, Lua handles this situation correctly, using the concept of closure. Simply put, a closure is a function plus all it needs to access non-local variables correctly. If we call newCounter again, it will create a new local variable count and a new closure, acting over this new variable:
c2 = newCounter()
print(c2()) --> 1
print(c1()) --> 3
print(c2()) --> 2

-- So, c1 and c2 are different closures. Both are built over the same function, but each acts upon an independent instantiation of the local variable count.

-- Technically speaking, what is a value in Lua is the closure, not the function. The function itself is a kind of a prototype for closures. Nevertheless, we will continue to use the term “function” to refer to a closure whenever there is no possibility for confusion.

-- Closures provide a valuable tool in many contexts. As we have seen, they are useful as arguments to higher-order functions such as sort. Closures are valuable for functions that build other functions too, like our newCounter example or the derivative example; this mechanism allows Lua programs to incorporate sophisticated programming techniques from the functional world. Closures are useful for callback functions, too. A typical example here occurs when we create buttons in a conventional GUI toolkit. Each button has a callback function to be called when the user presses the button; we want different buttons to do slightly different things when pressed.

-- For instance, a digital calculator needs ten similar buttons, one for each digit. We can create each of them with a function like this:
function digitButton (digit)
	return Button
	{ 
		label = tostring(digit),
		action = function ()
			add_to_display(digit)
		end
	}
end

-- In this example, we pretend that Button is a toolkit function that creates new buttons; label is the button label; and action is the callback function to be called when the button is pressed. The callback can be called a long time after digitButton did its task, but it can still access the digit variable.

-- Closures are valuable also in a quite different context. Because functions are stored in regular variables, we can easily redefine functions in Lua, even predefined functions. This facility is one of the reasons why Lua is so flexible. Frequently, when we redefine a function, we need the original function in the new implementation. As an example, suppose we want to redefine the function sin to operate in degrees instead of radians. This new function converts its argument and then calls the original function sin to do the real work. Our code could look like this:
local oldSin = math.sin
math.sin = function (x)
	return oldSin(x * (math.pi / 180))
end

-- A slightly cleaner way to do this redefinition is as follows:
do
	local oldSin = math.sin
	local k = math.pi / 180
	math.sin = function (x)
		return oldSin(x * k)
	end
end

-- This code uses a do block to limit the scope of the local variable oldSin; following conventional visibility rules, the variable is only visible inside the block. So, the only way to access it is through the new function.

-- We can use this same technique to create secure environments, also called sandboxes. Secure environments are essential when running untrusted code, such as code received through the Internet by a server. For instance, to restrict the files that a program can access, we can redefine io.open using closures:
do
	local oldOpen = io.open
	local access_OK = function (filename, mode)
		check access
	end
	io.open = function (filename, mode)
		if access_OK(filename, mode) then
			return oldOpen(filename, mode)
		else
			return nil, "access denied"
		end
	end
end

-- What makes this example nice is that, after this redefinition, there is no way for the program to call the unrestricted version of function io.open except through the new, restricted version. It keeps the insecure version as a private variable in a closure, inaccessible from the outside. With this technique, we can build Lua sandboxes in Lua itself, with the usual benefits: simplicity and flexibility. Instead of a one-size-fits-all solution, Lua offers us a meta-mechanism, so that we can tailor our environment for our specific security needs. 
-- Note: Real sandboxes do more than protecting external files. Search “Sandboxing” in Lua Programming.
