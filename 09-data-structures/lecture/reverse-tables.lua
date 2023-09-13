--[[ Reverse Tables ]]
-- As I said, before, we seldom do searches in Lua. Instead, we use what we call an index table or a reverse table.

-- Suppose we have a table with the names of the days of the week:
days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

-- Now we want to translate a name into its position in the week. We can search the table, looking for the given name. A more efficient approach, however, is to build a reverse table, say revDays, which has the names as indices and the numbers as values. This table would look like this:
revDays = {["Sunday"] = 1, ["Monday"] = 2, ["Tuesday"] = 3, ["Wednesday"] = 4, ["Thursday"] = 5, ["Friday"] = 6, ["Saturday"] = 7}

-- Then, all we have to do to find the order of a name is to index this reverse table:
x = "Tuesday"
print(revDays[x]) --> 3

-- Of course, we do not need to declare the reverse table manually. We can build it automatically from the original one:
revDays = {}
for k,v in pairs(days) do
	revDays[v] = k
end

-- The loop will do the assignment for each element of days, with the variable k getting the keys (1, 2, ...) and v the values ("Sunday", "Monday", ...).

-- Reverse tables application
-- 1. Day name lookup:
local dayName = "Wednesday"
local numericalValue = revDays[dayName]
print(dayName .. " is day number " .. numericalValue) --> Wednesday is day number 4

-- 2. Day value lookup:
local numericalValue = 6
local dayName = ""
for name, value in pairs(revDays) do
    if value == numericalValue then
        dayName = name
        break
    end
end
print("Day number " .. numericalValue .. " is " .. dayName) --> Day number 6 is Friday

-- Note: Reverse table a common technique used for various mapping and translation tasks in Lua programming.
