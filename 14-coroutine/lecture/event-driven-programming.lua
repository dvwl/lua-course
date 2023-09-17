--[[ Event-Driven Programming ]]
-- It may not be obvious at first sight, but the typical entanglement created by conventional event-driven programming is another consequence of the who-is-the-boss problem.

-- In a typical event-driven platform, an external entity generates events to our program in a so-called event loop (or run loop). It is clear who is the boss there, and it is not our code. Our program becomes a slave of the event loop, and that makes it a collection of individual event handlers without any apparent connection.

-- To make things a little more concrete, let us assume that we have an asynchronous I/O library similar to libuv. The library has four functions that concern our small example:
lib.runloop();
lib.readline(stream, callback);
lib.writeline(stream, line, callback);
lib.stop();

-- The first function runs the event loop, which will process the incoming events and call the associated callbacks. A typical event-driven program initializes some stuff and then calls this function, which becomes the main loop of the application. The second function instructs the library to read a line of the given stream and, when it is done, to call the given callback function with the result. The third function is similar to the second, but for writing a line. The last function breaks the event loop, usually to finish the program.

-- Below presents an ugly implementation of the asynchronous I/O library (async-lib):
local cmdQueue = {} -- queue of pending operations
 
local lib = {}

function lib.readline (stream, callback)
	local nextCmd = function ()
		callback(stream:read())
	end
	table.insert(cmdQueue, nextCmd)
end

function lib.writeline (stream, line, callback)
	local nextCmd = function ()
		callback(stream:write(line))
	end
	table.insert(cmdQueue, nextCmd)
end

function lib.stop ()
	table.insert(cmdQueue, "stop")
end

function lib.runloop ()
	while true do
		local nextCmd = table.remove(cmdQueue, 1)
		if nextCmd == "stop" then
			break
		else
			nextCmd() -- perform next operation
		end
	end
end

return lib

-- It is a very ugly implementation. Its “event queue” is in fact a list of pending operations that, when performed (synchronously!), will generate the events. Despite its uglyness, it fulfills the previous specification and, therefore, allows us to test the following examples without the need for a real asynchronous library.

-- Let us now write a trivial program with that library, which reads all lines from its input stream into a table and writes them to the output stream in reverse order. With traditional I/O, the program would be like this:
local t = {}
local inp = io.input() -- input stream
local out = io.output() -- output stream
 
for line in inp:lines() do
	t[#t + 1] = line
end
 
for i = #t, 1, -1 do
	out:write(t[i], "\n")
end

-- Now we rewrite that program in an event-driven style on top of the asynchronous I/O library; the result is as below:
local lib = require "async-lib"

local t = {}
local inp = io.input()
local out = io.output()
local i

-- write-line handler
local function putline ()
	i = i - 1
	if i == 0 then -- no more lines?
		lib.stop() -- finish the main loop
	else -- write line and prepare next one
		lib.writeline(out, t[i] .. "\n", putline)
	end
end

-- read-line handler
local function getline (line)
	if line then -- not EOF?
		t[#t + 1] = line -- save line
		lib.readline(inp, getline) -- read next one
	else -- end of file
		i = #t + 1 -- prepare write loop
		putline() -- enter write loop
	end
end

lib.readline(inp, getline) -- ask to read first line
lib.runloop() -- run the main loop

-- As is typical in an event-driven scenario, all our loops are gone, because the main loop is in the library. They got replaced by recursive calls disguised as events. We could improve things by using closures in a continuation-passing style, but we still could not write our own loops; we would have to rewrite them through recursion.

-- Coroutines allow us to reconcile our loops with the event loop. The key idea is to run our main code as a coroutine that, at each request to the library, sets the callback as a function to resume itself and then yields. 

-- Below uses this idea to implement a library that runs conventional, synchronous code on top of the asynchronous I/O library:
local lib = require "async-lib"

function run (code)
	local co = coroutine.wrap(function ()
		code()
		lib.stop() -- finish event loop when done
	end)
	co() -- start coroutine
	lib.runloop() -- start event loop
end

function putline (stream, line)
	local co = coroutine.running() -- calling coroutine
	local callback = (function () coroutine.resume(co) end)
	lib.writeline(stream, line, callback)
	coroutine.yield()
end

function getline (stream, line)
	local co = coroutine.running() -- calling coroutine
	local callback = (function (l) coroutine.resume(co, l) end)
	lib.readline(stream, callback)
	local line = coroutine.yield()
	return line
end

-- As its name implies, the run function runs the synchronous code, which it takes as a parameter. It first creates a coroutine to run the given code and finish the event loop when it is done. Then, it resumes this coroutine (which will yield at its first I/O call) and then enters the event loop.

-- The functions getline and putline simulate synchronous I/O. As outlined, both call an appropriate asynchronous function passing as the callback a function that resumes the calling coroutine. (Note the use of the coroutine.running function to access the calling coroutine.) After that, they yield, and the control goes back to the event loop. Once the operation completes, the event loop calls the callback, resuming the coroutine that triggered the operation.

-- With that library in place, we are ready to run synchronous code on the top of the asynchronous library. As an example, the following fragment implements once more our reverse-lines example:
run(function ()
	local t = {}
	local inp = io.input()
	local out = io.output()

	while true do
		local line = getline(inp)
		if not line then break end
		t[#t + 1] = line
	end

	for i = #t, 1, -1 do
		putline(out, t[i] .. "\n")
	end
end)

-- The code is equal to the original synchronous one, except that it uses get/putline for I/O and runs inside a call to run. Underneath its synchronous structure, it actually runs in an event-driven fashion, and it is fully compatible with other parts of the program written in a more typical event-driven style.
