--[[ The function table.unpack ]]
-- A special function with multiple returns is table.unpack. It takes a list and returns as results all elements from the list:
print(table.unpack{10,20,30}) --> 10 20 30
a,b = table.unpack{10,20,30} -- a=10, b=20, 30 is discarded

-- As the name implies, table.unpack is the reverse of table.pack. While pack transforms a parameter list into a real Lua list (a table), unpack transforms a real Lua list (a table) into a return list, which can be given as the parameter list to another function.
   
-- An important use for unpack is in a generic call mechanism. A generic call mechanism allows us to call any function, with any arguments, dynamically. In ISO C, for instance, there is no way to code a generic call. We can declare a function that takes a variable number of arguments (with stdarg.h) and we can call a variable function, using pointers to functions. However, we cannot call a function with a variable number of arguments: each call you write in C has a fixed number of arguments, and each argument has a fixed type. In Lua, if we want to call a variable function f with variable arguments in an array a, we simply write this:
f(table.unpack(a))

-- The call to unpack returns all values in a, which become the arguments to f. For instance, consider the following call:
print(string.find("hello", "ll"))

-- We can dynamically build an equivalent call with the following code:
f = string.find
a = {"hello", "ll"}
print(f(table.unpack(a)))

-- Usually, table.unpack uses the length operator to know how many elements to return, so it works only on proper sequences. If needed, however, we can provide explicit limits:
print(table.unpack({"Sun", "Mon", "Tue", "Wed"}, 2, 3))
--> Mon Tue

-- Although the predefined function unpack is written in C, we could write it also in Lua, using recursion:
function unpack (t, i, n)
	i = i or 1
	n = n or #t
	if i <= n then
		return t[i], unpack(t, i + 1, n)
	end
end

-- The first time we call it, with a single argument, the parameter i gets 1 and n gets the length of the sequence. Then the function returns t[1] followed by all results from unpack(t, 2, n), which in turn returns t[2] followed by all results from unpack(t, 3, n), and so on, stopping after n elements.
