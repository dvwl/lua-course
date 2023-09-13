-- Identify the error and implement error handling to gracefully handle it. 
-- The program should prompt the user for a number and attempt to calculate its square root.

-- This program has a compile time and runtime error
print("Enter a number:")
local 1stNum = io.read()
local sqrt = math.sqrt(1stNum)
print("The square root is: " .. sqrt)

-- Example of a test case:
-- 4 
-- 0 
-- -4 
-- a 
-- (

-- use pcall to catch the error and display a message in case of an error
