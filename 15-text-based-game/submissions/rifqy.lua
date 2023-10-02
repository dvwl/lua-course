local gameStats = {
    playerHealth = 100,
    playerDamage = 10,
    enemyHealth = 50,
    enemyDamage = 8, 
}

local inEncounter = false
local function playerAttack()
    gameStats.enemyHealth = gameStats.enemyHealth - gameStats.playerDamage 
end

local function enemyAttack()
    gameStats.playerHealth = gameStats.playerHealth - gameStats.enemyDamage 
end

local function resetEnemy()
    gameStats.enemyHealth = 50 
end

local function isOver()
    return gameStats.playerHealth <= 0 
end

local function displayInfo()
    print("\n$$$$$$$$$$$$$$$ Your Stats $$$$$$$$$$$$$$$$$$$")
    print("Your Health: " .. gameStats.playerHealth)
    print("Your Damage: " .. gameStats.playerDamage)  
    print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
    if inEncounter then
        print("Enemy Health:" .. gameStats.enemyHealth)
    end 
end

local function encounterChance()
    local chance = math.random(1,100)
    if chance <= 40 then
        return "enemy"
    elseif chance <= 70 then
        return "healingPotion"
    else
        return "treasure"
    end 
end

local encounterMetatable = {
    __index = {
        enemy = function()
            print("\n You encountered a skeleton")
            inEncounter = true
            resetEnemy()
            while gameStats.playerHealth > 0 and gameStats.playerHealth > 0 do
                displayInfo()
                print("\n What will you do?")
                    print("1. Attack")
                    print("2. Run Away")
                    io.write("Enter your choice..")
                    local choice = tonumber(io.read())
                if choice == 1 then
                    playerAttack()
                    if gameStats.enemyHealth <= 0 then
                        print("The skeleton crumbles into dust and you proceed on your way")
                        inEncounter = false
                        return
                    end
                    print("Its the enemy's turn to attack!")
                    enemyAttack()
                    if gameStats.playerHealth <= 0 then
                        print("The darkness has claimed you")
                        print("GAME OVER")
                        inEncounter = false
                        return
                    end
                elseif choice == 2 then
                    print("With your tail tucked between your legs you ran until you can't see the enemy anymore")
                    inEncounter = false
                    return
                else
                    print("You stumble as you are confuse. You decide to try again.")
                end
            end
        end,
            healingPotion = function()
                print("You found a healing potion")
                gameStats.playerHealth = math.min(100, gameStats.playerHealth + 20)
            end,
            treasure = function()
                print("You stumble upon an artiface")
                print("It increases your power and damage")   
                gameStats.playerDamage = gameStats.playerDamage + 10
            end
        } }
local function mainGame()
    while true do
    gameStats.playerHealth = 100
    gameStats.playerDamage = 10
    print("\n________________________________________<>_____________________________")
    print("You find yourself among the maze like structures of Lua Land Dungeon")
    print("You venture deeper to find treasure")
    print("________________________________________<>_____________________________")
        while not isOver() do
            displayInfo()
            print("\nYou decide to move..")
            print("1: ... in the left direction")
            print("2: ... in the right direction")
            print("3: ... straight ahead")
            io.write("Enter your choice:  ")
            local choice = tonumber(io.read())
            local encounterType = encounterChance()
            local encounterBehaviour = encounterMetatable.__index[encounterType]
            if encounterBehaviour then
                encounterBehaviour()
            else
                print("Invalid Encounter")
            end
        end

        if isOver() then
            print("++++=============================+++")
            print("The dungeon has claimed another soul")
        end
        print("Do you want to try again? (yes / no)")
        print("++++=============================+++")
        local plaAgain = io.read()
        if string.lower(plaAgain) ~= "yes" then
            print("Thanks for playing!")
            return
        end  
    end 
end

setmetatable(gameStats, encounterMetatable)
local gameCoroutine = coroutine.create(mainGame) coroutine.resume(gameCoroutine)
