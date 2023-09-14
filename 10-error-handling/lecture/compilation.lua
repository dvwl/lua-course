--[[ Compilation ]]
-- Previously, we introduced dofile as a kind of primitive operation to run chunks of Lua code, but dofile is actually an auxiliary function: the function loadfile does the hard work. Like dofile, loadfile loads a Lua chunk from a file, but it does not run the chunk. Instead, it only compiles the chunk and returns the compiled chunk as a function. Moreover, unlike dofile, loadfile does not raise errors, but instead returns error codes. We could define dofile as follows:
function dofile (filename)
	local f = assert(loadfile(filename))
	return f()
end

-- Note the use of assert to raise an error if loadfile fails.

-- For simple tasks, dofile is handy, because it does the complete job in one call. However, loadfile is more flexible. In case of error, loadfile returns nil plus the error message, which allows us to handle the error in customized ways. Moreover, if we need to run a file several times, we can call loadfile once and call its result several times. This approach is much cheaper than several calls to dofile, because it compiles the file only once. (Compilation is a somewhat expensive operation when compared to other tasks in the language.)

-- The function load is similar to loadfile, except that it reads its chunk from a string or from a function, not from a file. For instance, consider the next line:
f = load("i = i + 1")

-- After this code, f will be a function that executes i = i + 1 when invoked:
i = 0
f(); print(i) --> 1
f(); print(i) --> 2

-- The function load is powerful; we should use it with care. It is also an expensive function (when compared to some alternatives) and can result in incomprehensible code. Before you use it, make sure that there is no simpler way to solve the problem at hand.

-- If we want to do a quick-and-dirty dostring (i.e., to load and run a chunk), we can call the result from load directly:
load(s)()

-- However, if there is any syntax error, load will return nil and the final error message will be something like “attempt to call a nil value”. For clearer error messages, it is better to use assert:
assert(load(s))()

-- Usually, it does not make sense to use load on a literal string. For instance, the next two lines are roughly equivalent:
f = load("i = i + 1")
	
f = function () i = i + 1 end

-- However, the second line is much faster, because Lua compiles the function together with its enclosing chunk. In the first line, the call to load involves a separate compilation.

-- Because load does not compile with lexical scoping, the two lines in the previous example may not be truly equivalent. To see the difference, let us change the example a little:
i = 32
local i = 0
f = load("i = i + 1; print(i)")
g = function () i = i + 1; print(i) end
f() --> 33
g() --> 1

-- The function g manipulates the local i, as expected, but f manipulates a global i, because load always compiles its chunks in the global environment.

-- The most typical use of load is to run external code (that is, pieces of code that come from outside our program) or dynamically-generated code. For instance, we may want to plot a function defined by the user; the user enters the function code and then we use load to evaluate it. Note that load expects a chunk, that is, statements. If we want to evaluate an expression, we can prefix the expression with return, so that we get a statement that returns the value of the given expression. See the example:
print "enter your expression:"
local line = io.read()
local func = assert(load("return " .. line))
print("the value of your expression is " .. func())

-- Because the function returned by load is a regular function, we can call it several times:
print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("return " .. line))
for i = 1, 20 do
	x = i -- global 'x' (to be visible from the chunk)
	print(string.rep("*", f()))
end

-- We can call load also with a reader function as its first argument. A reader function can return the chunk in parts; load calls the reader successively until it returns nil, which signals the chunk's end. As an example, the next call is equivalent to loadfile:
f = load(io.lines(filename, "*L"))

-- As we saw in Section 6, The External World, the call io.lines(filename, "*L") returns a function that, at each call, returns a new line from the given file. So, load will read the chunk from the file line by line. The following version is similar, but slightly more efficient:
f = load(io.lines(filename, 1024))

-- Here, the iterator returned by io.lines reads the file in blocks of 1024 bytes.

-- Lua treats any independent chunk as the body of an anonymous variadic function. For instance, load("a = 1") returns the equivalent of the following expression:
function (...) a = 1 end

-- Like any other function, chunks can declare local variables:
f = load("local a = 10; print(a + 20)")
f() --> 30

-- Using these features, we can rewrite our plot example to avoid the use of a global variable x:
print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("local x = ...; return " .. line))
for i = 1, 20 do
	print(string.rep("*", f(i)))
end

-- In this code, we append the declaration "local x = ..." at the beginning of the chunk to declare x as a local variable. We then call f with an argument i that becomes the value of the vararg expression (...).

-- The functions load and loadfile never raise errors. In case of any kind of error, they return nil plus an error message:
print(load("i i")) --> nil [string "i i"]:1: '=' expected near 'i'

-- Moreover, these functions never have any kind of side effect, that is, they do not change or create variables, do not write to files, etc. They only compile the chunk to an internal representation and return the result as an anonymous function. A common mistake is to assume that loading a chunk defines functions. In Lua, function definitions are assignments; as such, they happen at runtime, not at compile time. For instance, suppose we have a file foo.lua like this:
-- file 'foo.lua'
function foo (x)
	print(x)
end

-- We then run the command
f = loadfile("foo.lua")

-- This command compiles foo but does not define it. To define it, we must run the chunk:
f = loadfile("foo.lua")
print(foo) --> nil
f() -- run the chunk
foo("ok") --> ok

-- This behavior may sound strange, but it becomes clear if we rewrite the file without the syntax sugar:
-- file 'foo.lua'
foo = function (x)
	print(x)
end

--  In a production-quality program that needs to run external code, we should handle any errors reported when loading a chunk. Moreover, we may want to run the new chunk in a protected environment, to avoid unpleasant side effects.
