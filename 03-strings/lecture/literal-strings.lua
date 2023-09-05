--[[ Literal strings ]]
-- We can delimit literal strings by single or double matching quotes:
a = "a line"
b = 'another line'
print(a)
print(b)

-- They are equivalent; the only difference is that inside each kind of quote we can use the other quote without escapes.
-- As a matter of style, most programmers always use the same kind of quotes for the same kind of strings, where the “kinds” of strings depend on the program. For instance, a library that manipulates XML may reserve single-quoted strings for XML fragments, because those fragments often contain double quotes.
-- Strings in Lua can contain the following C-like escape sequences
--[[
	\a bell
	\b back space
	\f form feed
	\n newline
	\r carriage return
	\t horizontal tab
	\v vertical tab
	\\ backslash
	\" double quote
	\' single quote
]]

-- The following examples illustrate their use:
print("one line\nnext line\n\"in quotes\", 'in quotes'")
print('a backslash inside quotes: \'\\\'')
print("a simpler way: '\\'")

-- We can specify a character in a literal string also by its numeric value through the escape sequences \ddd and \xhh, where ddd is a sequence of up to three decimal digits and hh is a sequence of exactly two hexadecimal digits. As a somewhat artificial example, the two literals "ALO\n123\"" and '\x41LO\10\04923"' have the same value in a system using ASCII: 0x41 (65 in decimal) is the ASCII code for A, 10 is the code for newline, and 49 is the code for the digit 1. (In this example we must write 49 with three digits, as \049, because it is followed by another digit; otherwise Lua would read the escape as \492.) We could also write that same string as '\x41\x4c\x4f\x0a\x31\x32\x33\x22', representing each character by its hexadecimal code.
-- Since Lua 5.3, we can also specify UTF-8 characters with the escape sequence \u{h... h}; we can write any number of hexadecimal digits inside the brackets:
print("\u{3b1} \u{3b2} \u{3b3}") --> ╬▒ ╬▓ ╬│
-- (The above example assumes an UTF-8 terminal.)
