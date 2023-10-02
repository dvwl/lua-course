--Game by: Muhammad Khairul Haikal Mohd Najib

--for this game, player must enter command using number
--player able to create new game, continue, fight and upgrade using reward coin
--when player win, player can get reward
--when player lose, player will die and create new character if they want
--every saved text data file will be saved in text file or delete if player create new game
--The text data file will be created and deleted on itselves so do not worry to create text files before playing
--it may be simple or basic rpg guild adventurer type game, but i believe i can put much mopre detail in it
--unfortunately, there's a few thing i'm not able to input inside this game
--i will list anything that i insert or not in this game
--Data types                  [/]
--Function                    [/]
--I/O                         [/]
--Closures                    [/]
--Pattern Matching            [X]
--Metatables and Metamethods  [X]
--Object Oriented Programming [X]
--Garbage Collection          [X]
--Coroutines                  [/]


function writeDataToFile(filename, data)
    local file = io.open(filename, "w")  -- Open the file in write mode ("w")
    if not file then
        return false, "Failed to open file"
    end

    file:write(data)  -- Write the data to the file
    file:close()  -- Close the file

    return true
end

function fileExists(filename)
    local file = io.open(filename, "r") -- Try to open the file in read mode
    if file then
        io.close(file) -- Close the file if it was successfully opened
        return true
    else
        return false
    end
end

-- Function to write lines to a file or standard output
function write_lines(output_file, lines)
    if output_file then
        -- Write lines to the specified file
        local file = io.open(output_file, "w")
        if file then
            for _, line in ipairs(lines) do
                file:write(line, "\n")
            end

            file:close()
        else
            error("Failed to open output file: " .. output_file)
        end
    else
        -- Write lines to standard output
        for _, line in ipairs(lines) do
            print(line)
        end
    end
end

function getLineFromFile(filename, lineNumber)
    local file = io.open(filename, "r")
    if not file then
        return nil, "Failed to open file"
    end

    local currentLine = 1
    local data = nil
    for line in file:lines() do
        if currentLine == lineNumber then
            data = line
            break -- Stop reading after finding the desired line
        end

        currentLine = currentLine + 1
    end

    file:close()
    return data
end

function isFileEmpty(filename)
    local file = io.open(filename, "r")
    if not file then
        return true -- Treat non-existent files as empty
    end

    local contents = file:read("*all")
    file:close()

    return contents == nil or contents == ""
end

function deleteFile(filename)
    local success, errorMsg = os.remove(filename)

    if success then
        print(">>The data has been deleted from the player file")
    else
        print(">>File not found or could not be deleted\n>>You will be redirect to the main page")

        main_title()
    end
end

function displayText11()
    local messages = {
        ">>Your journey on this path my ended,",
        ">>but with the given chance",
        ">>will you coose to reborn again as an adventurer?",
        ">>will you create another story for yourself?",
        ">>will you keep going?",
        ">>(You can create new character in main page)",
    }

    for _, message in ipairs(messages) do
        print(message)
        local startTime = os.time()
        repeat until os.time() > startTime + 1
    end
end

local co11 = coroutine.create(displayText11)

function loseexit()
    local status, errorMsg = coroutine.resume(co11)
    if not status then
        print("Error: " .. errorMsg)
    end

    deleteFile("playerhealth00.txt")
    deleteFile("playerprof00.txt")
    deleteFile("playeratk00.txt")
    deleteFile("playerdef00.txt")
    deleteFile("playercoin00.txt")
    os.exit()
end

function Exit()
    print("Until we meet again, adventurer!")
    os.exit()
end

function Shop00()
    local getplayercoinhere00 = tonumber(getLineFromFile("playercoin00.txt", 1))
    local upgradeatk00 = tonumber(getLineFromFile("playeratk00.txt", 1))
    local upgradedef00 = tonumber(getLineFromFile("playerdef00.txt", 1))

    local bb = 3
    while bb == 3 do
        print("\n\n>>.____________________________________________________.")
        print(">>|                    Upgrade Shop                    |")
        print(">>|----------------------------------------------------|")
        print(">>|Every upgrade will cost 50 coin                     |")
        print(">>|                                                    |")
        print(">>|(1)Upgrade Attack point[Add 10 point]               |")
        print(">>|                                                    |")
        print(">>|(2)Upgrade Defense point[Add 5 point]               |")
        print(">>|                                                    |")
        print(">>|(3)Exit shop                                        |")
        print(">>|                                                    |")
        print(">>|----------------------------------------------------|")

        local shopchoice00 = io.read("*n")
        local shopchoice01 = tonumber(shopchoice00)
        if shopchoice01 == 1 then
            if getplayercoinhere00 >= 50 then
                local getplayercoinhere01 = getplayercoinhere00 - 50
                local file = io.open("playercoin00.txt", "w")
                if file then
                    file:write(getplayercoinhere01)
                    file:close()
                else
                    print("--")
                end

                local upgradeatk01 = upgradeatk00 + 10
                local file = io.open("playeratk00.txt", "w")
                if file then
                    file:write(upgradeatk01)
                    file:close()
                else
                    print("--")
                end

                print(">>You have successfully upgraded your Attack point!")
            else
                print(">>You does not have enough coin to upgrade your attack point")
            end

            bb = 3
        elseif shopchoice01 == 2 then
            if getplayercoinhere00 >= 50 then
                local getplayercoinhere02 = getplayercoinhere00 - 50
                local file = io.open("playercoin00.txt", "w")

                if file then
                    file:write(getplayercoinhere02)
                    file:close()
                else
                    print("--")
                end

                local upgradedef01 = upgradeatk00 + 5
                local file = io.open("playeratk00.txt", "w")

                if file then
                    file:write(upgradedef01)
                    file:close()
                else
                    print("--")
                end

                print(">>You have successfully upgraded your Attack point!")
            else
                print(">>You does not have enough coin to upgrade your defense point")
            end

            bb = 3
        else
            bb = 4
        end
    end

    return 4
end

function fightduration01(returnvalue01, enemyname01, health01, attack01, defense01, reward01)
    local pyrhealth00 = getLineFromFile("playerhealth00.txt", 1)
    local pyratk00 = getLineFromFile("playeratk00.txt", 1)
    local pyrdef00 = getLineFromFile("playerdef00.txt", 1)
    local pyrcoin00 = getLineFromFile("playercoin00.txt", 1)

    local reduceatk00 = pyratk00 - defense01
    local reduceatk01 = attack01 - pyrdef00

    print(">>You deal " .. reduceatk00 .. " damages towards enemy after has been reduce with enemy defense.")
    print(">>" .. enemyname01 .. " deal " .. reduceatk01 .. " damages towards you after has been reduce with your defense.")

    local playerhealthleft = pyrhealth00 - reduceatk01
    local enemyhealthleft = health01 - reduceatk00

    local file = io.open("playerhealth00.txt", "w")

    if file then
        file:write(playerhealthleft)
        file:close()
    else
        print("Failed to create file playerprof00.")
    end

    local comparehold00 = tonumber(getLineFromFile("playerhealth00.txt", 1))
    local holdreturnresult = 0

    if comparehold00 <= 0 then
        print("You lose.")
        holdreturnresult = 3
    elseif health01 <= 0 then
        local file = io.open("playerhealth00.txt", "w")

        if file then
            file:write(100)
            file:close()
        else
            print("Failed to create file playerhealth00.")
        end

        local addcoin00 = pyrcoin00 + reward01
        local file = io.open("playercoin00.txt", "w")

        if file then
            file:write(addcoin00)
            file:close()
        else
            print("Failed to create file playercoin00.")
        end

        print("You win!")

        holdreturnresult = 2
    elseif health01 > 0 then
        holdreturnresult = 1
    end

    return holdreturnresult, enemyname01, enemyhealthleft, attack01, defense01, reward01
end

function fightduration (enemyname00, health00, attack00, defense00, reward00)
    local drnhold00 = 1

    while drnhold00 == 1 do
        drnhold00, enemyname00, health00, attack00, defense00, reward00 = fightduration01(drnhold00, enemyname00, health00, attack00, defense00, reward00)
    end

    if drnhold00 == 3 then
        loseexit()
    else
        return 1
    end
end

function fightchoice00 ()
    print("\n\n>>.____________________________________________________.")
    print(">>|**************LIST OF ENEMY TO FIGHT:***************|")
    print(">>|----------------------------------------------------|")
    print(">>|(1)Swamp Troll                                      |")
    print(">>|   =>Health    : 34             =>Attack    : 34    |")
    print(">>|   =>Defense   : 20             =>Reward    : 18    |")
    print(">>|----------------------------------------------------|")
    print(">>|(2) Waterfall Slime                                 |")
    print(">>|   =>Health    : 70             =>Attack    : 14    |")
    print(">>|   =>Defense   : 10             =>Reward    : 20    |")
    print(">>|____________________________________________________|")
    print(">>|(3)Dirt Golem                                       |")
    print(">>|   =>Health    : 40             =>Attack    : 44    |")
    print(">>|   =>Defense   : 30             =>Reward    : 23    |")
    print(">>|____________________________________________________|\n")

    print("Enter the command number from above to fight the enemy:")

    local fightcomm00 = io.read("*n")
    local fightcomm01 = tonumber(fightcomm00)

    if fightcomm01 == 1 then
        fightduration ("Swamp Troll", 34, 34, 20, 18)
        return 1
    elseif fightcomm01 == 2 then
        fightduration ("Waterfall Slime", 70, 14, 10, 20)
        return 1
    elseif fightcomm01 == 3 then
        fightduration ("Dirt Golem", 40, 44, 30, 23)
        return 1
    else
        print("You entered the wrong command, you will be redirect to the main guild for another choice")
        return 4
    end
end

function guild_command00()
    print("\n\n>>.____________________________________________________.")
    print(">>|                     GUILD HOUSE                    |")
    print(">>|----------------------------------------------------|")
    print(">>|(1)Fight[Earn a reward for every victory!]          |")
    print(">>|                                                    |")
    print(">>|(2)Shop[Upgrade your weapon!]                       |")
    print(">>|                                                    |")
    print(">>|(3)Exit game                                        |")
    print(">>|                                                    |")
    print(">>|----------------------------------------------------|")
    print("\n\nEnter the number command from table above")

    local guildcomm00 = io.read("*n")
    local guildcomm01 = tonumber(guildcomm00)

    if guildcomm01 == 1 then
        fightchoice00()
        return 4
    elseif guildcomm01 == 2 then
        Shop00()
        return 4
    elseif guildcomm01 == 3 then
        Exit()
    else
        return 4
    end
end

function main_guild()
    local waitguild00 = 4

    while waitguild00 == 4 do
        waitguild00 = guild_command00()
    end
end

--

function displayText00()
    local messages = {
        ">>This is your first time entering the Guild,",
        ">>there's a lot adventurer with multiple proffesion",
        ">>you arrived at the counter, registering as a new adventurer",
        ">>This is your story",
        ">>This is your adventure",
        ">>Now, what will you do?",
    }

    for _, message in ipairs(messages) do
        print(message)
        local startTime = os.time()
        repeat until os.time() > startTime + 1
    end
end

local co = coroutine.create(displayText00)

function firstgamewalk()
    local status, errorMsg = coroutine.resume(co)
    if not status then
        print("Error: " .. errorMsg)
    end

    main_guild()
end

local function createnewcharacter()
    --playername,playerclass,playeratk,playerdef,playerres
    local file = io.open("playerhealth00.txt", "w")

    if file then
        file:write(100)
        file:close()
    else
        print("Failed to create file playerhealth00.")
    end

    print("\n\n>>.____________________________________________________.")
    print(">>|**********Select the class level you want:**********|")
    print(">>|----------------------------------------------------|")
    print(">>|(1)Shielded Warrior                                 |")
    print(">>|   =>Attack    : 34             =>Defense    : 45   |")
    print(">>|----------------------------------------------------|")
    print(">>|(2)Lurking Archer                                   |")
    print(">>|   =>Attack    : 40             =>Defense    : 32   |")
    print(">>|____________________________________________________|")

    print(">>Enter your new profession following the command number:")

    local pro00 = io.read("*n")
    local pro01 = tonumber(pro00)

    if pro01 == 1 then
        pd00 = "Shielded Warrior"
        pd01 = 34
        pd02 = 45
    elseif pro01 == 2 then
        pd00 = "Lurking Archer"
        pd01 = 40
        pd02 = 32
    else
        print(">>Your command input does not match from above panel\n>>You will be redirect to the main page")
        main_title()
        return 3
    end

    --

    local file = io.open("playerprof00.txt", "w")
    if file then
        file:write(pd00)
        file:close()
    else
        print("Failed to create file playerprof00.")
    end

    local file = io.open("playeratk00.txt", "w")
    if file then
        file:write(pd01)
        file:close()
    else
        print("Failed to create file playerprof00.")
    end

    local file = io.open("playerdef00.txt", "w")
    if file then
        file:write(pd02)
        file:close()
    else
        print("Failed to create file playerprof00.")
    end

    local file = io.open("playercoin00.txt", "w")
    if file then
        file:write(0)
        file:close()
    else
        print("Failed to create file playercoin00.")
    end

    firstgamewalk()
end

local function main_title()
    print("|**************************************************|")
    print("|             The Adventure of LuaLand             |")
    print("**************************************************")
    print("     Enter the command number below to proceed      \n")
    print("\t(1)\tContinue the game")
    print("\t(2)\tStart the new game\n")
end

local function main_command00()
    local comm00 = 0
    local comm01 = 0
    local comm02 = 0
    local comm03 = 0
    local comm04 = 0
    local comm05 = 0

    print(">>Enter the command:")
    comm00 = io.read("*n")
    comm01 = tonumber(comm00)

    if comm01 == 1 then
        if not fileExists("playerhealth00.txt") then
            print(">>You does not have any saved files\n>>You will be needed to create a new character on the main page")
            main_title()
            return 3
        else
            print("Loading")
            main_guild()
        end
    elseif comm01 ==2 then
        if not fileExists("playerhealth00.txt") then
            createnewcharacter()
        else
            print("You still have a saved game files, do you really want to delete and restart a new character?")
			print("(1)  Yes")
			print("(2)  No")

			comm02 = io.read("*n")
			comm03 = tonumber(comm02)
			if comm03 == 1 then
				local deletingfile = "playerhealth00.txt"
				deleteFile(deletingfile)
				deleteFile("playerprof00.txt")
				deleteFile("playeratk00.txt")
				deleteFile("playerdef00.txt")
				deleteFile("playercoin00.txt")
				createnewcharacter()
			else
				print(">>You will be redirect to the main page to choose another choice")
				main_title()
				return 3
			end
        end
    else
        print(">>The command you entered does not match\n>>You will be redirect to the mainpage")
        main_title()
        return 3
    end
end

function main()
    --player will be asked if they want to continue the game or start a new game
    --if player choose to continue but there is no data inside the saved files. player will e given error message
    --if player choose to start a new game but there's still a saved files, the player will be ask once again to confirming the reset
    --the saved files that has been reset will be rewriten
    main_title()
    local check01 = 3
    while check01 == 3 do
        check01 = main_command00()
    end
end

main()
