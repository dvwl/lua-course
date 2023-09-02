--[[ Maths Library ]]
print("[ Maths Library ]")
-- Lua provides a standard math library with a set of mathematical functions, including trigonometric functions (sin, cos, tan, asin, etc.), logarithms, rounding functions, max and min, a function for generating pseudo-random numbers (random), plus the constants pi and huge (the largest representable number, which is the special value inf on most platforms.)
print(math.cos(math.pi)) --> -1.0
print(math.max(10.4, 7, -3, 20)) --> 20
print(math.huge) --> inf

-- All trigonometric functions work in radians. We can use the functions deg and rad to convert between degrees and radians
print(math.deg(math.pi)) --> 180.0
print(math.rad(180)) --> 3.1415926535898

--[[ Random-number generator ]]
print("[ Random-number generator ]")
-- The math.random function generates pseudo-random numbers. We can call it in three ways. When we call it without arguments, it returns a pseudo-random real number with uniform distribution in the interval [0,1). When we call it with only one argument, an integer n, it returns a pseudo-random integer in the interval [1,n]. For instance, we can simulate the result of tossing a die with the call random(6). Finally, we can call random with two integer arguments, l and u, to get a pseudo-random integer in the interval [l,u].
local random_number = math.random()  -- Generates a random number between 0 and 1
print(random_number);
local random_int = math.random(1, 10)  -- Generates a random integer between 1 and 10
print(random_int);

-- We can set a seed for the pseudo-random generator with the function randomseed; its numeric sole argument is the seed. When a program starts, the system initializes the generator with the fixed seed 1. Without another seed, every run of a program will generate the same sequence of pseudo-random numbers. For debugging, this is a nice property; but in a game, we will have the same scenario over and over. A common trick to solve this problem is to use the current time as a seed, with the call math.randomseed(os.time()). (We will see os.time in the section called “The Function os.time”.)	
math.randomseed(os.time())  -- Set the random seed using the current time

--math.randomseed(42)  -- Set a fixed seed for repeatable randomness

-- Generate and print random numbers
for i = 1, 5 do
    print(math.random())  -- Generates a random number between 0 and 1
end

print("----")

-- Generate and print random integers between 1 and 10
for i = 1, 5 do
    print(math.random(1, 10))  -- Generates a random integer between 1 and 10
end

--[[ Rounding functions ]]
print("[ Rounding functions ]")
-- The math library offers three rounding functions: floor, ceil, and modf. Floor rounds towards minus infinite, ceil rounds towards plus infinite, and modf rounds towards zero. They return an integer result if it fits in an integer; otherwise, they return a float (with an integral value, of course). The function modf, besides the rounded value, also returns the fractional part of the number as a second result.
print(math.floor(3.3)) --> 3
print(math.floor(-3.3)) --> -4
print(math.ceil(3.3)) --> 4
print(math.ceil(-3.3)) --> -3
print(math.modf(3.3)) --> 3 0.3
print(math.modf(-3.3)) --> -3 -0.3

-- If the argument is already an integer, it is returned unaltered.

-- If we want to round a number x to the nearest integer, we could compute the floor of x + 0.5. However, this simple addition can introduce errors when the argument is a large integral value. For instance, consider the next fragment:
x = 2^52 + 1
print(string.format("%d %d", x, math.floor(x + 0.5))) --> 4503599627370497 4503599627370498

-- What happens is that 2^52 + 1.5 does not have an exact representation as a float, so it is internally rounded in a way that we cannot control. To avoid this problem, we can treat integral values separately:

function round (x)
	local f = math.floor(x)
	if x == f then 
		return f
	else 
		return math.floor(x + 0.5)
	end
end

-- The previous function will always round half-integers up (e.g., 2.5 will be rounded to 3). If we want unbiased rounding (that rounds half-integers to the nearest even integer), our formula fails when x + 0.5 is an odd integer:

print(math.floor(3.5 + 0.5)) --> 4 (ok)
print(math.floor(2.5 + 0.5)) --> 3 (wrong)

-- Again, the modulo operator for floats shows its usefulness: the test (x % 2.0 == 0.5) is true exactly when x + 0.5 is an odd integer, that is, when our formula would give a wrong result. Based on this fact, it is easy to define a function that does unbiased rounding:
function round2 (x)
	local f = math.floor(x)
	if (x == f) or (x % 2.0 == 0.5) then
		return f
	else
		return math.floor(x + 0.5)
	end
end

print(round2(2.5)) --> 2
print(round2(3.5)) --> 4
print(round2(-2.5)) --> -2
print(round2(-1.5)) --> -2
