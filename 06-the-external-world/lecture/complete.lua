--[[ The Complete I/O Model ]]
-- The simple I/O model is convenient for simple things, but it is not enough for more advanced file manipulation, such as reading from or writing to several files simultaneously. For these manipulations, we need the complete model.

-- To open a file, we use the function io.open, which mimics the C function fopen. It takes as arguments the name of the file to open plus a mode string. This mode string can contain an r for reading, a w for writing (which also erases any previous content of the file), or an a for appending, plus an optional b to open binary files. The function open returns a new stream over the file. In case of error, open returns nil, plus an error message and a system-dependent error number:
print(io.open("non-existent-file", "r")) --> nil non-existent-file: No such file or directory
 
print(io.open("/etc/passwd", "w")) --> nil /etc/passwd: Permission denied 13

-- A typical idiom to check for errors is to use the function assert:
--[[
local filename = "input.txt"
local mode = "r"
]]
local f = assert(io.open(filename, mode)) --> string expected, got nil

-- If the open fails, the error message goes as the second argument to assert, which then shows the message.

-- After we open a file, we can read from or write to the resulting stream with the methods read and write. They are similar to the functions read and write, but we call them as methods on the stream object, using the colon operator. For instance, to open a file and read it all, we can use a fragment like this:
local f = assert(io.open(filename, "r"))
local t = f:read("a")
f:close()

-- (We will discuss the colon operator in detail in Object-Oriented Programming.)

-- The I/O library offers handles for the three predefined C streams, called io.stdin, io.stdout, and io.stderr. For instance, we can send a message directly to the error stream with a code like this:
io.stderr:write(message)

-- The functions io.input and io.output allow us to mix the complete model with the simple model. We get the current input stream by calling io.input(), without arguments. We set this stream with the call io.input(handle). (Similar calls are also valid for io.output.) For instance, if we want to change the current input stream temporarily, we can write something like this:
local temp = io.input() -- save current stream
io.input("newinput") -- open a new current stream
do -- [[ something with new input ]]
end
io.input():close() -- close current stream
io.input(temp) -- restore previous current stream

-- Note that io.read(args) is actually a shorthand for io.input():read(args), that is, the read method applied over the current input stream. Similarly, io.write(args) is a shorthand for io.output():write(args).

-- Instead of io.read, we can also use io.lines to read from a stream. As we saw in previous examples, io.lines gives an iterator that repeatedly reads from a stream. Given a file name, io.lines will open a stream over the file in read mode and will close it after reaching end of file. When called with no arguments, io.lines will read from the current input stream. We can also use lines as a method over handles. Moreover, since Lua 5.2 io.lines accepts the same options that io.read accepts. As an example, the next fragment copies the current input to the current output, iterating over blocks of 8 KB:
for block in io.input():lines(2^13) do
	io.write(block)
end
