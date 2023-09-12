-- Create a Lua function called createCounter that returns a closure. The closure should be used to count the number of times it has been called. Each time the closure is called, it should return the current count value.

function createCounter()
	local count = 0
	-- insert your code here
end

local counter = createCounter()

-- Test the counter
print(counter())  -- Should print 1
print(counter())  -- Should print 2
print(counter())  -- Should print 3
