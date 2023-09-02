--[[ Arithmetic Operators ]]
-- Lua presents the usual set of arithmetic operators: addition, subtraction, multiplication, division, and negation (unary minus). It also supports floor division, modulo, and exponentiation.
-- One of the main guidelines for the introduction of integers in Lua 5.3 was that “the programmer may choose to mostly ignore the difference between integers and floats or to assume complete control over the representation of each number.”
-- Therefore, any arithmetic operator should give the same result when working on integers and when working on reals.
-- The addition of two integers is always an integer. The same is true for subtraction, multiplication, and negation. 
-- For those operations, it does not matter whether the operands are integers or floats with integral values (except in case of overflows, which we will discuss in the section called “Representation Limits”); the result is the same in both cases:
print(13 + 15) --> 28
print(13.0 + 15.0) --> 28.0

-- If both operands are integers, the operation gives an integer result; otherwise, the operation results in a
-- float. In case of mixed operands, Lua converts the integer one to a float before the operation:
--  > 13.0 + 25 --> 38.0
--  > -(3 * 6.0) --> -18.0
-- Division does not follow that rule, because the division of two integers does not need to be an integer. (In mathematical terms, we say that the integers are not closed under division.) To avoid different results between division of integers and divisions of floats, division always operates on floats and gives float results:
print(3.0 / 2.0) --> 1.5
print(3 / 2) --> 1.5

-- For integer division, Lua 5.3 introduced a new operator, called floor division and denoted by //. As its name implies, floor division always rounds the quotient towards minus infinity, ensuring an integral result for all operands. With this definition, this operation can follow the same rule of the other arithmetic operators: if both operands are integers, the result is an integer; otherwise, the result is a float (with an integral value):
print(-9 // 2) --> -5
print(1.5 // 0.5) --> 3.0

-- The following equation defines the modulo operator:
--  a % b == a - ((a // b) * b)

-- Integral operands ensure integral results, so this operator also follows the rule of other arithmetic operations: if both operands are integers, the result is an integer; otherwise, the result is a float.
-- For integer operands, modulo has the usual meaning, with the result always having the same sign as the second argument. In particular, for any given positive constant K, the result of the expression x % K is always in the range [0,K-1], even when x is negative. For instance, i % 2 always results in 0 or 1, for any integer i.
-- For real operands, modulo has some unexpected uses. For instance, x - x % 0.01 is x with exactly two decimal digits, and x - x % 0.001 is x with exactly three decimal digits:
x = math.pi
print(x - x%0.01) --> 3.14
print(x - x%0.001) --> 3.141

-- As another example of the use of the modulo operator, suppose we want to check whether a vehicle turning a given angle will start to backtrack. If the angle is in degrees, we can use the following formula:
local tolerance = 10
function isturnback (angle)
	angle = angle % 360
	return (math.abs(angle - 180) < tolerance)
end

-- This definition works even for negative angles:
print(isturnback(-180)) --> true

 -- If we want to work with radians instead of degrees, we simply change the constants in our function:
local toleranceRad = 0.17
function isturnbackRad (angle)
	angle = angle % (2*math.pi)
	return (math.abs(angle - math.pi) < toleranceRad)
end

-- 8 degree = 0.139 radian
print(isturnbackRad(0.139)) --> false

-- The operation angle % (2 * math.pi) is all we need to normalize any angle to a value in the interval [0, 2#).
-- Lua also offers an exponentiation operator, denoted by a caret (^). Like division, it always operates on floats. (Integers are not closed under exponentiation; for instance, 2^-2 is not an integer.) We can write x^0.5 to compute the square root of x and x^(1/3) to compute its cubic root.
