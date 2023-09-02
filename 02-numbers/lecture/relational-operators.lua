--[[ Relational Operators ]]
-- Lua provides the following relational operators:
-- Operators   Description
--     <       Less than
--     >       Greater than
--     <=      Less than or equal to
--     >=      Greater than or equal to
--     ==      Equal to
--     ~=      Not equal to

-- All these operators always produce a Boolean value.

-- The == operator tests for equality; the ~= operator is the negation of equality. We can apply these operators to any two values. If the values have different types, Lua considers them not equal. Otherwise, Lua compares them according to their types.

-- Comparison of numbers always disregards their subtypes; it makes no difference whether the number is represented as an integer or as a float. What matters is its mathematical value. (Nevertheless, it is slightly more efficient to compare numbers with the same subtypes.)

local a = 5
local b = 10

print(a == b)  -- false
print(a ~= b)  -- true
print(a < b)   -- true
print(a > b)   -- false
print(a <= b)  -- true
print(a >= b)  -- false

-- These operators can be used with various types of values, including numbers, strings, and other comparable types. When used with strings, Lua compares them based on their lexicographical order.

local str1 = "apple"
local str2 = "banana"

print(str1 < str2)  -- true
print(str1 > str2)  -- false

-- Keep in mind that when dealing with non-numeric types, the results might not always be intuitive, so be cautious when using relational operators with different types of values.
