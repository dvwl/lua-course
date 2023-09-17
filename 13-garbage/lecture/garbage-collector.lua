--[[ The Garbage Collector ]]
-- Up to version 5.0, Lua used a simple mark-and-sweep garbage collector (GC). This kind of collector is sometimes called a “stop-the-world” collector. This means that, from time to time, Lua would stop running the main program to perform a whole garbage-collection cycle. Each cycle comprises four phases: mark, cleaning, sweep, and finalization.

-- The collector starts the mark phase by marking as alive its root set, which comprises the objects that Lua has direct access to. In Lua, this set is only the C registry. (As we will see in the section called “The registry”, both the main thread and the global environment are predefined entries in this registry.)

-- Any object stored in a live object is reachable by the program, and therefore is marked as alive too. (Of course, entries in weak tables do not follow this rule.) The mark phase ends when all reachable objects are marked as alive.

-- Before starting the sweep phase, Lua performs the cleaning phase, where it handles finalizers and weak tables. First, it traverses all objects marked for finalization looking for non-marked objects. Those objects are marked as alive (resurrected) and put in a separate list, to be used in the finalization phase. Then, Lua traverses its weak tables and removes from them all entries wherein either the key or the value is not marked.

-- The sweep phase traverses all Lua objects. (To allow this traversal, Lua keeps all objects it creates in a linked list.) If an object is not marked as alive, Lua collects it. Otherwise, Lua clears its mark, in preparation for the next cycle.

-- Finally, in the finalization phase, Lua calls the finalizers of the objects that were separated in the cleaning  phase.

-- The use of a real garbage collector means that Lua has no problems with cycles among object references. We do not need to take any special action when using cyclic data structures; they are collected like any other data.

-- In version 5.1, Lua got an incremental collector. This collector performs the same steps as the old one, but it does not need to stop the world while it runs. Instead, it runs interleaved with the interpreter. Every time the interpreter allocates some amount of memory, the collector runs a small step. (This means that, while the collector is working, the interpreter may change an object's reachability. To ensure the correctness of the collector, some operations in the interpreter have barriers that detect dangerous changes and correct the marks of the objects involved.)

-- Lua 5.2 introduced emergency collection. When a memory allocation fails, Lua forces a full collection cycle and tries again the allocation. These emergencies can occur any time Lua allocates memory, including points where Lua is not in a consistent state to run code; so, these collections are unable to run finalizers.
