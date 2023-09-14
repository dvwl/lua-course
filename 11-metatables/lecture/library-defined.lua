--[[ Library-Defined Metamethods ]]
-- So far, all the metamethods we have seen are for the Lua core. It is the virtual machine who detects that the values involved in an operation have metatables with metamethods for that particular operation. However, because metatables are regular tables, anyone can use them. So, it is a common practice for libraries to define and use their own fields in metatables.

-- The function tostring provides a typical example. As we saw earlier, tostring represents tables in a rather simple format:
print({}) --> table: 0x8062ac0

-- The function print always calls tostring to format its output. However, when formatting any value, tostring first checks whether the value has a __tostring metamethod. In this case, tostring calls the metamethod to do its job, passing the object as an argument. Whatever this metamethod returns is the result of tostring.

-- In our example with sets, we have already defined a function to present a set as a string. So, we need only to set the __tostring field in the metatable:
mt.__tostring = Set.tostring

-- After that, whenever we call print with a set as its argument, print calls tostring that calls Set.tostring:
s1 = Set.new{10, 4, 5}
print(s1) --> {4, 5, 10}

-- The functions setmetatable and getmetatable also use a metafield, in this case to protect metatables. Suppose we want to protect our sets, so that users can neither see nor change their metatables. If we set a __metatable field in the metatable, getmetatable will return the value of this field, whereas setmetatable will raise an error:
mt.__metatable = "not your business"
 
s1 = Set.new{}
print(getmetatable(s1)) --> not your business
setmetatable(s1, {}) --> stdin:1: cannot change protected metatable

-- Since Lua 5.2, pairs also have a metamethod, so that we can modify the way a table is traversed and add a traversal behavior to non-table objects. When an object has a __pairs metamethod, pairs will call it to do all its work.
