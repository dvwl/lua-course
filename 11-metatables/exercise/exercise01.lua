-- Create a metatable to represent units of measurement and perform automatic unit conversion when adding two values with different units.

-- Create a metatable unitMeta with the __add metamethod that allows for unit conversion when adding values.

-- Define tables, distance, a metatable set to unitMeta. The metatable should store the unit name and conversion factor.

-- Implement the __add metamethod to convert values with different units and return the result.

-- Test your implementation by adding distances and times with different units, and ensure that the conversions are handled correctly.

-- Insert your code here

-- Test unit conversion
distance.value, distance.unit = 5, "km"

distance2.value, distance2.unit = 50, "m"

result, unit = distance + distance2
print("Total Distance:", result, unit) -- Output: Total Distance: 5050 m
