--[[ Error Handling and Exceptions ]]
-- For many applications, we do not need to do any error handling in Lua; the application program does this handling. All Lua activities start from a call by the application, usually asking Lua to run a chunk. If there is any error, this call returns an error code, so that the application can take appropriate actions. In the case of the stand-alone interpreter, its main loop just prints the error message and continues showing the prompt and running the given commands.

-- However, if we want to handle errors inside the Lua code, we should use the function pcall (protected call) to encapsulate our code.

-- Suppose we want to run a piece of Lua code and to catch any error raised while running that code. Our first step is to encapsulate that piece of code in a function; more often than not, we use an anonymous function for that. Then, we call that function through pcall:
local ok, msg = pcall(function ()
	-- some code
	if unexpected_condition then error() end
		-- some code
		print(a[i]) -- potential error: 'a' may not be a table
		-- some code
	end)

if ok then -- no errors while running protected code
	-- regular code
else -- protected code raised an error: take appropriate action
	-- error-handling code
end

-- The function pcall calls its first argument in protected mode, so that it catches any errors while the function is running. The function pcall never raises any error, no matter what. If there are no errors, pcall returns true, plus any values returned by the call. Otherwise, it returns false, plus the error message.

-- Despite its name, the error message does not have to be a string; a better name is error object, because pcall will return any Lua value that we pass to error:
local status, err = pcall(function () error({code=121}) end)
print(err.code) --> 121

-- These mechanisms provide all we need to do exception handling in Lua. We throw an exception with error and catch it with pcall. The error message identifies the kind of error.
