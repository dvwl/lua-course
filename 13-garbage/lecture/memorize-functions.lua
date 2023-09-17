--[[ Memorize Functions ]]
-- A common programming technique is to trade space for time. We can speed up a function by memorizing its results so that, later, when we call the function with the same argument, the function can reuse that result.1

-- Imagine a generic server that takes requests in the form of strings with Lua code. Each time it gets a request, it runs load on the string, and then calls the resulting function. However, load is an expensive function, and some commands to the server may be quite frequent. Instead of calling load repeatedly each time it receives a common command like "closeconnection()", the server can memorize the results from load using an auxiliary table. Before calling load, the server checks in the table whether the given string already has a translation. If it cannot find a match, then (and only then) the server calls load and stores the result into the table. We can pack this behavior in a new function:
local results = {}
function mem_loadstring (s)
	local res = results[s]
	if res == nil then -- result not available?
		res = assert(load(s)) -- compute new result
		results[s] = res -- save for later reuse
	end
	return res
end

-- The savings with this scheme can be huge. However, it may also cause unsuspected waste. Although some commands repeat over and over, many other commands happen only once. Gradually, the table results accumulates all commands the server has ever received plus their respective codes; after enough time, this behavior will exhaust the server's memory.

-- A weak table provides a simple solution to this problem. If the results table has weak values, each garbage-collection cycle will remove all translations not in use at that moment (which means virtually all of them):
local results = {}
setmetatable(results, {__mode = "v"}) -- make values weak
function mem_loadstring (s)
	local res = results[s]
	if res == nil then -- result not available?
		res = assert(load(s)) -- compute new result
		results[s] = res -- save for later reuse
	end
	return res
end

-- Actually, because the indices are always strings, we can make this table fully weak, if we want:
setmetatable(results, {__mode = "kv"})

-- The net result is the same.

-- The memorization technique is useful also to ensure the uniqueness of some kind of object. For instance, assume a system that represents colors as tables, with fields red, green, and blue in some range. A naive color factory generates a new color for each new request:
function createRGB (r, g, b)
	return {red = r, green = g, blue = b}
end

-- Using memorization, we can reuse the same table for the same color. To create a unique key for each color, we simply concatenate the color indices with a separator in between:
local results = {}
setmetatable(results, {__mode = "v"}) -- make values weak
function createRGB (r, g, b)
	local key = string.format("%d-%d-%d", r, g, b)
	local color = results[key]
	if color == nil then
		color = {red = r, green = g, blue = b}
		results[key] = color
	end
	return color
end

-- An interesting consequence of this implementation is that the user can compare colors using the primitive equality operator, because two coexistent equal colors are always represented by the same table. Any given color can be represented by different tables at different times, because from time to time the garbage collector clears the results table. However, as long as a given color is in use, it is not removed from results. So, whenever a color survives long enough to be compared with a new one, its representation also has survived long enough to be reused by the new color.
