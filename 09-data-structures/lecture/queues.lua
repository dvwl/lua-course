--[[ Queues and Double-Ended Queues ]]
-- A simple way to implement queues in Lua is with functions insert and remove from the table library. As we saw in the section called “The Table Library”, these functions insert and remove elements in any position of an array, moving other elements to accommodate the operation. However, these moves can be expensive for large structures. A more efficient implementation uses two indices, one for the first element and another for the last. With that representation, we can insert or remove an element at both ends in constant time, as shown below.
function listNew ()
	return {first = 0, last = -1}
end

function pushFirst (list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function pushLast (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function popFirst (list)
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil -- to allow garbage collection
	list.first = first + 1
	return value
end

function popLast (list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil -- to allow garbage collection
	list.last = last - 1
	return value
end

-- If we use this structure in a strict queue discipline, calling only pushLast and popFirst, both first and last will increase continually. However, because we represent arrays in Lua with tables, we can index them either from 1 to 20 or from 16777201 to 16777220. With 64-bit integers, such a queue can run for thirty thousand years, doing ten million insertions per second, before it has problems with overflows.

-- Double-ended queue application
-- Create a new deque
local deque = listNew()

-- Push elements to the front of the deque
pushFirst(deque, 1)
pushFirst(deque, 2)
pushFirst(deque, 3)

-- Push elements to the end of the deque
pushLast(deque, 4)
pushLast(deque, 5)
pushLast(deque, 6)

-- List is now 3 2 1 4 5 6

-- Pop elements from the front and back of the deque
local frontValue = popFirst(deque)
local backValue = popLast(deque)

-- Print the deque and popped values
print("Deque:")
for i = deque.first, deque.last do
    print(deque[i])
end

print("\nPopped Front Value:", frontValue) --> Popped Front Value: 3
print("Popped Back Value:", backValue) --> Popped Back Value: 6
