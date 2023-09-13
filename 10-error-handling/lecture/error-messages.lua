--[[ Error Messages and Tracebacks ]]
-- Although we can use a value of any type as an error object, usually error objects are strings describing what went wrong. When there is an internal error (such as an attempt to index a non-table value), Lua generates the error object, which in that case is always a string; otherwise, the error object is the value passed to the function error. Whenever the object is a string, Lua tries to add some information about the location where the error happened:
status, err = pcall(function () error("my error") end)
print(err) --> stdin:1: my error

-- The location information gives the chunk's name (stdin, in the example) plus the line number (1, in the example).

-- The function error has an additional second parameter, which gives the level where it should report the error. We use this parameter to blame someone else for the error. For instance, suppose we write a function whose first task is to check whether it was called correctly:
function foo (str)
	if type(str) ~= "string" then
	error("string expected")
	end
	-- regular code
end

-- Then, someone calls this function with a wrong argument:
foo({x=1}) --> stdin:1: string expected

-- As it is, Lua points its finger to foo —after all, it was it who called error — and not to the real culprit, the caller. To correct this problem, we inform error that the error it is reporting occurred on level two in the calling hierarchy (level one is our own function):
function foo (str)
	if type(str) ~= "string" then
	error("string expected", 2)
	end
	-- regular code
end

-- In other words, it affects where the error message points to in the code. A higher error level points to a higher-level function call in the call stack.

-- Then, calls this function with a wrong argument again:
foo({x=1}) --> string expected

-- Frequently, when an error happens, we want more debug information than only the location where the error occurred. At least, we want a traceback, showing the complete stack of calls leading to the error. When pcall returns its error message, it destroys part of the stack (the part that goes from it to the error point). Consequently, if we want a traceback, we must build it before pcall returns. To do this, Lua provides the function xpcall. It works like pcall, but its second argument is a message handler function. In case of error, Lua calls this message handler before the stack unwinds, so that it can use the debug library to gather any extra information it wants about the error. Two common message handlers are debug.debug, which gives us a Lua prompt so that we can inspect by ourselves what was going on when the error happened; and debug.traceback, which builds an extended error message with a traceback. The latter is the function that the stand-alone interpreter uses to build its error messages.
