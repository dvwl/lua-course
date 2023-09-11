--[[ Other Operations on Files ]]
-- The function io.tmpfile returns a stream over a temporary file, open in read/write mode. This file is automatically removed (deleted) when the program ends.

-- The function flush executes all pending writes to a file. Like the function write, we can call it as a function — io.flush() — to flush the current output stream, or as a method — f:flush() — to flush the stream f.

-- The setvbuf method sets the buffering mode of a stream. Its first argument is a string: "no" means no buffering; "full" means that the stream data is only written out when the buffer is full or when we explicitly flush the file; and "line" means that the output is buffered until a newline is output or there is any input from some special files (such as a terminal device). For the last two options, setvbuf accepts an optional second argument with the buffer size.

-- In most systems, the standard error stream (io.stderr) is not buffered, while the standard output stream (io.stdout) is buffered in line mode. So, if we write incomplete lines to the standard output (e.g., a progress indicator), we may need to flush the stream to see that output.

-- The seek method can both get and set the current position of a stream in a file. Its general form is f:seek(whence, offset), where the whence parameter is a string that specifies how to interpret the offset. Its valid values are "set", for offsets relative to the beginning of the file; "cur", for offsets relative to the current position in the file; and "end", for offsets relative to the end of the file. Independently of the value of whence, the call returns the new current position of the stream, measured in bytes from the beginning of the file.

-- The default value for whence is "cur" and for offset is zero. Therefore, the call file:seek() returns the current stream position, without changing it; the call file:seek("set") resets the position to the beginning of the file (and returns zero); and the call file:seek("end") sets the position to the end of the file and returns its size. The following function gets the file size without changing its current position:
function fsize (file)
	local current = file:seek() -- save current position
	local size = file:seek("end") -- get file size
	file:seek("set", current) -- restore position
	return size
end

--[[ Sample code that uses fsize ]]
--[[
-- Create a temporary test file and write some content to it
local testfile = io.open("other-operations.txt", "w")
testfile:write("This is a test file.")
testfile:close()

-- Open the test file and call the fsize function
local file = io.open("other-operations.txt", "rb")
local size = fsize(file)

-- Close the test file
file:close()
print(size)
]]

-- To complete the set, os.rename changes the name of a file and os.remove removes (deletes) a file. Note that these functions come from the os library, not the io library, because they manipulate real files, not streams.

-- All these functions return nil plus an error message and an error code in case of errors.
