--[[ Finalizers ]]
-- Although the goal of the garbage collector is to collect Lua objects, it can also help programs to release external resources. For that purpose, several programming languages offer finalizers. A finalizer is a function associated with an object that is called when that object is about to be collected.

-- Lua implements finalizers through the metamethod __gc, as the following example illustrates:
o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})
o = nil
collectgarbage() --> hi

-- In this example, we first create a table and give it a metatable that has a __gc metamethod. Then we erase the only link to the table (the global variable o) and force a complete garbage collection. During the collection, Lua detects that the table is no longer accessible, and therefore calls its finalizer —the __gc metamethod.

-- A subtlety of finalizers in Lua is the concept of marking an object for finalization. We mark an object for finalization by setting a metatable for it with a non-null __gc metamethod. If we do not mark the object, it will not be finalized. Most code we write works naturally, but some strange cases can occur, like here:
o = {x = "hi"}
mt = {}
setmetatable(o, mt)
mt.__gc = function (o) print(o.x) end
o = nil
collectgarbage() --> (prints nothing)

-- Here, the metatable we set for o does not have a __gc metamethod, so the object is not marked for finalization. Even if we later add a __gc field to the metatable, Lua does not detect that assignment as something special, so it will not mark the object.

-- As we said, this is seldom a problem; it is not usual to change metamethods after setting a metatable. If you really need to set the metamethod later, you can provide any value for the __gc field, as a placeholder:
o = {x = "hi"}
mt = {__gc = true}
setmetatable(o, mt)
mt.__gc = function (o) print(o.x) end
o = nil
collectgarbage() --> hi

-- Now, because the metatable has a __gc field, o is properly marked for finalization. There is no problem if you do not set a metamethod later; Lua only calls the finalizer if it is a proper function.

-- When the collector finalizes several objects in the same cycle, it calls their finalizers in the reverse order that the objects were marked for finalization. Consider the next example, which creates a linked list of objects with finalizers:
mt = {__gc = function (o) print(o[1]) end}

list = nil
for i = 1, 3 do
	list = setmetatable({i, link = list}, mt)
end
list = nil
collectgarbage()
--> 3
--> 2
--> 1
--> 0

-- The first object to be finalized is object 3, which was the last to be marked.

-- A common misconception is to think that links among objects being collected can affect the order that they are finalized. For instance, one can think that object 2 in the previous example must be finalized before object 1 because there is a link from 2 to 1. However, links can form cycles. Therefore, they do not impose any order to finalizers.

-- Another tricky point about finalizers is resurrection. When a finalizer is called, it gets the object being finalized as a parameter. So, the object becomes alive again, at least during the finalization. I call this a transient resurrection. While the finalizer runs, nothing stops it from storing the object in a global variable, for instance, so that it remains accessible after the finalizer returns. I call this a permanent resurrection.

-- Resurrection must be transitive. Consider the following piece of code:
A = {x = "this is A"}
B = {f = A}
setmetatable(B, {__gc = function (o) print(o.f.x) end})
A, B = nil
collectgarbage() --> this is A

-- The finalizer for B accesses A, so A cannot be collected before the finalization of B. Lua must resurrect both B and A before running that finalizer.

-- Because of resurrection, Lua collects objects with finalizers in two phases. The first time the collector detects that an object with a finalizer is not reachable, the collector resurrects the object and queues it to be finalized. Once its finalizer runs, Lua marks the object as finalized. The next time the collector detects that the object is not reachable, it deletes the object. If we want to ensure that all garbage in our program has been actually released, we must call collectgarbage twice; the second call will delete the objects that were finalized during the first call.

-- The finalizer for each object runs exactly once, due to the mark that Lua puts on finalized objects. If an object is not collected until the end of a program, Lua will call its finalizer when the entire Lua state is closed. This last feature allows a form of atexit functions in Lua, that is, functions that will run immediately before the program terminates. All we have to do is to create a table with a finalizer and anchor it somewhere, for instance in a global variable:
local t = {__gc = function ()
	-- your 'atexit' code comes here
	print("finishing Lua program")
end}
setmetatable(t, t)
_G["*AA*"] = t

-- Another interesting technique allows a program to call a given function every time Lua completes a collection cycle. As a finalizer runs only once, the trick here is to make each finalization create a new object to run the next finalizer, as in below:
do
	local mt = {__gc = function (o)
		-- whatever you want to do
		print("new cycle")
		-- creates new object for next cycle
		setmetatable({}, getmetatable(o))
	end}
	-- creates first object
	setmetatable({}, mt)
end

collectgarbage() --> new cycle
collectgarbage() --> new cycle
collectgarbage() --> new cycle

-- The interaction of objects with finalizers and weak tables also has a subtlety. At each cycle, the collector clears the values in weak tables before calling the finalizers, but it clears the keys after it. The rationale for this behavior is that frequently we use tables with weak keys to hold properties of an object (as we discussed in the section called “Object Attributes”), and therefore finalizers may need to access those attributes. However, we use tables with weak values to reuse live objects; in this case, objects being finalized are not useful anymore.
