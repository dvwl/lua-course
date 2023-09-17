--[[ Ephemeron (Short-lived) Tables ]]
-- A tricky situation occurs when, in a table with weak keys, a value refers to its own key.

-- This scenario is more common than it may seem. As a typical example, consider a constant-function factory. Such a factory takes an object and returns a function that, whenever called, returns that object:
function factory (o)
	return (function () return o end)
end

-- This factory is a good candidate for memorization, to avoid the creation of a new closure when there is one already available. Below shows this improvement:
do
	local mem = {} -- memorization table
	setmetatable(mem, {__mode = "k"})
	function factory (o)
		local res = mem[o]
		if not res then
			res = (function () return o end)
			mem[o] = res
		end
		return res
	end
end

-- There is a catch, however. Note that the value (the constant function) associated with an object in mem refers back to its own key (the object itself). Although the keys in that table are weak, the values are not. From a standard interpretation of weak tables, nothing would ever be removed from that memorizing table. Because values are not weak, there is always a strong reference to each function. Each function refers to its corresponding object, so there is always a strong reference to each key. Therefore, these objects would not be collected, despite the weak keys.

-- This strict interpretation, however, is not very useful. Most people expect that a value in a table is only accessible through its respective key. We can think of the above scenario as a kind of cycle, where the closure refers to the object that refers back (through the memorizing table) to the closure.

-- Lua solves the above problem with the concept of ephemeron tables. In Lua, a table with weak keys and strong values is an ephemeron table. In an ephemeron table, the accessibility of a key controls the accessibility of its corresponding value. More specifically, consider an entry (k,v) in an ephemeron table. The reference to v is only strong if there is some other external reference to k. Otherwise, the collector will eventually collect k and remove the entry from the table, even if v refers (directly or indirectly) to k.

-- Note: Ephemeron tables were introduced in Lua 5.2. Lua 5.1 still has the problem we described.
