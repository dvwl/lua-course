--[[ Table Traversal ]]
-- We can traverse all key–value pairs in a table with the pairs iterator:
t = {10, print, x = 12, k = "hi"}
for k, v in pairs(t) do
    print(k, v)
end
--> 1 10
--> 2 function: 0000000065b9cff0
--> k hi
--> x 12
print("--------")

-- Due to the way that Lua implements tables, the order that elements appear in a traversal is undefined. The same program can produce different orders each time it runs. The only certainty is that each element will appear once during the traversal.

-- For lists, we can use the ipairs iterator:
t = {10, print, 12, "hi"}
for k, v in ipairs(t) do
    print(k, v)
end
--> 1 10
--> 2 function: 0000000065b9cff0
--> 3 12
--> 4 hi
print("--------")

-- In this case, Lua trivially ensures the order.

-- Another way to traverse a sequence is with a numerical for:
t = {10, print, 12, "hi"}
for k = 1, #t do
    print(k, t[k])
end
--> 1 10
--> 2 function: 0000000065b9cff0
--> 3 12
--> 4 hi
