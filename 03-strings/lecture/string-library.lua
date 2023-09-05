--[[ The String Library ]]
-- The power of a raw Lua interpreter to manipulate strings is quite limited. A program can create string literals, concatenate them, compare them, and get string lengths. However, it cannot extract substrings or examine their contents. The full power to manipulate strings in Lua comes from its string library.

-- As I mentioned before, the string library assumes one-byte characters. This equivalence is true for several encodings (e.g., ASCII or ISO-8859-1), but it breaks in any Unicode encoding. Nevertheless, as we will see, several parts of the string library are quite useful for UTF-8.

-- Some functions in the string library are quite simple: the call string.len(s) returns the length of a string s; it is equivalent to #s. The call string.rep(s, n) returns the string s repeated n times; we can create a string of 1 MB (e.g., for tests) with string.rep("a", 2^20). The function string.reverse reverses a string. The call string.lower(s) returns a copy of s with the upper-case letters converted to lower case; all other characters in the string are unchanged. The function string.upper converts to upper case.
print(string.rep("abc", 3)) --> abcabcabc
print(string.reverse("A Long Line!")) --> !eniL gnoL A
print(string.lower("A Long Line!")) --> a long line!
print(string.upper("A Long Line!")) --> A LONG LINE!

-- As a typical use, if we want to compare two strings regardless of case, we can write something like this:
a = "abc"
b = "def"
print(string.lower(a) < string.lower(b)) --> true

-- The call string.sub(s, i, j) extracts a piece of the string s, from the i-th to the j-th character inclusive. (The first character of a string has index 1.) We can also use negative indices, which count from the end of the string: index -1 refers to the last character, -2 to the previous one, and so on. Therefore, the call string.sub(s, 1, j) gets a prefix of the string s with length j; string.sub(s, j, -1) gets a suffix of the string, starting at the j-th character; and string.sub(s, 2, -2) returns a copy of the string s with the first and last characters removed:
s = "[in brackets]"
print(string.sub(s, 2, -2)) --> in brackets
print(string.sub(s, 1, 1)) --> [
print(string.sub(s, -1, -1)) --> ]

-- Remember that strings in Lua are immutable. Like any other function in Lua, string.sub does not change the value of a string, but returns a new string. A common mistake is to write something like string.sub(s, 2, -2) and assume that it will modify the value of s. If we want to modify the value of a variable, we must assign the new value to it:
s = string.sub(s, 2, -2)
print(s) --> string are immutable, therefore, "in brackets"

-- The functions string.char and string.byte convert between characters and their internal numeric representations. The function string.char gets zero or more integers, converts each one to a character, and returns a string concatenating all these characters. The call string.byte(s, i) returns the internal numeric representation of the i-th character of the string s; the second argument is optional; the call string.byte(s) returns the internal numeric representation of the first (or single) character of s.

-- The following examples assume the ASCII encoding for characters:
print(string.char(97)) --> a
i = 99; print(string.char(i, i+1, i+2)) --> cde
print(string.byte("abc")) --> 97
print(string.byte("abc", 2)) --> 98
print(string.byte("abc", -1)) --> 99

-- In the last line, we used a negative index to access the last character of the string.

-- A call like string.byte(s, i, j) returns multiple values with the numeric representation of all characters between indices i and j (inclusive):
print(string.byte("abc", 1, 2)) --> 97 98

-- A nice idiom is {string.byte(s, 1, -1)}, which creates a list with the codes of all characters in s. (This idiom only works for strings somewhat shorter than 1 MB. Lua limits its stack size, which in turn limits the maximum number of returns from a function. The default stack limit is one million entries.)

-- The function string.format is a powerful tool for formatting strings and converting numbers to 	strings. It returns a copy of its first argument, the so-called format string, with each directive in that string replaced by a formatted version of its correspondent argument. The directives in the format string have rules similar to those of the C function printf. A directive is a percent sign plus a letter that tells how to format the argument: d for a decimal integer, x for hexadecimal, f for a floating-point number, s for strings, plus several others.
print(string.format("x = %d y = %d", 10, 20)) --> x = 10 y = 20
print(string.format("x = %x", 200)) --> x = c8
print(string.format("x = 0x%X", 200)) --> x = 0xC8
print(string.format("x = %f", 200)) --> x = 200.000000
tag, title = "h1", "a title"
print(string.format("<%s>%s</%s>", tag, title, tag))
--> <h1>a title</h1>
	
-- Between the percent sign and the letter, a directive can include other options that control the details of the formatting, such as the number of decimal digits of a floating-point number:
print(string.format("pi = %.4f", math.pi)) --> pi = 3.1416
d = 5; m = 11; y = 1990
print(string.format("%02d/%02d/%04d", d, m, y)) --> 05/11/1990

-- In the first example, the %.4f means a floating-point number with four digits after the decimal point. In the second example, the %02d means a decimal number with zero padding and at least two digits; the directive %2d, without the zero, would use blanks for padding. For a complete description of these directives, see the documentation of the C function printf, as Lua calls the standard C library to do the hard work here.

-- We can call all functions from the string library as methods on strings, using the colon operator. For instance, we can rewrite the call string.sub(s, i, j) as s:sub(i, j); string.upper(s) becomes s:upper(). (We will discuss the colon operator in detail in Object-Oriented Programming.)

-- The string library includes also several functions based on pattern matching. The function string.find searches for a pattern in a given string:
print(string.find("hello world", "wor")) --> 7 9
print(string.find("hello world", "war")) --> nil

-- It returns the initial and final positions of the pattern in the string, or nil if it cannot find the pattern. The function string.gsub (Global SUBstitution) replaces all occurrences of a pattern in a string with	another string:
print(string.gsub("hello world", "l", ".")) --> he..o wor.d 3
print(string.gsub("hello world", "ll", "..")) --> he..o world 1
print(string.gsub("hello world", "a", ".")) --> hello world 0

-- It also returns, as a second result, the number of replacements it made.
