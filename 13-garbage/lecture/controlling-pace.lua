--[[ Controlling the Pace of Collection ]]
-- The function collectgarbage allows us to exert some control over the garbage collector. It is actually several functions in one: its optional first argument, a string, specifies what to do. Some options have an integer as a second argument, which we call data.
	
-- The options for the first argument are:
-- "stop": stops the collector until another call to collectgarbage with the option "restart".
-- "restart": restarts the collector.
-- "collect": performs a complete garbage-collection cycle, so that all unreachable objects are collected and finalized. This is the default option.
-- "step": performs some garbage-collection work. The second argument, data, specifies the amount of work, which is equivalent to what the collector would do after allocating data bytes.
-- "count": returns the number of kilobytes of memory currently in use by Lua. This result is a floating-point number that multiplied by 1024 gives the exact total number of bytes. The count includes dead objects that have not yet been collected.
-- "setpause": sets the collector's pause parameter. The data parameter gives the new value in percentage points: when data is 100, the parameter is set to 1 (100%).
-- "setstepmul": sets the collector's step multiplier (stepmul) parameter. The new value is given by data, also in percentage points.
	
-- The two parameters pause and stepmul control the collector's character. Any garbage collector trades memory for CPU time. At one extreme, the collector might not run at all. It would spend zero CPU time, at the price of a huge memory consumption. At the other extreme, the collector might run a complete cycle after every single assignment. The program would use the minimum memory necessary, at the price of a huge CPU consumption. The default values for pause and stepmul try to find a balance between those two extremes and are good enough for most applications. In some scenarios, however, it is worth trying to optimize them.

-- The pause parameter controls how long the collector waits between finishing a collection and starting a new one. A pause of zero makes Lua start a new collection as soon as the previous one ends. A pause of 200% waits for memory usage to double before restarting the collector. We can set a lower pause if we want to trade more CPU time for lower memory usage. Typically, we should keep this value between 0 and 200%.

-- The step-multiplier parameter (stepmul) controls how much work the collector does for each kilobyte of memory allocated. The higher this value the less incremental the collector. A huge value like 100000000% makes the collector work like a non-incremental collector. The default value is 200%. Values lower than 100% make the collector so slow that it may never finish a collection.

-- The other options of collectgarbage give us control over when the collector runs. Again, the default control is good enough for most programs, but some specific applications may benefit from a manual control. Games often need this kind of control. For instance, if we do not want any garbage-collection work during some periods, we can stop it with a call collectgarbage("stop") and then restart it with collectgarbage("restart"). In systems where we have periodic idle phases, we can keep the collector stopped and call collectgarbage("step", n) during the idle time. To set how much work to do at each idle period, we can either choose experimentally an appropriate value for n or call collectgarbage in a loop, with n set to zero (meaning minimal steps), until the idle period expires.
