--[[ Relational Metamethods ]]
-- Metatables also allow us to give meaning to the relational operators, through the metamethods __eq (equal to), __lt (less than), and __le (less than or equal to). There are no separate metamethods for the other three relational operators: Lua translates a ~= b to not (a == b), a > b to b < a,and a >= b to b <= a.

-- In older versions, Lua translated all order operators to a single one, by translating a <= b to not (b < a). However, this translation is incorrect when we have a partial order, that is, when not all elements in our type are properly ordered. For instance, most machines do not have a total order for floating-point numbers, because of the value Not a Number (NaN). According to the IEEE 754 standard, NaN represents ndefined values, such as the result of 0/0. The standard specifies that any comparison that involves NaN should result in false. This means that NaN <= x is always false, but x < NaN is also false. It also means that the translation from a <= b to not (b < a) is not valid in this case.

-- In our example with sets, we have a similar problem. An obvious (and useful) meaning for <= in sets is set containment: a <= b means that a is a subset of b. With this meaning, it is possible that a <= b and b < a are both false. Therefore, we must implement both __le (less or equal, the subset relation) and __lt (less than, the proper subset relation):
mt.__le = function (a, b) -- subset
	for k in pairs(a) do
		if not b[k] then return false end
	end
	return true
end

mt.__lt = function (a, b) -- proper subset
	return a <= b and not (b <= a)
end

-- Finally, we can define set equality through set containment:
mt.__eq = function (a, b)
	return a <= b and b <= a
end

-- After these definitions, we are ready to compare sets:
s1 = Set.new{2, 4}
s2 = Set.new{4, 10, 2}
print(s1 <= s2) --> true
print(s1 < s2) --> true
print(s1 >= s1) --> true
print(s1 > s1) --> false
print(s1 == s2 * s1) --> true

-- The equality comparison has some restrictions. If two objects have different basic types, the equality operation results in false, without even calling any metamethod. So, a set will always be different from a number, no matter what its metamethod says.
