--[[ Long strings ]]
-- We can delimit literal strings also by matching double square brackets, as we do with long comments. Literals in this bracketed form can run for several lines and do not interpret escape sequences. Moreover, it ignores the first character of the string when this character is a newline. This form is especially convenient for writing strings that contain large pieces of code, as in the following example:
page = [[
 <html>
 <head>
   <title>An HTML Page</title>
 </head>
 <body>
   <a href="http://www.lua.org">Lua</a>
 </body>
 </html>
 ]]
print(page)

-- Sometimes, we may need to enclose a piece of code containing something like a = b[c[i]] (notice the ]] in this code), or we may need to enclose some code that already has some code commented out. To handle such cases, we can add any number of equals signs between the two opening brackets, as in [===[. After this change, the literal string ends only at the next closing brackets with the same number of equals signs in between (]===], in our example). The scanner ignores any pairs of brackets with a different number of equals signs. By choosing an appropriate number of signs, we can enclose any literal string without having to modify it in any way.

-- This same facility is valid for comments, too. For instance, if we start a long comment with --[=[, it extends until the next ]=]. This facility allows us to comment out easily a piece of code that contains parts already commented out.

-- Long strings are the ideal format to include literal text in our code, but we should not use them for non-text literals. Although literal strings in Lua can contain arbitrary bytes, it is not a good idea to use this feature (e.g., you may have problems with your text editor); moreover, end-of-line sequences like "\r\n" may be normalized to "\n" when read. Instead, it is better to code arbitrary binary data using numeric escape sequences either in decimal or in hexadecimal, such as "\x13\x01\xA1\xBB". However, this poses a problem for long strings, because they would result in quite long lines. For those situations, since version 5.2 Lua offers the escape sequence \z: it skips all subsequent space characters in the string until the first non-space character. The next example illustrates its use:

data = "\x00\x01\x02\x03\x04\x05\x06\x07\z\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"
print(data)

-- The \z at the end of the first line skips the following end-of-line and the indentation of the second line, so that the byte \x08 directly follows \x07 in the resulting string.
