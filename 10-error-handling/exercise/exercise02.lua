-- Identify the error and implement error handling to deal with the "File not found" situation.

-- This program has a runtime error
print("Enter the name of the file to read:")
local fileName = io.read()
local file = io.open(fileName, "r")

-- Attempt to read and display the content
local content = file:read("a")
print("File content:")
print(content)
file:close()
