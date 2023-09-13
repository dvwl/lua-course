--[[ Precompiled Code ]]
-- As I mentioned in the beginning of this chapter, Lua precompiles source code before running it. Lua also allows us to distribute code in precompiled form.

-- The simplest way to produce a precompiled file — also called a binary chunk in Lua jargon — is with the luac program that comes in the standard distribution. For instance, the next call creates a new file prog.lc with a precompiled version of a file prog.lua:
-- $ luac -o prog.lc prog.lua

-- The Lua interpreter can execute this new file just like normal Lua code, performing exactly as it would with the original source:
-- $ lua prog.lc

-- Lua accepts precompiled code mostly anywhere it accepts source code. In particular, both loadfile and load accept precompiled code.

-- We can write a minimal luac directly in Lua:
p = loadfile(arg[1])
f = io.open(arg[2], "wb")
f:write(string.dump(p))
f:close()

-- The key function here is string.dump: it receives a Lua function and returns its precompiled code as a string, properly formatted to be loaded back by Lua.

-- The luac program offers some other interesting options. In particular, option -l lists the opcodes that the compiler generates for a given chunk. As an example, below shows the output of luac with option -l on the following one-line file:
a = x + y - z

-- Example of output from luac -l
--[[
	main <prog.lua:0,0> (10 instructions at 00000000006c9180)
	0+ params, 2 slots, 1 upvalue, 0 locals, 4 constants, 0 functions
		1       [1]     VARARGPREP      0
        2       [1]     GETTABUP        0 0 1   ; _ENV "x"
        3       [1]     GETTABUP        1 0 2   ; _ENV "y"
        4       [1]     ADD             0 0 1
        5       [1]     MMBIN           0 1 6   ; __add
        6       [1]     GETTABUP        1 0 3   ; _ENV "z"
        7       [1]     SUB             0 0 1
        8       [1]     MMBIN           0 1 7   ; __sub
        9       [1]     SETTABUP        0 0 0   ; _ENV "a"
        10      [1]     RETURN          0 1 1   ; 0 out
]]

-- (We will not discuss the internals of Lua in this course; if you are interested in more details about those opcodes, a Web search for "lua opcode" should give you relevant material.)

-- Code in precompiled form is not always smaller than the original, but it loads faster. Another benefit is that it gives a protection against accidental changes in sources. Unlike source code, however, maliciously corrupted binary code can crash the Lua interpreter or even execute user-provided machine code. When running usual code, there is nothing to worry about. However, you should avoid running untrusted code in precompiled form. The function load has an option exactly for this task.

-- Besides its required first argument, load has three more arguments, all of them optional. The second is a name for the chunk, used only in error messages. The fourth argument is an environment, which you need to do some search on Environment. The third argument is the one we are interested here; it controls what kinds of chunks can be loaded. If present, this argument must be a string: the string "t" allows only textual (normal) chunks; "b" allows only binary (precompiled) chunks; "bt", the default, allows both formats.
