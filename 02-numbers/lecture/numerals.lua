--[[ Numerals ]]
-- we can write numeric constants with an optional decimal part plus an optional decimal exponent, like these examples:
--  > 4 --> 4
--  > 0.4 --> 0.4
--  > 4.57e-3 --> 0.00457
--  > 0.3e12 --> 300000000000.0
--  > 5E+20 --> 5e+20

-- Numerals with a decimal point or an exponent are considered floats; otherwise, they are treated as integers.
-- Both integer and float values have type "number"
print(type(3)) --> number
print(type(3.5)) --> number

-- They have the same type because, more often than not, they are interchangeable. Moreover, integers and floats with the same value compare as equal in Lua:
--  > -15 == -15.0 --> true
--  > 0.2e3 == 200 --> true

-- In the rare occasions when we need to distinguish between floats and integers, we can use math.type
print(math.type(8)) --> integer
print(math.type(8.0)) --> float

-- Like many other programming languages, Lua supports hexadecimal constants, by prefixing them with 0x. Unlike many other programming languages, Lua supports also floating-point hexadecimal constants, which can have a fractional part and a binary exponent, prefixed by p or P^2
-- The following examples illustrate this format:
print(0xff) --> 255
print(0x1A3) --> 419
print(0x0.2) --> 0.125
print(0x1p-1) --> 0.5
print(0xa.bp2) --> 42.75

-- Lua can write numbers in this format using string.format with the %a option:
print(string.format("%a", 419)) --> 0x1.a3p+8
print(string.format("%a", 0.1)) --> 0x1.999999999999ap-4

-- Although not very friendly to humans, this format preserves the full precision of any float value, and the conversion is faster than with decimals.
