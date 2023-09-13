--[[ Errors ]]
-- "To err is human" Therefore, we must handle errors the best way we can. Because Lua is an extension language, frequently embedded in an application, it cannot simply crash or exit when an error happens. Instead, whenever an error occurs, Lua must offer ways to handle it.

-- Any unexpected condition that Lua encounters raises an error. Errors occur when a program tries to add values that are not numbers, call values that are not functions, index values that are not tables, and so on. (We can modify this behavior using metatables, as we will see later.) We can also explicitly raise an error calling the function error, with an error message as an argument. Usually, this function is the appropriate way to signal errors in our code:
print "enter a number:"
n = io.read("n")
if not n then error("invalid input") end

-- This construction of calling error subject to some condition is so common that Lua has a built-in function just for this job, called assert:
print "enter a number:"
n = assert(io.read("*n"), "invalid input")

-- The function assert checks whether its first argument is not false and simply returns this argument; if the argument is false, assert raises an error. Its second argument, the message, is optional. Beware, however, that assert is a regular function. As such, Lua always evaluates its arguments before calling the function. If we write something like
n = io.read()
assert(tonumber(n), "invalid input: " .. n .. " is not a number")

-- Lua will always do the concatenation, even when n is a number. It may be wiser to use an explicit test in such cases.

-- When a function finds an unexpected situation (an exception), it can assume two basic behaviors: it can return an error code (typically nil or false) or it can raise an error, calling error. There are no fixed rules for choosing between these two options, but I use the following guideline: an exception that is easily avoided should raise an error; otherwise, it should return an error code.

-- For instance, let us consider math.sin. How should it behave when called on a table? Suppose it returns an error code. If we need to check for errors, we would have to write something like this:
local res = math.sin(x)
if not res then -- error?
	-- error-handling code
end

-- However, we could as easily check this exception before calling the function:
if not tonumber(x) then -- x is not a number?
	-- error-handling code
end

-- Frequently we check neither the argument nor the result of a call to sin; if the argument is not a number, it means that probably there is something wrong in our program. In such situations, the simplest and most practical way to handle the exception is to stop the computation and issue an error message.

-- On the other hand, let us consider io.open, which opens a file. How should it behave when asked to open a file that does not exist? In this case, there is no simple way to check for the exception before calling the function. In many systems, the only way of knowing whether a file exists is by trying to open it. Therefore, if io.open cannot open a file because of an external reason (such as “file does not exist” or “permission denied”), it returns false, plus a string with the error message. In this way, we have a chance to handle the situation in an appropriate way, for instance by asking the user for another file name:
local file, msg
repeat
	print "enter a file name:"
	local name = io.read()
	if not name then return end -- no input
	file, msg = io.open(name, "r")
	if not file then print(msg) end
until file

-- If we do not want to handle such situations, but still want to play safe, we simply use assert to guard the operation:
file = assert(io.open(name, "r")) --> stdin:1: no-file: No such file or directory

-- This is a typical Lua idiom: if io.open fails, assert will raise an error. Notice how the error message, which is the second result from io.open, goes as the second argument to assert.
