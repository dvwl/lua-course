-- Game by: Dr Jaynier Jayson Jaya

-- Define the Doctor class
-- 1. Data Types: Defining a table (a data type in Lua) for the Doctor
local Doctor = {name = "", energy = 100, patients_healed = 0, money = 150}
Doctor.__index = Doctor

-- 2. Functions: Defining a function to create a new Doctor
function Doctor.new(name)
    -- 6. Object-Oriented Programming: Using metatables to achieve object-oriented programming
    local self = setmetatable({}, Doctor)
    self.name = name:sub(1,1):upper()..name:sub(2)
    return self
end

-- Defining a function for the Doctor to start a day
function Doctor:start_day()
    -- 3. I/O: Here we are using input/output operations to interact with the user
    print("Starting a new day will last 30 seconds. Are you sure?")
    print("1. Yes")
    print("2. No, return to menu")
    local choice = io.read()

    -- 5. Pattern Matching: Here we are using pattern matching to validate the user's input
    if choice:match("^1$") then
        self.energy = 100
        print("A new day has started. Your energy has been replenished.")
        -- 9. Coroutines: Here we are using coroutines to simulate the passage of time in the game
        local day_time = coroutine.create(function()
            for i=1, 30 do 
                os.execute("ping -n 2 localhost >nul")
                print("Day time... " .. tostring(i) .. " seconds passed.")
            end 
            print("Day ended.")
        end)
        coroutine.resume(day_time)
    elseif choice:match("^2$") then
        return false
    else
        print("Invalid choice.")
    end
end

-- Defining a function for the Doctor to diagnose a patient
function Doctor:diagnose_patient(disease)
    if self.energy < 20 then
        print("You're too tired to diagnose a patient.")
        return false
    end

    self.energy = self.energy - 20
    print("The patient has been diagnosed with " .. disease.name .. ".")
    self.money = self.money + 10
    print("You've earned RM10 for diagnosing a patient. Your total money is now RM" .. self.money .. ".")
    return disease
end

-- Defining a function for the Doctor to treat a patient
function Doctor:treat_patient(disease)
    local energy_cost = disease.difficulty * 20
    
    if self.energy < energy_cost then
        print("You're too tired to treat a patient.")
        return false
    end

    self.energy = self.energy - energy_cost
    print("The patient with " .. disease.name .. " has been treated.")
    self.patients_healed = self.patients_healed + 1
    self.money = self.money + 20
    print("You've earned RM20 for treating a patient. Your total money is now RM" .. self.money .. ".")
end

-- Buy an item
function Doctor:buy_item(item)
    if self.money < item.price then
        print("You don't have enough money to buy this item.")
        return false
    end

    self.money = self.money - item.price
    print("You've bought a " .. item.name .. ". Your remaining money is RM" .. self.money .. ".")
    
	local drink_time = coroutine.create(function(item)
		for i=1, item.drink_time do 
			os.execute("ping -n 2 localhost >nul")
			print("Drinking " .. item.name .. "... " .. tostring(i) .. " seconds passed.")
		end 
		self.energy = self.energy + item.energy
		print("Finished drinking. Your energy is now " .. tostring(self.energy) .. ".")
	end)
	coroutine.resume(drink_time, item)
end

-- Save game state to a text file
function Doctor:save_game()
	local file = io.open('savegame.txt', 'w')
	file:write(self.name..'\n')
	file:write(self.energy..'\n')
	file:write(self.patients_healed..'\n')
	file:write(self.money..'\n')
	file:close()
	print('Game saved.')
end

-- Load game state from a text file
function Doctor:load_game()
	local file = io.open('savegame.txt', 'r')
	self.name = file:read('*line')
	self.energy = tonumber(file:read('*line'))
	self.patients_healed = tonumber(file:read('*line'))
	self.money = tonumber(file:read('*line'))
	file:close()
	print('Game loaded.')
end

local Disease = {}
Disease.__index = Disease

function Disease.new(name, difficulty)
	-- 4. Closures: Here we are using a closure to encapsulate the name and difficulty of the disease
	local function get_name_and_difficulty()
		return name, difficulty 
	end
	
	local name, difficulty = get_name_and_difficulty()
	
	local self = setmetatable({}, Disease)
	self.name = name
	self.difficulty = difficulty -- Difficulty to diagnose and treat the disease
	return self 
end 

-- List of disease
local diseases = {
	Disease.new("flu (easy)", 1),
	Disease.new("broken hand (hard)", 2),
	Disease.new("broken hand, broken ribs, broken leg (very hard)", 3)
}

local Item = {}
Item.__index = Item

function Item.new(name, price, energy, drink_time)
	local self = setmetatable({}, Item)
	self.name = name
	self.price = price -- Price of the item
	self.energy = energy -- Energy given by the item when consumed
	self.drink_time = drink_time -- Time taken to drink the item in seconds 
	return self 
end 

-- List of items
local items = {
	Item.new("Energy drink", 20, 15, 4), -- Create new item "Energy drink"
	Item.new("Coffee", 10, 5, 2), -- Create new item "Coffee"
	Item.new("Experimental Drug", 50, 50, 10) -- Create new item "Experimental Drug"
}

print("Welcome to the hospital. What is your name?")
local doctor_name = io.read() -- Read user input for doctor's name
local doctor = Doctor.new(doctor_name) -- Create new Doctor object
print("Hello, Dr." .. doctor.name .. ".")

-- Start game loop
while true do 
    print("\nEnergy remaining: " .. doctor.energy)
    print("Wallet balance: RM" .. doctor.money)
    print("What would you like to do?")
    print("1. Start a new day")
    print("2. Diagnose a patient")
    print("3. Treat a patient")
    print("4. Buy an item")
    print("5. Save/Load game")
    print("6. Get some food")
    print("7. Jump off the building")

    local choice = io.read() -- Read user input for choice

    -- Match user choice and perform corresponding action
    if choice:match("^1$") then 
        doctor:start_day() -- Start a new day
    elseif choice:match("^2$") then 
        local disease = diseases[math.random(#diseases)]
        doctor:diagnose_patient(disease) -- Diagnose a patient
    elseif choice:match("^3$") then 
        local disease = diseases[math.random(#diseases)]
        doctor:treat_patient(disease) -- Treat a patient
    elseif choice:match("^4$") then 
        print("Which item would you like to buy?")
        for i, item in ipairs(items) do 
            print(i .. ". " .. item.name .. ", price RM" .. item.price .. ", gives energy " .. item.energy)
        end 

        local item_choice = tonumber(io.read()) -- Read user input for item choice
        if item_choice >= 1 and item_choice <= #items then 
            doctor:buy_item(items[item_choice]) -- Buy an item
        else 
            print("Invalid choice.")
        end 
    elseif choice:match("^5$") then
        print("Would you like to:")
        print("1. Save game")
        print("2. Load game")
        local save_load_choice = io.read() -- Read user input for save/load choice
        if save_load_choice:match("^1$") then
            doctor:save_game() -- Save game
        elseif save_load_choice:match("^2$") then
            doctor:load_game() -- Load game
        else
            print("Invalid choice.")
        end
	elseif choice:match("^6$") then 
		print("\nNurse : Doctor " .. doctor.name .. "! You are needed in the emergency room.")
        print("Please come back! (-5 energy)")
		doctor.energy = doctor.energy - 5
		print("Your energy is now " .. tostring(doctor.energy) .. ".")
	elseif choice:match("^7$") then
		print("\nGod : There is a patient in emergency room!")
        print("You are not allowed to die yet. (+5 energy)")
		doctor.energy = doctor.energy + 5
		print("Your energy is now " .. tostring(doctor.energy) .. ".")
	elseif choice:match("^calllucifer$") then -- Cheat code (wisely used for debugging)
		doctor.energy = 200 -- Set energy to 200
		doctor.money = 300 -- Set money to 300
		print("Cheat activated! Your energy is now " .. tostring(doctor.energy) .. " and your money is RM" .. tostring(doctor.money) .. ".")
	else 
		print("Invalid choice.")
	end 

    -- 7. Garbage Collection: Triggering garbage collection to free up memory
	collectgarbage() 
end
