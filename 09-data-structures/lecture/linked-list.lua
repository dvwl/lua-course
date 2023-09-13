--[[ Linked Lists ]]
-- Because tables are dynamic entities, it is easy to implement linked lists in Lua. We represent each node with a table (what else?); links are simply table fields that contain references to other tables. For instance, let us implement a singly-linked list, where each node has two fields, value and next. A simple variable is the list root:
list = nil

-- To insert an element at the beginning of the list, with a value v, we do this:
local v = 5; local v2 = 10; local v3 = 15
list = {next = list, value = v}
list = {next = list, value = v2}
list = {next = list, value = v3}

-- To traverse the list, we write this:
local l = list
while l do
	print(l.value) --> 15 10 5
	l = l.next
end

-- We can also implement easily other kinds of lists, such as doubly-linked lists or circular lists. However, we seldom need those structures in Lua, because usually there is a simpler way to represent our data without using linked lists. For instance, we can represent a stack with an (unbounded) array.