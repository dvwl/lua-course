--[[ Precedence ]]
-- Operator precedence in Lua follows the table below, from the higher to the lower priority:
--[[
	^
	unary operators (- # ~ not)
	* / // %
	+ -
	.. (concatentation)
	<< >> (bitwise shifts)
	& (bitwise AND)
	~ (bitwise exclusive OR)
	| (bitwise OR)
	< > <= >= ~= ==
	and
	or
]]

-- All binary operators are left associative, except for exponentiation and concatenation, which are right associative. Therefore, the following expressions on the left are equivalent to those on the right:
--[[
	a+i < b/2+1			<-->	(a+i) < ((b/2)+1)
	5+x^2*8				<-->	5+((x^2)*8)
	a < y and y <= z	<-->	(a < y) and (y <= z)
	-x^2				<-->	-(x^2)
	x^y^z				<-->	x^(y^z)
]]

-- When in doubt, always use explicit parentheses. It is easier than looking it up in the manual and others will probably have the same doubt when reading your code

-- Example 1: Arithmetic Operators
local result = 10 + 5 * 2
print(result) -- Output: 20
-- In this example, multiplication (*) has higher precedence than addition (+), so it's evaluated first.

-- Example 2: Comparison Operators
local x = 5
local y = 8
local z = 10
local result1 = x < y and y <= z
print(result1) -- Output: true
-- In this example, the logical AND operator (and) has lower precedence than comparison operators (< and <=), so comparisons are evaluated first.

-- Example 3: Logical Operators
local a = true
local b = false
local c = true
local result2 = a or b and c
print(result2) -- Output: true
-- In this example, the logical AND operator (and) has higher precedence than the logical OR operator (or), so it's evaluated first.

-- Example 4: Bitwise Operators
local num1 = 6 -- binary: 0110
local num2 = 3 -- binary: 0011
local result3 = num1 & num2 | 1
print(result3) -- Output: 3
-- In this example, the bitwise AND operator (&) has higher precedence than the bitwise OR operator (|), so it's evaluated first.

-- Example 5: Grouping with Parentheses
local result4 = (7 + 3) * 2
print(result4) -- Output: 20
-- You can use parentheses to override operator precedence and explicitly specify the order of evaluation.

-- Example 6: Function Calls
local function foo() 
	return 5
end

local function bar() 
	return 15 - 5
end

local result5 = foo() + bar() * 2
print(result5) -- Output: 25
-- Function calls have high precedence, so they are evaluated before arithmetic operations.
