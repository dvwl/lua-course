--[[ Unicode ]]
-- Since version 5.3, Lua includes a small library to support operations on Unicode strings encoded in UTF-8. Even before that library, Lua already offered a reasonable support for UTF-8 strings

-- UTF-8 is the dominant encoding for Unicode on the Web. Because of its compatibility with ASCII, UTF-8 is also the ideal encoding for Lua. That compatibility is enough to ensure that several string-manipulation techniques that work on ASCII strings also work on UTF-8 with no modifications.

-- UTF-8 represents each Unicode character using a variable number of bytes. For instance, it represents A with one byte, 65; it represents the Hebrew character Aleph, which has code 1488 in Unicode, with the two-byte sequence 215-144. UTF-8 represents all characters in the ASCII range as in ASCII, that is, with a single byte smaller than 128. It represents all other characters using sequences of bytes where the first byte is in the range [194,244] and the continuation bytes are in the range [128,191]. More specifically, the range of the starting bytes for two-byte sequences is [194,223]; for three-byte sequences, the range is [224,239]; and for four-byte sequences, it is [240,244]. None of those ranges overlap. This property ensures that the code sequence of any character never appears as part of the code sequence of any other character. In particular, a byte smaller than 128 never appears in a multibyte sequence; it always represents its corresponding ASCII character.

-- Several things in Lua “just work” for UTF-8 strings. Because Lua is 8-bit clean, it can read, write, and store UTF-8 strings just like other strings. Literal strings can contain UTF-8 data. (Of course, you probably will want to edit your source code as a UTF-8 file in a UTF-8-aware editor.) The concatenation operation works correctly for UTF-8 strings. String order operators (less than, less equal, etc.) compare UTF-8 strings following the order of their character codes in Unicode.

-- Lua's operating-system library and I/O library are mainly interfaces to the underlying system, so their support for UTF-8 strings depends on that underlying system. On Linux, for instance, we can use UTF-8 for file names, but Windows uses UTF-16. Therefore, to manipulate Unicode file names on Windows, we need either extra libraries or changes to the standard Lua libraries.

-- Let us now see how functions from the string library handle UTF-8 strings. The functions reverse, upper, lower, byte, and char do not work for UTF-8 strings, as all of them assume that one character is equivalent to one byte. The functions string.format and string.rep work without problems with UTF-8 strings except for the format option '%c', which assumes that one character is one byte. The functions string.len and string.sub work correctly with UTF-8 strings, with indices referring to byte counts (not character counts). More often than not, this is what we need.

-- Let us now have a look at the new utf8 library. The function utf8.len returns the number of UTF-8 characters (codepoints) in a given string. Moreover, it validates the string: if it finds any invalid byte sequence, it returns false plus the position of the first invalid byte:
print(utf8.len("résumé")) --> 6
print(utf8.len("ação")) --> 4
print(utf8.len("Månen")) --> 5
print(utf8.len("ab\x93")) --> nil 3

-- (Of course, to run these examples we need a terminal that understands UTF-8.)
-- The functions utf8.char and utf8.codepoint are the equivalent of string.char and string.byte in the UTF-8 world:
print(utf8.char(114, 233, 115, 117, 109, 233)) --> résumé
print(utf8.codepoint("résumé", 6, 7)) --> 109 233

-- Note the indices in the last line. Most functions in the utf8 library work with indices in bytes. For instance, the call string.codepoint(s, i, j) considers both i and j to be byte positions in string s. If we want to use character indices, the function utf8.offset converts a character position to a byte position:
s = "Nähdään"
print(utf8.codepoint(s, utf8.offset(s, 5))) --> 228
print(utf8.char(228)) --> ä

-- In this example, we used utf8.offset to get the byte index of the fifth character in the string, and then provided that index to codepoint.
	
-- As in the string library, the character index for utf8.offset can be negative, in which case the counting is from the end of the string:
s = "ÃøÆËÐ"
string.sub(s, utf8.offset(s, -2)) --> ËÐ

-- The last function in the utf8 library is utf8.codes. It allows us to iterate over the characters in a UTF-8 string:
for i, c in utf8.codes("Ação") do
	print(i, c)
end
--> 1 65
--> 2 231
--> 4 227
--> 6 111
