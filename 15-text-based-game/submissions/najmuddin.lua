--The Adventure that really LUA biasa

-- Game created by: Muhammad Najmuddin Bin Radzuan (@meove)

-- What class should have:  
-- HP, Player, power, boss

Playerstats = { -- Player stats
    {Name = "", Health = 100, Power = 0}
    }

Enemystats = { -- Slime stats
    {Name = "Slime", Health = 400, Power = 5}
    }

Bossstats = { -- Boss stats
    {Name = "Dark Luard", Health = 800, Power = 15}
    }

---------------------------------
------------ Story 1 ------------

function RepeatRead1() -- Repeat until player use matched text
    
    path1 = io.read()

    if  path1 == "a" then
        -- Break
    elseif path1 == "b" then
        -- Break
    else 
        print("Wrong route!!")
        RepeatRead1()
    end
end

-- Path A (LUA-Library Academia)
function pathA()
    print("Witch: Hello, there fellow adventurer. What's bring you here to the forbidden place of knowledge. \n")
    print("a. Hi, my name is " .. Playerstats[1].Name .. ", and I need your magic knowledge to improve my power.")
    print("b. I'm " .. Playerstats[1].Name .. ". My journey here is to learn the forbidden magic spell to defeat Dark Lord. \n")

    local pathA_1a = io.read()

    os.execute("cls") -- Clean terminal

    if pathA_1a == "a" then
        Playerstats[1].Power = 50
        print("Witch: Hehehe, such humble adventurer. I will teach you the magic. \n" .. "[Power increased by: " .. Playerstats[1].Power .. "]")
    
    elseif pathA_1a == "b" then
        Playerstats[1].Power = 150
        print("Witch: Hehe, try to be tough guy, ehh? I will show you the true power of magic. \n" .. "[Power increased by: " .. Playerstats[1].Power .. "]")
    else
        print("\nWrong Selection!!")
        os.execute("pause")
        os.execute("cls") -- Clean terminal
        pathA()
    end

    os.execute("pause")
    os.execute("cls") -- Clean terminal
end

-- Path B (Light Unn Andromeda Village)
function pathB()
    print("You looked around the village and found Blacksmith shop, and then... \n")
    print("Blacksmith worker: Looking for find weapon? We smith the best weapon in the world.\n")
    print("a. Hi, I am " .. Playerstats[1].Name .. ". I'm looking for sharpest sword that can slay dragon scale.")
    print("b. I'm the LUABiasa traveler, called me " .. Playerstats[1].Name .. ". I want a full set of knight armor with diamond sword. \n")

    local pathA_1b = io.read()

    os.execute("cls") -- Clean terminal

    if pathA_1b == "a" then
        Playerstats[1].Power = 125
        print("Blacksmith worker: You got it. Here the Stellar Blade, brave adventurer. \n" .. "[Power increased by: " .. Playerstats[1].Power .. "]")
    
    elseif pathA_1b == "b" then
        Playerstats[1].Power = 100
        print("Blacksmith worker: Here your full knight armor set. We create with Netherite material to made you become unbeatable. \n" .. "[Power increased by: " .. Playerstats[1].Power .. "]")
    else
        print("\nWrong Selection!!")
        os.execute("pause")
        os.execute("cls") -- Clean terminal
        pathB()
    end

    os.execute("pause")
    os.execute("cls") -- Clean terminal
end
---------------------------------
------------ Story 2 ------------

function RepeatRead2() -- Repeat until player use matched text
    
    path2 = io.read()

    if  path2 == "a" then
        -- Break
    elseif path2 == "b" then
        -- Break
    else 
        print("Wrong route!!")
        RepeatRead2()
    end
end

function pathA_2(power, enemypower)
    repeat
        Enemystats[1].Health = Enemystats[1].Health - math.random(0, power) -- Player attack
        print("Enemy Health: " .. Enemystats[1].Health)

        Playerstats[1].Health = Playerstats[1].Health - math.random(0, enemypower) -- Enemy attack
        print("Player Health: " .. Playerstats[1].Health)

        print("\n[Attack]")
        os.execute("pause")
        os.execute("cls") -- Clean terminal
    until Enemystats[1].Health < 0 or Playerstats[1].Health < 0
    -- Slime defeat
    print("Slime have been defeated!!")
    os.execute("pause")
    os.execute("cls") -- Clean terminal

    Playerstats[1].Health = Playerstats[1].Health + math.random(0, 80) -- Random HP loot dropped
    print("Enemy dropped a loot. Your Health increased to: " .. Playerstats[1].Health)

    os.execute("pause")
    os.execute("cls") -- Clean terminal

    print("You continue your journey")

    os.execute("pause")
    os.execute("cls") -- Clean terminal
end 

function pathB_2()
    Playerstats[1].Power = Playerstats[1].Power - 30
    print("[Power have been decreased by: -30]")
end 
---------------------------------
------------ Story 3 ------------

function BossBattle(power, bosspower)
    repeat
        Bossstats[1].Health = Bossstats[1].Health - math.random(0, power) -- Player attack
        print("Enemy Health: " .. Bossstats[1].Health)

        Playerstats[1].Health = Playerstats[1].Health - math.random(0, bosspower) -- Enemy attack
        print("Player Health: " .. Playerstats[1].Health)
        
        print("\n[Attack]")
        os.execute("pause")
        os.execute("cls") -- Clean terminal

    until Bossstats[1].Health < 0 or Playerstats[1].Health < 0
    -- Dark Luard defeat OR Player defeat

    if Bossstats[1].Health < 0 then
        print("The unbeatable final boss have been defeated!!")
        os.execute("pause")
        os.execute("cls") -- Clean terminal

        print("Congratulations, " .. Playerstats[1].Name .. ". You saved the LUABiasa Land.")
    end

    if Playerstats[1].Health < 0 then
        print("Player have been defeated!!")
        os.execute("pause")
        os.execute("cls") -- Clean terminal

        print("Rest in Peace, " .. Playerstats[1].Name .. ". The brave adventurer.")
    end
    
end


function GarbageCount() -- Return amounts of current memory by program
    collectgarbage("count")
end

function GarbageCollect() -- Runs one complete cycle garbage collection
    collectgarbage("collect")
end

print("test")


-- Main function

-- Start Game
print("Welcome to LUABiasa Land\n")

print("Enter your name")

playerName = io.read()

-- Declare name
Playerstats[1].Name = playerName
os.execute("cls") -- Clean terminal

print("Hi, " .. Playerstats[1].Name .. ". Let's explore into wild LUABiasa Land\n")
os.execute("pause")
os.execute("cls") -- Clean terminal
---------------------------------
------------ Story 1 ------------
print("[[Story 1]] \n")
print("You found two differents route. Choose a or b")

RepeatRead1()

os.execute("cls") -- Clean terminal

if path1 == "a" then
    print("You entered LUA-Library Academia")
    pathA()
elseif path1 == "b" then
    print("You entered Light Unn Andromeda Village")
    pathB()
end
---------------------------------
------------ Story 2 ------------
os.execute("cls") -- Clean terminal
print("[[Story 2]] \n")
print("You found a Slime!! \n")
print("a. Fight \n")
print("b. Run \n")

RepeatRead2()

os.execute("cls") -- Clean terminal

if path2 == "a" then
    print("Here we go!!")
    PlayerPower = Playerstats[1].Power -- Update Player and Enemy stats
    EnemyPower = Enemystats[1].Power
    pathA_2(PlayerPower, EnemyPower)
elseif path2 == "b" then
    print("RUN!!!")
    pathB_2()
end

GarbageCount()
Enemystats = nil -- Remove memory from enemy stats, since it not used anymore
GarbageCount()
GarbageCollect()
GarbageCount()

---------------------------------
------------ Story 3 ------------
print("[[Story 3]] \n")
print("You face the final boss, Dark Luard The LUABiasa Land Crusher and Universe Conqueror of Destroyer.  \n") -- What a great name ;)
print("This is your destiny. Fight him!!\n")



os.execute("pause")
os.execute("cls") -- Clean terminal

Playerstats[1].Power = Playerstats[1].Power + math.random(0, 60) -- Increased player power with random number
print("BUT WAIT!!! \nYou feels like your inner energy power increased!!\n")
print("[Power have been increased by: " .. Playerstats[1].Power .. "]")

os.execute("pause")
os.execute("cls") -- Clean terminal

PlayerPower = Playerstats[1].Power
BossPower = Bossstats[1].Power

BossBattle(PlayerPower, BossPower) -- Boss fight function
---------------------------------
