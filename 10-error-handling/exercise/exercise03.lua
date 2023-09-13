-- Consider a Lua program that simulates a simple banking application. 
-- The program has a function withdraw that is intended to deduct a specified amount from an account. 
-- However, there is a logic error in the function. Your task is to identify and fix the error.
-- How do I know which account do I deduct it from?
-- How do I keep the variables secure?

-- This program has a logic error
local account1 = {
    balance = 1000,
    owner = "John Doe",
}

local account2 = {
    balance = 500,
    owner = "Jane Doe",
}

-- Function to withdraw money from the account
-- Hint: try closure and lexical scoping
function withdraw(account, amount)
    local balance = account.balance - amount
	return balance
end

-- Attempt to withdraw $500
withdraw(account1, 500)

-- Display the updated balance
print("Updated balance for " .. account1.owner .. ": $" .. account1.balance)

-- Attempt to withdraw $1000
withdraw(account2, 1000)

-- Display the updated balance
print("Updated balance for " .. account2.owner .. ": $" .. account2.balance)
