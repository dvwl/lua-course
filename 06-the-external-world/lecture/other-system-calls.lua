--[[ Other System Calls ]]
-- The function os.exit terminates the execution of a program. Its optional first argument is the return status of the program. It can be a number (zero means a successful execution) or a Boolean (true means a successful execution). An optional second argument, if true, closes the Lua state, calling all finalizers and releasing all memory used by that state. (Usually this finalization is not necessary, because most operating systems release all resources used by a process when it exits.)

-- The function os.getenv gets the value of an environment variable. It takes the name of the variable and returns a string with its value:
print(os.getenv("HOME") or os.getenv("USERPROFILE") or "") --> /home/lua or C:\Users\{username} or ""

-- Note:  If you are running this Lua code on a Windows system or a non-Unix-based system, the "HOME" environment variable may not be defined by default. Windows uses a different environment variable, typically "USERPROFILE," to represent the user's home directory.

--[[ Running system commands ]]
-- The function os.execute runs a system command; it is equivalent to the C function system. It takes a string with the command and returns information regarding how the command terminated. The first resultis a Boolean: true means the program exited with no errors. The second result is a string: "exit" if the program terminated normally or "signal" if it was interrupted by a signal. A third result is the return	status (if the program terminated normally) or the number of the signal that terminated the program. As an example, both in POSIX and Windows we can use the following function to create new directories:
function createDir (dirname)
	os.execute("mkdir " .. dirname)
end

-- Another quite useful function is io.popen.	 Like os.execute, it runs a system command, but it also connects the command output (or input) to a new local stream and returns that stream, so that our script can read data from (or write to) the command. For instance, the following script builds a table with the entries in the current directory:

-- Note: io.popen is not available in all Lua installations because the corresponding functionality is not part of ISO C.

-- for POSIX systems, use 'ls' instead of 'dir'
local f = io.popen("dir /B", "r")
local dir = {}
for entry in f:lines() do
	dir[#dir + 1] = entry
end
	
-- The second parameter ("r") to io.popen means that we intend to read from the command. The default is to read, so this parameter is optional in the example.
	
-- The next example sends an email message:
local subject = "some news"
local address = "someone@somewhere.org"

local cmd = string.format("mail -s '%s' '%s'", subject, address)
local f = io.popen(cmd, "w")
f:write([[
Nothing important to say.
-- me
]])
f:close()
	
-- (This script only works on POSIX systems, with the appropriate packages installed.) The second parameter to io.popen now is "w", meaning that we intend to write to the command.
	
-- As we can see from those two previous examples, both os.execute and io.popen are powerful functions, but they are also highly system dependent.
	
-- For extended OS access, your best option is to use an external Lua library, such as LuaFileSystem, for basic manipulation of directories and file attributes, or luaposix, which offers much of the functionality of the POSIX.1 standard.
