--[[ Multiple Results ]]
-- An unconventional but quite convenient feature of Lua is that functions can return multiple results. Several predefined functions in Lua return multiple values. We have already seen the function string.find, which locates a pattern in a string. This function returns two indices when it finds the pattern: the index of the character where the match starts and the one where it ends. A multiple assignment allows the program to get both results:
s, e = string.find("hello Lua developers", "Lua")
print(s, e) --> 7 9

-- (Remember that the first character of a string has index 1.)

-- Functions that we write in Lua also can return multiple results, by listing them all after the return keyword. For instance, a function to find the maximum element in a sequence can return both the maximum value and its location:
function maximum (a)
	local mi = 1 -- index of the maximum value
	local m = a[mi] -- maximum value
	for i = 1, #a do
		if a[i] > m then
			mi = i; m = a[i]
		end
	end
	return m, mi -- return the maximum and its index
end

print(maximum({8,10,23,12,5})) --> 23 3

-- Lua always adjusts the number of results from a function to the circumstances of the call. When we call a function as a statement, Lua discards all results from the function. When we use a call as an expression (e.g., the operand of an addition), Lua keeps only the first result. We get all results only when the call is the last (or the only) expression in a list of expressions. These lists appear in four constructions in Lua: multiple assignments, arguments to function calls, table constructors, and return statements. To illustrate all these cases, we will assume the following definitions for the next examples:
function foo0 () end -- returns no results
function foo1 () return "a" end -- returns 1 result
function foo2 () return "a", "b" end -- returns 2 results

-- In a multiple assignment, a function call as the last (or only) expression produces as many results as needed to match the variables:
x, y = foo2() -- x="a", y="b"
x = foo2() -- x="a", "b" is discarded
x, y, z = 10, foo2() -- x=10, y="a", z="b"

-- In a multiple assignment, if a function has fewer results than we need, Lua produces nils for the missing values:
x,y = foo0() -- x=nil, y=nil
x,y = foo1() -- x="a", y=nil
x,y,z = foo2() -- x="a", y="b", z=nil

-- Remember that multiple results only happen when the call is the last (or only) expression in a list. A function call that is not the last element in the list always produces exactly one result:
x,y = foo2(), 20 -- x="a", y=20 ('b' discarded)
x,y = foo0(), 20, 30 -- x=nil, y=20 (30 is discarded)

-- When a function call is the last (or the only) argument to another call, all results from the first call go as arguments. We saw examples of this construction already, with print. Because print can receive a variable number of arguments, the statement print(g()) prints all results returned by g.
print(foo0()) --> (no results)
print(foo1()) --> a
print(foo2()) --> a b
print(foo2(), 1) --> a 1
print(foo2() .. "x") --> ax (see next)

-- When the call to foo2 appears inside an expression, Lua adjusts the number of results to one; so, in the last line, the concatenation uses only the first result, "a".

-- If we write f(g()), and f has a fixed number of parameters, Lua adjusts the number of results from g to the number of parameters of f. Not by chance, this is exactly the same behavior that happens in a multiple assignment.

-- A constructor also collects all results from a call, without any adjustments:
t = {foo0()} -- t = {} (an empty table)
t = {foo1()} -- t = {"a"}
t = {foo2()} -- t = {"a", "b"}

-- As always, this behavior happens only when the call is the last expression in the list; calls in any other position produce exactly one result:
t = {foo0(), foo2(), 4} -- t[1] = nil, t[2] = "a", t[3] = 4

-- Finally, a statement like return f() returns all values returned by f:
function foo (i)
	if i == 0 then return foo0()
	elseif i == 1 then return foo1()
	elseif i == 2 then return foo2()
	end
end
	
print(foo(1)) --> a
print(foo(2)) --> a b
print(foo(0)) -- (no results)
print(foo(3)) -- (no results)

-- We can force a call to return exactly one result by enclosing it in an extra pair of parentheses:
print((foo0())) --> nil
print((foo1())) --> a
print((foo2())) --> a

-- Beware that a return statement does not need parentheses around the returned value; any pair of parentheses placed there counts as an extra pair. Therefore, a statement like return (f(x)) always returns one single value, no matter how many values f returns. Sometimes this is what we want, sometimes not.
