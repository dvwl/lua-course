-- explore proper tail calls and how they affect function behavior.

-- Write a Lua function named calculate_factorial that calculates the factorial of a positive integer using proper tail recursion. The function should take two parameters:
-- n: The positive integer for which the factorial is to be calculated.
-- result (optional, with a default value of 1): An accumulator for the factorial calculation.

-- The function should return the factorial of n. Ensure that the recursive calls are in tail position.

-- Function to calculate factorial using proper tail recursion
function calculate_factorial(n, result)
	-- function goes here
end

-- Test the calculate_factorial function
local n = 5
local factorial = calculate_factorial(n)
print("Factorial of", n, "is", factorial)
