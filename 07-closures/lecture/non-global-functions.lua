--[[ Non-Global Functions ]]
-- An obvious consequence of first-class functions is that we can store functions not only in global variables, but also in table fields and in local variables.

-- We have already seen several examples of functions in table fields: most Lua libraries use this mechanism (e.g., io.read, math.sin). To create such functions in Lua, we only have to put together what we have learned so far:
Lib = {}
Lib.foo = function (x,y) return x + y end
Lib.goo = function (x,y) return x - y end

print(Lib.foo(2, 3), Lib.goo(2, 3)) --> 5 -1

-- Of course, we can also use constructors:
Lib = {
	foo = function (x,y) return x + y end,
	goo = function (x,y) return x - y end
}

-- Moreover, Lua offers a specific syntax to define such functions:
Lib = {}
function Lib.foo (x,y) return x + y end
function Lib.goo (x,y) return x - y end

-- As we will see in Object-Oriented Programming, the use of functions in table fields is a key ingredient for object-oriented programming in Lua.

-- When we store a function into a local variable, we get a local function, that is, a function that is restricted to a given scope. Such definitions are particularly useful for packages: because Lua handles each chunk as a function, a chunk can declare local functions, which are visible only inside the chunk. Lexical scoping ensures that other functions in the chunk can use these local functions.

-- Lua supports such uses of local functions with a syntactic sugar for them:
local function name (params)
	-- body
end

-- A subtle point arises in the definition of recursive local functions, because the naive approach does not work here. Consider the next definition:
local fact = function (n)
	if n == 0 then return 1
	else return n*fact(n-1) -- buggy
	end
end

-- When Lua compiles the call fact(n - 1) in the function body, the local fact is not yet defined. Therefore, this expression will try to call a global fact, not the local one. We can solve this problem by first defining the local variable and then the function:
local fact
fact = function (n)
	if n == 0 then return 1
	else return n*fact(n-1)
	end
end

-- Now the fact inside the function refers to the local variable. Its value when the function is defined does not matter; by the time the function executes, fact already has the right value.

-- When Lua expands its syntactic sugar for local functions, it does not use the naive definition. Instead, a definition like
local function foo (params) 
	-- body 
end

-- expands to
local foo; 
foo = function (params) 
	-- body 
end

-- Therefore, we can use this syntax for recursive functions without worrying.

-- Of course, this trick does not work if we have indirect recursive functions. In such cases, we must use the equivalent of an explicit forward declaration:
local f -- "forward" declaration
 
local function g ()
	-- some code f() 
	-- some code
end
 
--[[ local ]] function f ()
	-- some code g() 
	-- some code
end

-- Beware not to write local in the last definition. Otherwise, Lua would create a fresh local variable f, leaving the original f (the one that g is bound to) undefined.
