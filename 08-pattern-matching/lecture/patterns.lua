--[[ Patterns ]]
-- Most pattern-matching libraries use the backslash as an escape. However, this choice has some annoying consequences. For the Lua parser, patterns are regular strings. They have no special treatment and follow the same rules as other strings. Only the pattern-matching functions interpret them as patterns. Because the backslash is the escape character in Lua, we have to escape it to pass it to any function. Patterns are naturally hard to read, and writing "\\" instead of "\" everywhere does not help.

-- We could improve this problem with long strings, enclosing patterns between double brackets. (Some languages recommend this practice.) However, the long-string notation seems cumbersome for patterns, which are usually short. Moreover, we would lose the ability to use escapes inside patterns. (Some pattern-matching tools work around this limitation by reimplementing the usual string escapes.)

-- Lua's solution is simpler: patterns in Lua use the percent sign as an escape. (Several functions in C, such as printf and strftime, adopt the same solution.) In general, any escaped alphanumeric character has some special meaning (e.g., '%a' matches any letter), while any escaped non-alphanumeric character represents itself (e.g., '%.' matches a dot).

-- We will start our discussion about patterns with character classes. A character class is an item in a pattern that can match any character in a specific set. For instance, the class %d matches any digit. Therefore, we can search for a date in the format dd/mm/yyyy with the pattern '%d%d/%d%d/%d%d%d%d':
s = "Deadline is 13/09/2023, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.match(s, date)) --> 13/09/2023

-- The following lists the predefined character classes with their meanings:
-- character	meaning
-- .			all characters
-- %a			letters
-- %c			control characters
-- %d			digits
-- %g			printable characters except spaces
-- %l			lower-case letters
-- %p			punctuation characters
-- %s			space characters
-- %u			upper-case letters
-- %w			alphanumeric characters
-- %x			hexadecimal digits

-- An upper-case version of any of these classes represents the complement of the class. For instance, '%A' represents all non-letter characters:
print((string.gsub("hello, up-down!", "%A", "."))) --> hello..up.down.

-- (When printing the results of gsub, I am using extra parentheses to discard its second result, which is the number of substitutions.)

-- Some characters, called magic characters, have special meanings when used in a pattern. Patterns in Lua use the following magic characters:
-- ( ) . % + - * ? [ ] ^ $

-- As we have seen, the percent sign works as an escape for these magic characters. So, '%?' matches a question mark and '%%' matches a percent sign itself. We can escape not only the magic characters, but also any non-alphanumeric character. When in doubt, play safe and use an escape.

-- A char-set allows us to create our own character classes, grouping single characters and classes inside square brackets. For instance, the char-set '[%w_]' matches both alphanumeric characters and underscores, '[01]' matches binary digits, and '[%[%]]' matches square brackets. To count the number of vowels in a text, we can write this code:
local text = "some text"
_, nvow = string.gsub(text, "[AEIOUaeiou]", "")

-- We can also include character ranges in a char-set, by writing the first and the last characters of the range separated by a hyphen. I seldom use this feature, because most useful ranges are predefined; for instance, '%d' substitutes '[0-9]', and '%x' substitutes '[0-9a-fA-F]'. However, if you need to find an octal digit, you may prefer '[0-7]' instead of an explicit enumeration like '[01234567]'.

-- We can get the complement of any char-set by starting it with a caret: the pattern '[^0-7]' finds any character that is not an octal digit and '[^\n]' matches any character different from newline. Nevertheless, remember that you can negate simple classes with its upper-case version: '%S' is simpler than '[^%s]'.

-- We can make patterns still more useful with modifiers for repetitions and optional parts. Patterns in Lua offer four modifiers:
-- modifier		repetitions
-- +			1 or more repetitions
-- *			0 or more repetitions
-- -			0 or more lazy repetitions
-- ?			optional (0 or 1 occurence)

-- The plus modifier matches one or more characters of the original class. It will always get the longest sequence that matches the pattern. For instance, the pattern '%a+' means one or more letters (a word):
print((string.gsub("one, and two; and three", "%a+", "word"))) --> word, word word; word word

-- The pattern '%d+' matches one or more digits (an integer numeral):
print(string.match("the number 1298 is even", "%d+")) --> 1298

-- The asterisk modifier is similar to plus, but it also accepts zero occurrences of characters of the class. A typical use is to match optional spaces between parts of a pattern. For instance, to match an empty parenthesis pair, such as () or ( ), we can use the pattern '%(%s*%)', where the pattern '%s*' matches zero or more spaces. (Parentheses have a special meaning in a pattern, so we must escape them.) As another example, the pattern '[_%a][_%w]*' matches identifiers in a Lua program: a sequence starting with a letter or an underscore, followed by zero or more underscores or alphanumeric characters.

-- Like an asterisk, the minus modifier also matches zero or more occurrences of characters of the original class. However, instead of matching the longest sequence, it matches the shortest one. Sometimes there is no difference between asterisk and minus, but usually they give rather different results. For instance, if we try to find an identifier with the pattern '[_%a][_%w]-', we will find only the first letter, because the '[_%w]-' will always match the empty sequence. On the other hand, suppose we want to erase comments in a C program. Many people would first try '/%*.*%*/' (that is, a "/*" followed by a sequence of any characters followed by "*/", written with the appropriate escapes). However, because the '.*' expands as far as it can, the first "/*" in the program would close only with the last "*/":
test = "int x; /* x */ int y; /* y */"
print((string.gsub(test, "/%*.*%*/", ""))) --> int x;

-- The pattern '.-', instead, will expand only as much as necessary to find the first "*/", so that we get the desired result:
test = "int x; /* x */ int y; /* y */"
print((string.gsub(test, "/%*.-%*/", ""))) --> int x; int y;

-- The last modifier, the question mark, matches an optional character. As an example, suppose we want to find an integer in a text, where the number can contain an optional sign. The pattern '[+-]?%d+' does the job, matching numerals like "-12", "23", and "+1009". The character class '[+-]' matches either a plus or a minus sign; the following ? makes this sign optional.

-- Unlike some other systems, in Lua we can apply a modifier only to a character class; there is no way to group patterns under a modifier. For instance, there is no pattern that matches an optional word (unless the word has only one letter). Usually, we can circumvent this limitation using some of the advanced techniques that we will see in the end of this section.

-- If a pattern begins with a caret, it will match only at the beginning of the subject string. Similarly, if it ends with a dollar sign, it will match only at the end of the subject string. We can use these marks both to restrict the matches that we find and to anchor patterns. For instance, the next test checks whether the string s starts with a digit:
if string.find(s, "^%d") then 
	-- some functionality
end

-- The next one checks whether that string represents an integer number, without any other leading or trailing characters:
if string.find(s, "^[+-]?%d+$") then 
	-- do something with it
end

-- The caret and dollar signs are magic only when used in the beginning or end of the pattern. Otherwise, they act as regular characters matching themselves.

-- Another item in a pattern is '%b', which matches balanced strings. We write this item as '%bxy', where x and y are any two distinct characters; the x acts as an opening character and the y as the closing one. For instance, the pattern '%b()' matches parts of the string that start with a left parenthesis and finish at the respective right one:
s = "a (enclosed (in) parentheses) line"
print((string.gsub(s, "%b()", ""))) --> a line

-- Typically, we use this pattern as '%b()', '%b[]', '%b{}', or '%b<>', but we can use any two distinct characters as delimiters.

-- Finally, the item '%f[char-set]' represents a frontier pattern. It matches an empty string only if the next character is in char-set but the previous one is not:
s = "the anthem is the theme"
print((string.gsub(s, "%f[%w]the%f[%W]", "one"))) --> one anthem is one theme

-- The pattern '%f[%w]' matches a frontier between a non-alphanumeric and an alphanumeric character, and the pattern '%f[%W]' matches a frontier between an alphanumeric and a non-alphanumeric character. Therefore, the given pattern matches the string "the" only as an entire word. Note that we must write the char-set inside brackets, even when it is a single class.

-- The frontier pattern treats the positions before the first and after the last characters in the subject string as if they had the null character (ASCII code zero). In the previous example, the first "the" starts with a frontier between a null character, which is not in the set '[%w]', and a t, which is.
