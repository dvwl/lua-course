--[[ Conversions ]]
-- To force a number to be a float, we can simply add 0.0 to it. An integer always can be converted to a float:
print(type(-3))
print(-3 + 0.0) --> -3.0
print(type(-3 + 0.0))
print(0x7fffffffffffffff + 0.0) --> 9.2233720368548e+18

-- Any integer up to 2^53 (which is 9007199254740992) has an exact representation as a double-precision floating-point number. Integers with larger absolute values may lose precision when converted to a float:
print(9007199254740991 + 0.0 == 9007199254740991) --> true
print(9007199254740992 + 0.0 == 9007199254740992) --> true
print(9007199254740993 + 0.0 == 9007199254740993) --> false

-- In the last line, the conversion rounds the integer 2^53+1 to the float 2^53, breaking the equality.

-- To force a number to be an integer, we can OR it with zero:
local value = 2^53
local intValue = value | 0
print(value .. " (" .. math.type(value) .. ")") --> 9.007199254741e+15 (float)
print(intValue .. " (" .. math.type(intValue) .. ")") --> 9007199254740992 (integer)

-- Lua does this kind of conversion only when the number has an exact representation as an integer, that is, it has no fractional part and it is inside the range of integers. Otherwise, Lua raises an error:
--[[
	> 3.2 | 0 -- fractional part stdin:1: number has no integer representation
	> 2^64 | 0 -- out of range stdin:1: number has no integer representation
	> math.random(1, 3.5) -- stdin:1: bad argument #2 to 'random' (number has no integer representation)
]]

-- To round a fractional number, we must explicitly call a rounding function.
-- Another way to force a number into an integer is to use math.tointeger, which returns nil when the number cannot be converted:
print(math.tointeger(-258.0))--> -258
print(math.tointeger(2^30)) --> 1073741824
print(math.tointeger(5.01)) --> nil (not an integral value)
print(math.tointeger(2^64)) --> nil (out of range)

-- This function is particularly useful when we need to check whether the number can be converted. As an example, the following function converts a number to integer when possible, leaving it unchanged otherwise:
function cond2int (x)
	return math.tointeger(x) or x
end
