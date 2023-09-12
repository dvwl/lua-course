--[[ Replacements ]]
-- As we have seen already, we can use either a function or a table as the third argument to string.gsub, instead of a string. When invoked with a function, string.gsub calls the function every time it finds a match; the arguments to each call are the captures, and the value that the function returns becomes the replacement string. When invoked with a table, string.gsub looks up the table using the first capture as the key, and the associated value is used as the replacement string. If the result from the call or from the table lookup is nil, gsub does not change the match.

-- As a first example, the following function does variable expansion: it substitutes the value of the global variable varname for every occurrence of $varname in a string:
function expand (s)
	return (string.gsub(s, "$(%w+)", _G))
end

name = "Lua"; status = "great"
print(expand("$name is $status, isn't it?")) --> Lua is great, isn't it?

-- Note, _G is a predefined table containing all global variables.

-- For each match with '$(%w+)' (a dollar sign followed by a name), gsub looks up the captured name in the global table _G; the result replaces the match. When the table does not have the key, there is no replacement:
print(expand("$othername is $status, isn't it?")) --> $othername is great, isn't it?

-- If we are not sure whether the given variables have string values, we may want to apply tostring to their values. In this case, we can use a function as the replacement value:
function expand (s)
	return (string.gsub(s, "$(%w+)", function (n)
		return tostring(_G[n])
	end))
end
 
print(expand("print = $print; a = $a")) --> print = function: 0x8050ce0; a = nil

-- Inside expand, for each match with '$(%w+)', gsub calls the given function with the captured name as argument; the returned string replaces the match.

-- The last example goes back to our format converter from the previous section. Again, we want to convert commands in LaTeX style (\example{text}) to XML style (<example>text</example>), but allowing nested commands this time. The following function uses recursion to do the job:
function toxml (s)
	s = string.gsub(s, "\\(%a+)(%b{})", function (tag, body)
		body = string.sub(body, 2, -2) -- remove the brackets
		body = toxml(body) -- handle nested commands
		return string.format("<%s>%s</%s>", tag, body, tag)
	end)
	return s
end

print(toxml("\\title{The \\bold{big} example}")) --> <title>The <bold>big</bold> example</title>

--[[ URL encoding ]]
-- Our next example will use URL encoding, which is the encoding used by HTTP to send parameters embedded in a URL. This encoding represents special characters (such as =, &, and +) as "%xx", where xx is the character code in hexadecimal. After that, it changes spaces to plus signs. For instance, it encodes the string "a+b = c" as "a%2Bb+%3D+c". Finally, it writes each parameter name and parameter value with an equals sign in between and appends all resulting pairs name = value with an ampersand in between. For instance, the values
name = "al"; query = "a+b = c"; q="yes or no"

-- are encoded as "name=al&query=a%2Bb+%3D+c&q=yes+or+no".

-- Now, suppose we want to decode this URL and store each value in a table, indexed by its corresponding name. The following function does the basic decoding:

function unescape (s)
	s = string.gsub(s, "+", " ")
	s = string.gsub(s, "%%(%x%x)", function (h)
		return string.char(tonumber(h, 16))
	end)
	return s
end

print(unescape("a%2Bb+%3D+c")) --> a+b = c

-- The first gsub changes each plus sign in the string to a space. The second gsub matches all two-digit hexadecimal numerals preceded by a percent sign and calls an anonymous function for each match. This function converts the hexadecimal numeral into a number (using tonumber with base 16) and returns the corresponding character (string.char).

-- To decode the pairs name=value, we use gmatch. Because neither names nor values can contain either ampersands or equals signs, we can match them with the pattern '[^&=]+':
cgi = {}
function decode (s)
	for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
		name = unescape(name)
		value = unescape(value)
		cgi[name] = value
	end
end

-- The call to gmatch matches all pairs in the form name=value. For each pair, the iterator returns the corresponding captures (as marked by the parentheses in the matching string) as the values for name and value. The loop body simply applies unescape to both strings and stores the pair in the cgi table.

-- The corresponding encoding is also easy to write. First, we write the escape function; this function encodes all special characters as a percent sign followed by the character code in hexadecimal (the format option "%02X" makes a hexadecimal number with two digits, using 0 for padding), and then changes spaces to plus signs:
function escape (s)
	s = string.gsub(s, "[&=+%%%c]", function (c)
		return string.format("%%%02X", string.byte(c))
	end)
	s = string.gsub(s, " ", "+")
	return s
end

-- The encode function traverses the table to be encoded, building the resulting string:
function encode (t)
	local b = {}
	for k,v in pairs(t) do
		b[#b + 1] = (escape(k) .. "=" .. escape(v))
	end
	-- concatenates all entries in 'b', separated by "&"
	return table.concat(b, "&")
end

t = {name = "al", query = "a+b = c", q = "yes or no"}
print(encode(t)) --> q=yes+or+no&query=a%2Bb+%3D+c&name=al

--[[ Tab expansion ]]
-- An empty capture like '()' has a special meaning in Lua. Instead of capturing nothing (a useless task), this pattern captures its position in the subject string, as a number:
print(string.match("hello", "()ll()")) --> 3 5

-- (Note that the result of this example is not the same as what we get from string.find, because the position of the second empty capture is after the match.)

-- A nice example of the use of position captures is for expanding tabs in a string: 
function expandTabs (s, tab)
	tab = tab or 8 -- tab "size" (default is 8)
	local corr = 0 -- correction
	s = string.gsub(s, "()\t", function (p)
		local sp = tab - (p - 1 + corr)%tab
		corr = corr - 1 + sp
		return string.rep(" ", sp)
	end)
	return s
end

local inputString = "This\tis\ta\ttabbed\tline."
local expandedString = expandTabs(inputString, 4) -- Expand tabs using a tab size of 4 spaces

-- Print the original and expanded strings
print("Original String:")
print(inputString)

print("Expanded String (tab size = 4):")
print(expandedString)
print("\n")

-- The gsub pattern matches all tabs in the string, capturing their positions. For each tab, the anonymous function uses this position to compute the number of spaces needed to arrive at a column that is a multiple of tab: it subtracts one from the position to make it relative to zero and adds corr to compensate for previous tabs. (The expansion of each tab affects the position of the following ones.) It then updates the correction for the next tab: minus one for the tab being removed, plus sp for the spaces being added. Finally, it returns a string with the appropriate number of spaces to replace the tab.

-- Just for completeness, let us see how to reverse this operation, converting spaces to tabs. A first approach could also involve the use of empty captures to manipulate positions, but there is a simpler solution: at every eighth character, we insert a mark in the string. Then, wherever the mark is preceded by spaces, we replace the sequence spaces–mark by a tab:
function unexpandTabs (s, tab)
	tab = tab or 8
	s = expandTabs(s, tab)
	local pat = string.rep(".", tab)
	s = string.gsub(s, pat, "%0\1")
	s = string.gsub(s, " +\1", "\t")
	s = string.gsub(s, "\1", "")
	return s
end

local unexpandedString = unexpandTabs(inputString, 4) -- Unexpand tabs using a tab size of 4 spaces

-- Print the original and unexpanded strings
print("Original String (with expanded tabs) from previous step:")
print(expandedString)

print("Unexpanded String (tab size = 4):")
print(unexpandedString)

-- The function starts by expanding the string to remove any previous tabs. Then it computes an auxiliary pattern for matching all sequences of eight characters, and uses this pattern to add a mark (the control character \1) after every eight characters. It then substitutes a tab for all sequences of one or more spaces followed by a mark. Finally, it removes the marks left (those not preceded by spaces).
