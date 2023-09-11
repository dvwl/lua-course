--[[ The Simple I/O Model ]]
-- The I/O library offers two different models for file manipulation. The simple model assumes a current input stream and a current output stream, and its I/O operations operate on these streams. The library initializes the current input stream to the process's standard input (stdin) and the current output stream to the process's standard output (stdout). Therefore, when we execute something like io.read(), we read a line from the standard input.

-- We can change these current streams with the functions io.input and io.output. A call like io.input(filename) opens a stream over the given file in read mode and sets it as the current input stream. From this point on, all input will come from this file, until another call to io.input. The function io.output does a similar job for output. In case of error, both functions raise the error. If you want to handle errors directly, you should use the complete I/O model.

-- As write is simpler than read, we will look at it first. The function io.write simply takes an arbitrary number of strings (or numbers) and writes them to the current output stream. Because we can call it with multiple arguments, we should avoid calls like io.write(a..b..c); the call io.write(a, b, c) accomplishes the same effect with fewer resources, as it avoids the concatenations.

-- As a rule, you should use print only for quick-and-dirty programs or debugging; always use io.write when you need full control over your output. Unlike print, write adds no extra characters to the output, such as tabs or newlines. Moreover, io.write allows you to redirect your output, whereas print always uses the standard output. Finally, print automatically applies tostring to its arguments; this is handy for debugging, but it also can hide subtle bugs.

-- The function io.write converts numbers to strings following the usual conversion rules; for full control over this conversion, we should use string.format:
io.write("sin(3) = ", math.sin(3), "\n") --> sin(3) = 0.14112000805987
io.write(string.format("sin(3) = %.4f\n", math.sin(3))) --> sin(3) = 0.1411

-- Note: when you use io.write() without specifying the file path, it writes to the standard output or console by default.

--[[
local outputFile = io.open("simple.txt", "w")
io.output(outputFile)
io.write("sin(3) = ", math.sin(3), "\n")
io.write(string.format("sin(3) = %.4f\n", math.sin(3)))
io.close(outputFile)
]]

-- The function io.read reads strings from the current input stream. Its arguments control what to read:
-- argument		description
-- "a"			reads the whole file
-- "l"			reads the next line (dropping the newline)
-- "L"			reads the next line (keeping the newline)
-- "n"			reads a number
-- num			reads num characters as a string

-- Note: Lua 5.3 still accepts the asterisk for compatibility

-- The call io.read("a") reads the whole current input file, starting at its current position. If we are at the end of the file, or if the file is empty, the call returns an empty string.

-- Because Lua handles long strings efficiently, a simple technique for writing filters in Lua is to read the whole file into a string, process the string, and then write the string to the output:
t = io.read("a") -- read the whole file
t = string.gsub(t, "bad", "good") -- do the job
io.write(t) -- write the file

-- As a more concrete example, the following chunk is a complete program to code a file's content using the MIME quoted-printable encoding. This encoding codes each non-ASCII byte as =xx, where xx is the value of the byte in hexadecimal. To keep the consistency of the encoding, it must encode the equals sign as well:
t = io.read("all")
t = string.gsub(t, "([\128-\255=])", function (c)
		return string.format("=%02X", string.byte(c))
	end)
io.write(t)

-- The function string.gsub will match all non-ASCII bytes (codes from 128 to 255), plus the equals sign, and call the given function to provide a replacement. (We will discuss pattern matching in detail in Pattern Matching.)

-- The call io.read("l") returns the next line from the current input stream, without the newline character; the call io.read("L") is similar, but it keeps the newline (if present in the file). When we reach the end of file, the call returns nil, as there is no next line to return. Option "l" is the default for read. Usually, I use this option only when the algorithm naturally handles the data line by line; otherwise, I favor reading the whole file at once, with option "a", or in blocks, as we will see later.

-- As a simple example of the use of line-oriented input, the following program copies its current input to the current output, numbering each line:
for count = 1, math.huge do
	local line = io.read("L")
	if line == nil then break end
	io.write(string.format("%6d ", count), line)
end

-- However, to iterate on a whole file line by line, the io.lines iterator allows a simpler code:
local count = 0
for line in io.lines() do
	count = count + 1
	io.write(string.format("%6d ", count), line, "\n")
end

--  As another example of line-oriented input, file-sort.lua, shows a complete program to sort the lines of a file.

-- The call io.read("n") reads a number from the current input stream. This is the only case where read returns a number (integer or float, following the same rules of the Lua scanner) instead of a string. If, after skipping spaces, io.read cannot find a numeral at the current file position (because of bad format or end of file), it returns nil.

-- Besides the basic read patterns, we can call read with a number n as an argument: in this case, it tries to read n characters from the input stream. If it cannot read any character (end of file), the call returns nil; otherwise, it returns a string with at most n characters from the stream. As an example of this read pattern, the following program is an efficient way to copy a file from stdin to stdout:
while true do
	local block = io.read(2^13) -- block size is 8K
	if not block then break end
	io.write(block)
end

-- As a special case, io.read(0) works as a test for end of file: it returns an empty string if there is more to be read or nil otherwise.

-- We can call read with multiple options; for each argument, the function will return the respective result.

-- Suppose we have a file with three numbers per line:
--  6.0		-3.23	15e12
--  4.3		234		1000001
--  ...

-- Now we want to print the maximum value of each line. We can read all three numbers of each line with a single call to read:
while true do
	local n1, n2, n3 = io.read("n", "n", "n")
	if not n1 then break end
	print(math.max(n1, n2, n3))
end
