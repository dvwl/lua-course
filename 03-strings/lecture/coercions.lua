--[[ Coercions ]]
-- Lua provides automatic conversions between numbers and strings at run time. Any numeric operation applied to a string tries to convert the string to a number. Lua applies such coercions not only in arithmetic operators, but also in other places that expect a number, such as the argument to math.sin.
-- Conversely, whenever Lua finds a number where it expects a string, it converts the number to a string:
print(10 .. 20) --> 1020

-- (When we write the concatenation operator right after a numeral, we must separate them with a space; otherwise, Lua thinks that the first dot is a decimal point.

-- Many people argue that these automatic coercions were not a good idea in the design of Lua. As a rule, it is better not to count on them. They are handy in a few places, but add complexity both to the language and to programs that use them.

-- As a reflection of this “second-class status”, Lua 5.3 did not implement a full integration of coercions and integers, favoring instead a simpler and faster implementation. The rule for arithmetic operations is that the result is an integer only when both operands are integers; a string is not an integer, so any arithmetic operation with strings is handled as a floating-point operation:
print("10" + 1) --> 11.0

-- To convert a string to a number explicitly, we can use the function tonumber, which returns nil if the string does not denote a proper number. Otherwise, it returns integers or floats, following the same rules of the Lua scanner:
print(tonumber(" -3 ")) --> -3
print(tonumber(" 10e4 ")) --> 100000.0
print(tonumber("10e")) --> nil (not a valid number)
print(tonumber("0x1.3p-4")) --> 0.07421875

-- By default, tonumber assumes decimal notation, but we can specify any base between 2 and 36 for the conversion:
print(tonumber("100101", 2)) --> 37
print(tonumber("fff", 16)) --> 4095
print(tonumber("-ZZ", 36)) --> -1295
print(tonumber("987", 8)) --> nil

-- In the last line, the string does not represent a proper numeral in the given base, so tonumber returns nil.

-- To convert a number to a string, we can call the function tostring:

print(tostring(10) == "10") --> true

-- These conversions are always valid. Remember, however, that we have no control over the format (e.g., the number of decimal digits in the resulting string). For full control, we should use string.format, which we will see in the next section.

-- Unlike arithmetic operators, order operators never coerce their arguments. Remember that "0" is different from 0. Moreover, 2 < 15 is obviously true, but "2" < "15" is false (alphabetical order). To avoid inconsistent results, Lua raises an error when we mix strings and numbers in an order comparison, such as 2 < "15".
