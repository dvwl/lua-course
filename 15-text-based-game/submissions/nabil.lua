-- Game by: Nabil Faris
-- remark: I put a little cyberpunk spin on it, although it is very simple, I wasn't exactly sure how complex it needed to be. Its got a very basic game loop with two options for mechanics that you can choose from.

local Character = {}

Character.__index = Character

function Character:new(name)
    local self = setmetatable({}, Character)
    self.name = name
    self.health = 100
    return self
end

function Character:takeDamage(amount)
    self.health = self.health - amount

    if self.health <= 0 then
        self.health = 0
    end
end

-- Define Robot class
local Robot = {}
Robot.__index = Robot

function Robot:new()
    local self = setmetatable({}, Robot)
    self.health = 50
    return self
end

function Robot:takeDamage(amount)
    self.health = self.health - amount
    
	if self.health <= 0 then
        self.health = 0
    end
end

-- Get the player's name
print("Welcome to The Adventure of Lua Land - Cyberpunk Edition!")
print("You are in a cyberpunk world and need to save the city.")
print("You must remove the matrix from the reactor core.")
print("Please enter your character's name:")
local playerName = io.read()

-- Create the player character
local player = Character:new(playerName)

-- Randomly determine the number of robots at the start
local initialRobotCount = math.random(1, 3)

print("Welcome, " .. player.name .. "!")
print("Oh no! " .. initialRobotCount .. " robots have appeared. You must defeat them to save the city!")

-- Initialize total robot count

-- Game loop
local enemy = Robot:new()

while initialRobotCount > 0 and player.health > 0 do
    print("\nOptions:")
    print("1. Attack")
    print("2. Dodge")
    
	local choice = tonumber(io.read())

    if choice == 1 then
        local playerDamage = math.random(15, 30)
        local enemyDamage = math.random(5, 15)

        player:takeDamage(enemyDamage)
        enemy:takeDamage(playerDamage)
        
		print("You attacked the robot.")
        print("The robot counterattacks.")
        print("Player health: " .. player.health)
        print("Robot health: " .. enemy.health)

        if enemy.health <= 0 then
            print("You defeated the robot!")
            initialRobotCount = initialRobotCount - 1
            enemy = Robot:new()  -- Create a new instance of Robot after defeating one
        else
            print("It is getting more aggresive")
        end
    elseif choice == 2 then
        print("You attempt to dodge the robot's attack.")
    else
        print("Invalid choice. Try again.")
    end

    if initialRobotCount > 0 then
        print("There are " .. initialRobotCount .. " robots remaining.")
    else
        print("You have defeated all the robots!")
        print("You reach the reactor core and remove the matrix.")
        print("Congratulations, " .. player.name .. "! You have saved the city from destruction.")
    end
end

if player.health <= 0 then
    print("You were defeated. Game Over.")
end