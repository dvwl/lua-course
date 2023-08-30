-- Exercise 01
-- Run the factorial example with a negative number
-- Modify the example to fix the problem 

-- defines a factorial function
function fact (n)
	if n == 0 then
	return 1
	else
	return n * fact(n - 1)
	end
	end
	
	print("enter a number:")
	a = io.read("*n") -- reads a number
	print(fact(a))