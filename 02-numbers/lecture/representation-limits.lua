--[[ Representation Limits ]]
-- Most programming languages represent numbers with some fixed number of bits. Therefore, those representations have limits, both in range and in precision

-- Standard Lua uses 64-bit integers. Integers with 64 bits can represent values up to 2^63 - 1, roughly 10^19. (Small Lua uses 32-bit integers, which can count up to two billions, approximately.) The math library defines constants with the maximum (math.maxinteger) and the minimum (math.mininteger) values for an integer.

-- This maximum value for a 64-bit integer is a large number: it is thousands times the total wealth on earth counted in cents of dollars and one billion times the world population. Despite this large value, overflows occur. When we compute an integer operation that would result in a value smaller than mininteger or larger than maxinteger, the result wraps around.

-- In mathematical terms, to wrap around means that the computed result is the only number between mininteger and maxinteger that is equal modulo 2^64 to the mathematical result. In computational terms, it means that we throw away the last carry bit. (This last carry bit would increment a hypothetical 65th bit, which represents 2^64. Thus, to ignore this bit does not change the modulo 2^64 of the value.) This behavior is consistent and predictable in all arithmetic operations with integers in Lua:
print(math.maxinteger + 1 == math.mininteger) --> true
print(math.mininteger - 1 == math.maxinteger) --> true
print(-math.mininteger == math.mininteger) --> true
print(math.mininteger // -1 == math.mininteger) --> true

-- The maximum representable integer is 0x7ff...fff, that is, a number with all bits set to one except the highest bit, which is the signal bit (zero means a non-negative number). When we add one to that number, it becomes 0x800...000, which is the minimum representable integer. The minimum integer has a magnitude one larger than the magnitude of the maximum integer, as we can see here:
print(math.maxinteger) --> 9223372036854775807
print(0x7fffffffffffffff) --> 9223372036854775807
print(math.mininteger) --> -9223372036854775808
print(0x8000000000000000) --> -9223372036854775808

-- For floating-point numbers, Standard Lua uses double precision. It represents each number with 64 bits, 11 of which are used for the exponent. Double-precision floating-point numbers can represent numbers with roughly 16 significant decimal digits, in a range from -10^308 to 10^308. (Small Lua uses single-precision floats, with 32 bits. In this case, the range is from -10^38 to 10^38, with roughly seven significant decimal digits.)

-- The range of double-precision floats is large enough for most practical applications, but we must always acknowledge the limited precision. The situation here is not different from what happens with pen and paper. If we use ten digits to represent a number, 1/7 becomes rounded to 0.142857142. If we compute 1/7 * 7 using ten digits, the result will be 0.999999994, which is different from 1. Moreover, numbers that have a finite representation in decimal can have an infinite representation in binary. For instance, 12.7 - 20 + 7.3 is not exactly zero even when computed with double precision, because both 12.7 and 7.3 do not have an exact finite representation in binary (see Exercise 3.5).

-- Because integers and floats have different limits, we can expect that arithmetic operations will give different results for integers and floats when the results reach these limits:
print(math.maxinteger + 2) --> -9223372036854775807
print(math.maxinteger + 2.0) --> 9.2233720368548e+18

-- In this example, both results are mathematically incorrect, but in quite different ways. The first line makes an integer addition, so the result wraps around. The second line makes a float addition, so the result is rounded to an approximate value, as we can see in the following equality:
print(math.maxinteger + 2.0 == math.maxinteger + 1.0) --> true

-- Each representation has its own strengths. Of course, only floats can represent fractional numbers. Floats have a much larger range, but the range where they can represent integers exactly is restricted to [-253,253]. (Those are quite large numbers nevertheless.) Up to these limits, we can mostly ignore the differences between integers and floats. Outside these limits, we should think more carefully about the representations we are using.
