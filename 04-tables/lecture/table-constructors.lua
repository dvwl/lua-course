--[[ Table Construction ]]
-- Constructors are expressions that create and initialize tables. They are a distinctive feature of Lua and one of its most useful and versatile mechanisms.

-- The simplest constructor is the empty constructor, {}, as we have seen. Constructors also initialize lists. For instance, the following statement will initialize days[1] with the string "Sunday" (the first element of the constructor has index 1, not 0), days[2] with "Monday", and so on:
days = {"Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday"}
print(days[4]) --> Wednesday

-- Lua also offers a special syntax to initialize a record-like table, as in the next example:
a = {x = 10, y = 20}

-- This previous line is equivalent to these commands:
a = {}; a.x = 10; a.y = 20

-- The original expression, however, is faster, because Lua creates the table already with the right size.

-- No matter what constructor we use to create a table, we can always add fields to and remove fields from the result:
w = {x = 0, y = 0, label = "console"}
x = {math.sin(0), math.sin(1), math.sin(2)}
w[1] = "another field" -- add key 1 to table 'w'
x.f = w -- add key "f" to table 'x'
print(w["x"]) --> 0
print(w[1]) --> another field
print(x.f[1]) --> another field
w.x = nil -- remove field "x"

-- However, as I just mentioned, creating a table with a proper constructor is more efficient, besides being cleaner.

-- We can mix record-style and list-style initializations in the same constructor:
polyline = {
	color="blue",
	thickness=2,
	npoints=4,
	{x=0,	y=0}, -- polyline[1]
	{x=-10, y=0}, -- polyline[2]
	{x=-10, y=1}, -- polyline[3]
	{x=0,	y=1} -- polyline[4]
}

-- The above example also illustrates how we can nest tables (and constructors) to represent more complex data structures. Each of the elements polyline[i] is a table representing a record:
print(polyline[2].x) --> -10
print(polyline[4].y) --> 1

-- Those two constructor forms have their limitations. For instance, we cannot initialize fields with negative indices, nor with string indices that are not proper identifiers. For such needs, there is another, more general, format. In this format, we explicitly write each index as an expression, between square brackets:
opnames = {
	["+"] = "add", 
	["-"] = "sub", 
	["*"] = "mul", 
	["/"] = "div"
}
 
i = 20; s = "-"
a = {[i+0] = s, [i+1] = s..s, [i+2] = s..s..s}
 
print(opnames[s]) --> sub
print(a[22]) --> ---

--  This syntax is more cumbersome, but more flexible too: both the list-style and the record-style forms are special cases of this more general syntax, as we show in the following equivalences:
--[[
{x = 0, y = 0} <--> {["x"] = 0, ["y"] = 0}
{"r", "g", "b"} <--> {[1] = "r", [2] = "g", [3] = "b"}
]] 

-- We can always put a comma after the last entry. These trailing commas are optional, but are always valid:
a = {[1] = "red", [2] = "green", [3] = "blue",}

-- This flexibility frees programs that generate Lua constructors from the need to handle the last element as a special case.

-- Finally, we can always use a semicolon instead of a comma in a constructor. This facility is a leftover from older Lua versions and I guess it is seldom used nowadays.
