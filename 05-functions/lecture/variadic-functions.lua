--[[ Variadic Functions ]]
-- A function in Lua can be variadic, that is, it can take a variable number of arguments. For instance, we have already called print with one, two, and more arguments. Although print is defined in C, we can define variadic functions in Lua, too.

-- As a simple example, the following function returns the summation of all its arguments:
function add (...)
	local s = 0
	for _, v in ipairs{...} do
		s = s + v
	end
	return s
end
	
print(add(3, 4, 10, 25, 12)) --> 54

-- The three dots (...) in the parameter list indicate that the function is variadic. When we call this function, Lua collects all its arguments internally; we call these collected arguments the extra arguments of the function. A function accesses its extra arguments using again the three dots, now as an expression. In our example, the expression {...} results in a list with all collected arguments. The function then traverses the list to add its elements.

-- We call the three-dot expression a vararg expression. It behaves like a multiple return function, returning all extra arguments of the current function. For instance, the command print(...) prints all extra arguments of the function. Likewise, the next command creates two local variables with the values of the first two optional arguments (or nil if there are no such arguments):
local a, b = ...

-- Actually, we can emulate the usual parameter-passing mechanism of Lua translating
function foo (a, b, c)
-- to
function foo (...)
local a, b, c = ...

-- Those who fancy Perl's parameter-passing mechanism may enjoy this second form.

-- A function like the next one simply returns all its arguments:
function id (...) 
	return ... 
end

-- It is a multi-value identity function. The next function behaves exactly like another function foo, except that before the call it prints a message with its arguments:
function foo1 (...)
	print("calling foo:", ...)
	return foo(...)
end

-- This is a useful trick for tracing calls to a specific function. 

-- Let us see another useful example. Lua provides separate functions for formatting text (string.format) and for writing text (io.write). It is straightforward to combine both functions into a single variadic function:
function fwrite (fmt, ...)
	return io.write(string.format(fmt, ...))
end

-- Note the presence of a fixed parameter fmt before the dots. Variadic functions can have any number of fixed parameters before the variadic part. Lua assigns the first arguments to these parameters; the rest (if any) goes as extra arguments.

-- To iterate over its extra arguments, a function can use the expression {...} to collect them all in a table, as we did in our definition of add. However, in the rare occasions when the extra arguments can be valid nils, the table created with {...} may not be a proper sequence. For instance, there is no way to detect in such a table whether there were trailing nils in the original arguments. For these occasions, Lua offers the function table.pack.

-- This function receives any number of arguments and returns a new table with all its arguments (just like {...}), but this table has also an extra field "n", with the total number of arguments. As an example, the following function uses table.pack to test whether none of its arguments is nil:
function nonils (...)
	local arg = table.pack(...)
	for i = 1, arg.n do
		if arg[i] == nil then return false end
	end
	return true
end

print(nonils(2,3,nil)) --> false
print(nonils(2,3)) --> true
print(nonils()) --> true
print(nonils(nil)) --> false

-- Another option to traverse the variable arguments of a function is the select function. A call to select has always one fixed argument, the selector, plus a variable number of extra arguments. If the selector is a number n, select returns all arguments after the n-th argument; otherwise, the selector should be the string "#", so that select returns the total number of extra arguments.
print(select(1, "a", "b", "c")) --> a b c
print(select(2, "a", "b", "c")) --> b c
print(select(3, "a", "b", "c")) --> c
print(select("#", "a", "b", "c")) --> 3

-- More often than not, we use select in places where its number of results is adjusted to one, so we can think about select(n, ...) as returning its n-th extra argument.

-- As a typical example of the use of select, here is our previous add function using it:
function add (...)
	local s = 0
	for i = 1, select("#", ...) do
		s = s + select(i, ...)
	end
	return s
end

-- For few arguments, this second version of add is faster, because it avoids the creation of a new table at each call. For more arguments, however, the cost of multiple calls to select with many arguments outperforms the cost of creating a table, so the first version becomes a better choice. (In particular, the second version has a quadratic cost, because both the number of iterations and the number of arguments passed in each iteration grow with the number of arguments.)
