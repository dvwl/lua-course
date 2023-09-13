--[[ Arrays ]]
-- We implement arrays in Lua simply by indexing tables with integers. Therefore, arrays do not have a fixed size, but grow as needed. Usually, when we initialize the array we define its size indirectly. For instance, after the following code, any attempt to access a field outside the range 1–10 will return nil, instead of zero:
local a = {} -- new array
for i = 1, 10 do
	a[i] = 0
end

-- The length operator (#) uses this fact to find the size of an array:
print(#a) --> 10

-- We can start an array at index zero, one, or any other value:
-- create an array with indices from -5 to 5
a = {}
for i = -5, 5 do
	a[i] = 0
end

-- However, it is customary in Lua to start arrays with index one (1). The Lua libraries adhere to this convention; so does the length operator. If our arrays do not start with one, we will not be able to use these facilities.

-- We can use a constructor to create and initialize arrays in a single expression:
squares = {1, 4, 9, 16, 25, 36, 49, 64, 81}

-- Such constructors can be as large as we need. In Lua, it is not uncommon data-description files with constructors with a few million elements.
