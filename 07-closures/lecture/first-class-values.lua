--[[ First-Class Values ]]
-- Functions in Lua are first-class values. The following example illustrates what that means:
a = {p = print} -- 'a.p' refers to the 'print' function
a.p("Hello World") --> Hello World
print = math.sin -- 'print' now refers to the sine function
a.p(print(1)) --> 0.8414709848079
math.sin = a.p -- 'sin' now refers to the print function
math.sin(10, 20) --> 10 20

-- If functions are values, are there expressions that create functions? Sure. In fact, the usual way to write a function in Lua, such as
function foo (x) return 2*x end

-- is an instance of what we call syntactic sugar; it is simply a pretty way to write the following code:
foo = function (x) return 2*x end

-- The expression in the right-hand side of the assignment (function (x) body end) is a function constructor, in the same way that {} is a table constructor. Therefore, a function definition is in fact a statement that creates a value of type "function" and assigns it to a variable.

-- Note that, in Lua, all functions are anonymous. Like any other value, they do not have names. When we talk about a function name, such as print, we are actually talking about a variable that holds that function. Although we often assign functions to global variables, giving them something like a name, there are several occasions when functions remain anonymous. Let us see some examples.

-- The table library provides the function table.sort, which receives a table and sorts its elements. Such a function must allow unlimited variations in the sort order: ascending or descending, numeric or alphabetical, tables sorted by a key, and so on. Instead of trying to provide all kinds of options, sort provides a single optional parameter, which is the order function: a function that takes two elements and returns whether the first must come before the second in the sorted list. For instance, suppose we have a table of records like this:
network = {
	{name = "alice", IP = "210.26.30.34"},
	{name = "bob", IP = "210.26.30.23"},
	{name = "lua", IP = "210.26.23.12"},
	{name = "dan", IP = "210.26.23.20"},
}

-- If we want to sort the table by the field name, in reverse alphabetical order, we just write this:
table.sort(network, function (a,b) return (a.name > b.name) end)

-- See how handy the anonymous function is in this statement.

-- A function that takes another function as an argument, such as sort, is what we call a higher-order function. Higher-order functions are a powerful programming mechanism, and the use of anonymous functions to create their function arguments is a great source of flexibility. Nevertheless, remember that higher-order functions have no special rights; they are a direct consequence of the fact that Lua handles functions as first-class values.

-- To further illustrate the use of higher-order functions, we will write a naive implementation of a common higher-order function, the derivative. In an informal definition, the derivative of a function f is the function f'(x) = (f(x + d) - f(x)) / d when d becomes infinitesimally small. According to this definition, we can compute an approximation of the derivative as follows:
function derivative (f, delta)
	delta = delta or 1e-4
 	return function (x)
 		return (f(x + delta) - f(x))/delta
 	end
end

-- Given a function f, the call derivative(f) returns (an approximation of) its derivative, which is another function:
c = derivative(math.sin)
print(math.cos(5.2), c(5.2)) --> 0.46851667130038 0.46856084325086
print(math.cos(10), c(10)) --> -0.83907152907645 -0.83904432662041

-- Note: I know this is not a math class, however, the derivative or dy/dx of y = sin x is cos x. 
