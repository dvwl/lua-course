--[[ Table Indices ]]
-- Each table can store values with different types of indices, and it grows as needed to accommodate new entries:
a = {} -- empty table
-- create 1000 new entries
for i = 1, 1000 do 
	a[i] = i*2 
end
print(a[9]) --> 18
a["x"] = 10
print(a["x"]) --> 10
print(a["y"]) --> nil

-- Note the last line: like global variables, table fields evaluate to nil when not initialized. Also like global variables, we can assign nil to a table field to delete it. This is not a coincidence: Lua stores global variables in ordinary tables.

-- To represent structures, we use the field name as an index. Lua supports this representation by providing a.name as syntactic sugar for a["name"]. Therefore, we could write the last lines of the previous example in a cleaner manner as follows:
a = {} -- empty table
a.x = 10 -- same as a["x"] = 10
print(a.x) --> 10 -- same as a["x"]
print(a.y) --> nil -- same as a["y"]

-- For Lua, the two forms are equivalent and can be intermixed freely. For a human reader, however, each form may signal a different intention. The dot notation clearly shows that we are using the table as a structure, where we have some set of fixed, predefined keys. The string notation gives the idea that the table can have any string as a key, and that for some reason we are manipulating that specific key.

-- A common mistake for beginners is to confuse a.x with a[x]. The first form represents a["x"], that is, a table indexed by the string "x". The second form is a table indexed by the value of the variable x.
-- See the difference:
a = {}
x = "y"
a[x] = 10 -- put 10 in field "y"
print(a[x]) --> 10 -- value of field "y"
print(a.x) --> nil -- value of field "x" (undefined)
print(a.y) --> 10 -- value of field "y"

-- Because we can index a table with any type, when indexing a table we have the same subtleties that arise in equality. Although we can index a table both with the number 0 and with the string "0", these two values are different and therefore denote different entries in a table. Similarly, the strings "+1", "01", and "1" all denote different entries. When in doubt about the actual types of your indices, use an explicit conversion to be sure:
i = 10; j = "10"; k = "+10"
a = {}
a[i] = "number key"
a[j] = "string key"
a[k] = "another string key"
print(a[i]) --> number key
print(a[j]) --> string key
print(a[k]) --> another string key
print(a[tonumber(j)]) --> number key
print(a[tonumber(k)]) --> number key

-- You can introduce subtle bugs in your program if you do not pay attention to this point.

-- Integers and floats do not have the above problem. In the same way that 2 compares equal to 2.0, both values refer to the same table entry, when used as keys:
a = {}
a[2.0] = 10
a[2.1] = 20
print(a[2]) --> 10
print(a[2.1]) --> 20

-- More specifically, when used as a key, any float value that can be converted to an integer is converted. For instance, when Lua executes a[2.0] = 10, it converts the key 2.0 to 2. Float values that cannot be converted to integers remain unaltered.
