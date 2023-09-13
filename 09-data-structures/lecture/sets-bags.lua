--[[ Sets and Bags ]]
-- Suppose we want to list all identifiers used in a program source; for that, we need to filter the reserved words out of our listing. Some C programmers could be tempted to represent the set of reserved words as an array of strings and search this array to know whether a given word is in the set. To speed up the search, they could even use a binary tree to represent the set.

-- In Lua, an efficient and simple way to represent such sets is to put the set elements as indices in a table. Then, instead of searching the table for a given element, we just index the table and test whether the result is nil. In our example, we could write the following code:
reserved = {
	["while"] = true, ["if"] = true,
	["else"] = true, ["do"] = true,
}

local s = "while if else do something"
for w in string.gmatch(s, "[%a_][%w_]*") do
	if not reserved[w] then
		-- do something with 'w'
		-- 'w' is not a reserved word
	end
end

-- (In the definition of reserved, we cannot write while = true, because while is not a valid name in Lua. Instead, we use the notation ["while"] = true.)

-- We can have a clearer initialization using an auxiliary function to build the set:
function Set (list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
 	return set
end
 
reserved = Set{"while", "end", "function", "local"}

-- We can also use another set to collect the identifiers:
local ids = {}
for w in string.gmatch(s, "[%a_][%w_]*") do
	if not reserved[w] then
		ids[w] = true
 	end
end

-- print each identifier once
for w in pairs(ids) do print(w) end

-- Function to insert an element into a set
function insertIntoSet(set, element)
    set[element] = true
end

-- Function to remove an element from a set
function removeFromSet(set, element)
    set[element] = nil
end

-- Bags, also called multisets, differ from regular sets in that each element can appear multiple times. An easy representation for bags in Lua is similar to the previous representation for sets, but with a counter associated with each key.

-- To insert an element, we increment its counter:
function insertIntoBag (bag, element)
	bag[element] = (bag[element] or 0) + 1
end

-- To remove an element, we decrement its counter:
function removeFromBag (bag, element)
	local count = bag[element]
 	bag[element] = (count and count > 1) and count - 1 or nil
end

-- We only keep the counter if it already exists and it is still greater than zero.

-- Sets and Bags application
-- Create a new empty set and bag
local mySet = {}
local myBag = {}

-- Insert elements into the set and bag
insertIntoSet(mySet, "apple")
insertIntoSet(mySet, "banana")
insertIntoSet(mySet, "cherry")

insertIntoBag(myBag, "apple")
insertIntoBag(myBag, "banana")
insertIntoBag(myBag, "banana") -- Duplicate element

-- Remove an element from the set and bag
removeFromSet(mySet, "banana")
removeFromBag(myBag, "banana")

-- Print the contents of the set and bag
print("Set:")
for element, _ in pairs(mySet) do
    print(element)
end

print("\nBag:")
for element, count in pairs(myBag) do
    print(element .. " (Count: " .. count .. ")")
end
