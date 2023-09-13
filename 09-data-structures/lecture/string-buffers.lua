--[[ String Buffers ]]
-- Suppose we are building a string piecemeal, for instance reading a file line by line. Our typical code could look like this:
local buff = ""
for line in io.lines() do
	buff = buff .. line .. "\n"
end

-- Despite its innocent look, this code in Lua can cause a huge performance penalty for large files: for instance, it takes more than 30 seconds to read a 4.5 MB file on my new machine.

-- Why is that? To understand what happens, let us imagine that we are in the middle of the read loop; each line has 20 bytes and we have already read some 2500 lines, so buff is a string with 50 kB. When Lua concatenates buff..line.."\n", it allocates a new string with 50020 bytes and copies the 50000 bytes from buff into this new string. That is, for each new line, Lua moves around 50 kB of memory, and growing. The algorithm is quadratic. After reading 100 new lines (only 2 kB), Lua has already moved more than 5 MB of memory. When Lua finishes reading 350 kB, it has moved around more than 50 GB. (This problem is not peculiar to Lua: other languages wherein strings are immutable values present a similar behavior, Java being a famous example.)

-- Before we continue, we should remark that, despite all I said, this situation is not a common problem. For small strings, the above loop is fine. To read an entire file, Lua provides the io.read("a") option, which reads the file at once. However, sometimes we must face this problem. Java offers the StringBuffer class to ameliorate the problem. In Lua, we can use a table as the string buffer. The key to this approach is the function table.concat, which returns the concatenation of all the strings of a given list. Using concat, we can write our previous loop as follows:
local t = {}
for line in io.lines() do
	t[#t + 1] = line .. "\n"
end
local s = table.concat(t)

-- This algorithm takes less than 0.05 seconds to read the same file that took more than half a minute to read with the original code. (Nevertheless, for reading a whole file it is still better to use io.read with the "a" option.)

-- We can do even better. The function concat accepts an optional second argument, which is a separator to be inserted between the strings. Using this separator, we do not need to insert a newline after each line:
local t = {}
for line in io.lines() do
	t[#t + 1] = line
end
s = table.concat(t, "\n") .. "\n"

-- The function inserts the separator between the strings, but we still have to add the last newline. This last concatenation creates a new copy of the resulting string, which can be quite long. There is no option to make concat insert this extra separator, but we can deceive it, inserting an extra empty string in t:
t[#t + 1] = ""
s = table.concat(t, "\n")

-- Now, the extra newline that concat adds before this empty string is at the end of the resulting string, as we wanted.
