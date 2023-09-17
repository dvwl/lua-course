--[[ Weak Tables ]]
-- As we said, a garbage collector cannot guess what we consider garbage. A typical example is a stack, implemented with an array and an index to the top. We know that the valid part of the array goes only up to the top, but Lua does not. If we pop an element by simply decrementing the top, the object left in the array is not garbage to Lua. Similarly, any object stored in a global variable is not garbage to Lua, even if our program will never use it again. In both cases, it is up to us (i.e., our program) to assign nil to these positions so that they do not lock an otherwise disposable object.

-- However, simply cleaning our references is not always enough. Some constructions need extra collaboration between the program and the collector. A typical example happens when we want to keep a list of all live objects of some kind (e.g., files) in our program. This task seems simple: all we have to do is to insert each new object into the list. However, once the object is part of the list, it will never be collected! Even if nothing else points to it, the list does. Lua cannot know that this reference should not prevent the reclamation of the object, unless we tell Lua about this fact.

-- Weak tables are the mechanism that we use to tell Lua that a reference should not prevent the reclamation of an object. A weak reference is a reference to an object that is not considered by the garbage collector. If all references pointing to an object are weak, the collector will collect the object and delete these weak references. Lua implements weak references through weak tables: a weak table is a table whose entries are weak. This means that, if an object is held only in weak tables, Lua will eventually collect the object.

-- Tables have keys and values, and both can contain any kind of object. Under normal circumstances, the garbage collector does not collect objects that appear as keys or as values of an accessible table. That is, both keys and values are strong references, as they prevent the reclamation of objects they refer to. In a weak table, both keys and values can be weak. This means that there are three kinds of weak tables: tables with weak keys, tables with weak values, and tables where both keys and values are weak. Irrespective of the kind of table, when a key or a value is collected the whole entry disappears from the table.

-- The weakness of a table is given by the field __mode of its metatable. The value of this field, when present, should be a string: if this string is "k", the keys in the table are weak; if this string is "v", the values in the table are weak; if this string is "kv", both keys and values are weak. The following example, although artificial, illustrates the basic behavior of weak tables:

a = {}
mt = {__mode = "k"}
setmetatable(a, mt) -- now 'a' has weak keys
key = {} -- creates first key
a[key] = 1
key = {} -- creates second key
a[key] = 2
collectgarbage() -- forces a garbage collection cycle
for k, v in pairs(a) do print(v) end --> 2

-- In this example, the second assignment key = {} overwrites the reference to the first key. The call to collectgarbage forces the garbage collector to do a full collection. As there is no other reference to the first key, Lua collects this key and removes the corresponding entry in the table. The second key, however, is still anchored in the variable key, so Lua does not collect it.

-- Notice that only objects can be removed from a weak table. Values, such as numbers and Booleans, are not collectible. For instance, if we insert a numeric key in the table a (from our previous example), the collector will never remove it. Of course, if the value corresponding to a numeric key is collected in a table with weak values, then the whole entry is removed from the table.

-- Strings present a subtlety here: although strings are collectible from an implementation point of view, they are not like other collectible objects. Other objects, such as tables and closures, are created explicitly. For instance, whenever Lua evaluates the expression {}, it creates a new table. However, does Lua create a new string when it evaluates "a".."b"? What if there is already a string "ab" in the system? Does Lua create a new one? Can the compiler create this string before running the program? It does not matter: these are implementation details. From the programmer's point of view, strings are values, not objects. Therefore, like a number or a Boolean, a string key is not removed from a weak table unless its associated value is collected.
