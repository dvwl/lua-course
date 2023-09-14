--[[ The Single-Method Approach ]]
-- A particular case of the previous approach for object-oriented programming occurs when an object has a single method. In such cases, we do not need to create an interface table; instead, we can return this single method as the object representation. If this sounds a little weird, it is worth remembering iterators like io.lines or string.gmatch. An iterator that keeps state internally is nothing more than a single-method object.

-- Another interesting case of single-method objects occurs when this single-method is actually a dispatch method that performs different tasks based on a distinguished argument. A prototypical implementation for such an object is as follows:
function newObject (value)
	return function (action, v)
		if action == "get" then return value
		elseif action == "set" then value = v
		else error("invalid action")
		end
	end
end

-- Its use is straightforward:
d = newObject(0)
print(d("get")) --> 0
d("set", 10)
print(d("get")) --> 10

-- This unconventional implementation for objects is quite effective. The syntax d("set", 10), although peculiar, is only two characters longer than the more conventional d:set(10). Each object uses one single closure, which is usually cheaper than one table. There is no inheritance, but we have full privacy: the only way to access an object state is through its sole method.

-- Tcl/Tk uses a similar approach for its widgets. The name of a widget in Tk denotes a function (a widget command) that can perform all kinds of operations over the widget, according to its first argument.
