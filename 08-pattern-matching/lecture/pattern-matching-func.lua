--[[ The Pattern-Matching Functions ]]
-- The string library offers four functions based on patterns. We have already had a glimpse at find and gsub; the other two are match and gmatch (Global Match). Now we will see all of them in detail.

--[[ string.find ]]
-- The function string.find searches for a pattern inside a given subject string. The simplest form of a pattern is a word, which matches only a copy of itself. For instance, the pattern 'hello' will search for the substring "hello" inside the subject string. When string.find finds its pattern, it returns two values: the index where the match begins and the index where the match ends. If it does not find a match, it returns nil:
s = "hello world"
i, j = string.find(s, "hello")
print(i, j) --> 1 5
print(string.sub(s, i, j)) --> hello
print(string.find(s, "world")) --> 7 11
i, j = string.find(s, "l")
print(i, j) --> 3 3
print(string.find(s, "lll")) --> nil

-- When a match succeeds, we can call string.sub with the values returned by find to get the part of the subject string that matched the pattern. For simple patterns, this is necessarily the pattern itself.

-- The function string.find has two optional parameters. The third parameter is an index that tells where in the subject string to start the search. The fourth parameter, a Boolean, indicates a plain search. A plain search, as the name implies, does a plain “find substring” search in the subject, ignoring patterns:
-- string.find("a [word]", "[") --> stdin:1: malformed pattern (missing ']')
string.find("a [word]", "[", 1, true) --> 3 3

-- In the first call, the function complains because '[' has a special meaning in patterns. In the second call, the function treats '[' as a simple string. Note that we cannot pass the fourth optional parameter without the third one.

--[[ string.match ]]
-- The function string.match is similar to find, in the sense that it also searches for a pattern in a string. However, instead of returning the positions where it found the pattern, it returns the part of the subject string that matched the pattern.
print(string.match("hello world", "hello")) --> hello

-- For fixed patterns such as 'hello', this function is pointless. It shows its power when used with variable patterns, as in the next example:
date = "Today is 17/7/1990"
d = string.match(date, "%d+/%d+/%d+")
print(d) --> 17/7/1990

-- Shortly we will discuss the meaning of the pattern '%d+/%d+/%d+' and more advanced uses for string.match.

--[[ string.gsub ]]
-- The function string.gsub has three mandatory parameters: a subject string, a pattern, and a replacement string. Its basic use is to substitute the replacement string for all occurrences of the pattern inside the subject string:
s = string.gsub("Lua is cute", "cute", "great")
print(s) --> Lua is great
s = string.gsub("all lii", "l", "x")
print(s) --> axx xii
s = string.gsub("Lua is great", "Sol", "Sun")
print(s) --> Lua is great

-- An optional fourth parameter limits the number of substitutions to be made:
s = string.gsub("all lii", "l", "x", 1)
print(s) --> axl lii
s = string.gsub("all lii", "l", "x", 2)
print(s) --> axx lii

-- Instead of a replacement string, the third argument to string.gsub can be also a function or a table, which is called (or indexed) to produce the replacement string; we will cover this feature in the section called “Replacements”.
	
-- The function string.gsub also returns as a second result the number of times it made the substitution.

--[[ string.gmatch ]]
-- The function string.gmatch returns a function that iterates over all occurrences of a pattern in a string. For instance, the following example collects all words of a given string s:
s = "some string"
words = {}
for w in string.gmatch(s, "%a+") do
	words[#words + 1] = w
end
	
-- As we will discuss shortly, the pattern '%a+' matches sequences of one or more alphabetic characters (that is, words). So, the for loop will iterate over all words of the subject string, storing them in the list words.
