-- Implement a Lua program that simulates a simple bank account. Create a function createAccount that returns closures for depositing and withdrawing money from the account. The closures should maintain the account balance.

-- In your discussions, discuss the rationale of having balance in a closure.

function createAccount(initialBalance)
    local balance = initialBalance or 0

    local function deposit(amount)
		-- insert your code here
    end

    local function withdraw(amount)
		-- insert your code here
    end

    local function getBalance()
        -- insert your code here
    end
	
    return -- something we learnt in tables
end

-- Create a bank account with an initial balance of $100
local account = createAccount(100)

-- Deposit and withdraw money
account["deposit"](50) -- equivalent to account.deposit(50)
account.withdraw(30)

-- Get and display the account balance
print("Account Balance: $" .. account.getBalance())  -- Should print "Account Balance: $120"
