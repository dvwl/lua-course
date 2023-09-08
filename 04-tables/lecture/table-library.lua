--[[ The Table Library ]]
-- The table library offers several useful functions to operate over lists and sequences.

-- The function table.insert inserts an element in a given position of a sequence, moving up other elements to open space. For instance, if t is the list {10, 20, 30}, after the call table.insert(t, 1, 15) it will become {15, 10, 20, 30}. As a special and frequent case, if we call insert without a position, it inserts the element in the last position of the sequence, moving no elements. As an example, the following code reads the input stream line by line, storing all lines in a sequence:
t = {}
for line in io.lines() do
	if line == "quit" then
		break -- Terminate the loop
	end
    table.insert(t, line)
end
print(#t) --> (number of lines read)

-- The function table.remove removes and returns an element from the given position in a sequence, moving subsequent elements down to fill the gap. When called without a position, it removes the last element of the sequence.

-- With these two functions, it is straightforward to implement stacks, queues, and double queues. We can initialize such structures as t = {}. A push operation is equivalent to table.insert(t, x); a pop operation is equivalent to table.remove(t). The call table.insert(t, 1, x) inserts at the other end of the structure (its beginning, actually), and table.remove(t, 1) removes from this end. The last two operations are not particularly efficient, as they must move elements up and down. However, because the table library implements these functions in C, these loops are not too expensive, so that this implementation is good enough for small arrays (up to a few hundred elements, say).

-- A helper function to print the content of a table before introducing the next section
function print_table(arr)
    for i, v in ipairs(arr) do
        print(i, v)
    end
end

-- Lua 5.3 has introduced a more general function for moving elements in a table. The call table.move(a, f, e, t) moves the elements in table a from index f until e (both inclusive) to position t. For instance, to insert an element in the beginning of a list a, we can do the following:
a = {10, 20, 30}
print("Before move:")
print_table(a)

table.move(a, 1, #a, 2)
local newElement = 5
a[1] = newElement
print("After move:")
print_table(a)

-- The next code removes the first element:
table.move(a, 2, #a, 1)
a[#a] = nil
print("After removing first element:")
print_table(a)

-- Note that, as is common in computing, a move actually copies values from one place to another. In this last example, we must explicitly erase the last element after the move.

-- We can call table.move with an extra optional parameter, a table. In that case, the function moves the elements from the first table into the second one. For instance, the call table.move(a, 1, #a, 1, {}) returns a clone of list a (by copying all its elements into a new list), while table.move(a, 1, #a, #b + 1, b) appends all elements from list a to the end of list b.
