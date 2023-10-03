-- Game by: Nur Ain Nadirah Kasuma Wangi

-- Define a coroutine for the player's adventure
local adventureCoroutine

-- Define the player's attributes using tables.
print("Enter Your Name")
local name = io.read()

local player = {
    name = "Hello, " .. name,
    inventory = {},
}

local location = {
    name = "Lua Forest",
    description = "A dense forest with tall trees and mysterious creatures."
}

-- Define a function to display the game state.
local function displayGame()
    print("------------------------------------------------------------------------------------")
    print("Lua Land Adventure")
    print("Player: " .. player.name)
    print("Location: " .. location.name)
    print("Description: " .. location.description)
    print("------------------------------------------------------------------------------------")
end

-- Define a function for the player's action.
local function explore()
    -- Check if the coroutine is already created and reset it
    adventureCoroutine = nil

    -- Create a new coroutine for the adventure
    adventureCoroutine = coroutine.create(function()
        if not player.exploredForest then
            print("")
            print("You receive a mission by a local commissioner to explore the Lua Forest and find the long-lost treasure of the Lua Forest.")
            print("You are to navigate the forest until you find a flowing river, a talking old banyan tree, and a snake demon.")
            print("Once you clear all the checkpoints, you are required to bring the treasure back to your commissioner for a $5000 reward.")
            player.exploredForest = true -- Set the flag to true to indicate the forest has been explored
        else
            print("You are already on the mission to explore the Lua Forest.")
            return
        end

        local continuePlaying = true

        while continuePlaying do
            print("")
            print("What would you like to do?")
            print("1. Continue exploring the forest.")
            print("2. Quit exploring and return to the main menu")

            local choice = io.read()

            if choice == "1" then
                print("")
                print("Continue along the path of the forest headed for the river until you reach a fork.")
                print("The left path shows animal footprints, while the right path is full of dried leaves and branches.")

                while true do
                    print("")
                    print("Which path would you like to choose?")
                    print("1. The right path")
                    print("2. The left path")

                    local pathChoice = io.read()

                    if pathChoice == "1" then
                        print("")
                        print("You've chosen the wrong path. The path seems eerie the more you walk. Unfortunately, you run into a bear and get mauled alive.")

                        while true do
                            print("")
                            print("You died. Restart the game?")
                            print("1. Yes")
                            print("2. No")

                            local wrongPath = io.read()

                            if wrongPath == "1" then
                                player.exploredForest = false -- Reset the exploration status
                                return
                            elseif wrongPath == "2" then
                                print("Goodbye!")
                                os.exit()
                            else
                                print("Invalid choice. Please select a valid option.")
                            end
                        end
                    elseif pathChoice == "2" then
                        print("You chose the left path. As you keep walking, you hear the sound of running water more clearly and keep walking until you reach a river")

                        while true do
                            print("")
                            print("You found the river and follow the stream until it reaches the old banyan tree. What would you like to do?")
                            print("1. Ask politely to the old banyan tree for the clues to the treasure")
                            print("2. Demand the old banyan tree to give you the treasure")

                            local treeChoice = io.read()

                            if treeChoice == "1" then
                                print("")
                                print("The old banyan tree stated that you need to catch 3 butterflies by hand and without using any tools before releasing them in front of the tree in order to obtain the clues.")

                                local goToTreeChoice = false

                                while true do
                                    print("")
                                    print("You feel burdened by the request but need to finish them in order to obtain the clue. What would you do?")
                                    print("1. You secretly use a net and jars to catch the butterflies")
                                    print("2. You oblige with the old banyan tree's rules and start to catch the butterflies by hand")

                                    local treeRequest = io.read()

                                    if treeRequest == "1" then
                                        print("")
                                        print("The old banyan tree knows that you are cheating.")
                                        print("1. Hold your ground and claim that you did not cheat")
                                        print("2. Admit your mistake and ask for another chance")

                                        local butterflyChoice = io.read()

                                        if butterflyChoice == "1" then
                                            print("")
                                            print("The old banyan tree is unmoved by your arguments and punishes you. You die. Restart the game?")
                                            print("1. Yes")
                                            print("2. No")

                                            local midGame = io.read()
                                            if midGame == "1" then
                                                player.exploredForest = false
                                                return
                                            elseif midGame == "2" then
                                                print("Goodbye!")
                                                os.exit()
                                            else
                                                print("Invalid choice. Please select a valid option.")
                                            end
                                        elseif butterflyChoice == "2" then
                                            print("")
                                            print("The old banyan tree appreciates your honesty and grants you the clues to the treasure.")
                                            print("You then continue to the snake demon cave for the treasure.")
                                            goToTreeChoice = true

                                            while true do
                                                print("")
                                                print("During your journey to the snake demon cave, you look at the clues you've gotten from the old banyan tree. 'Everything that reflects is everything that is true' You wonder what it means.")
                                                print("You then reach the snake demon cave. It told you if you want the treasure you need to answer a riddle in one attempt and if you lose it will eat you. What is your choice?")
                                                print("1. Accept the snake demon challenge")
                                                print("2. Demand the snake demon to just hand over the treasure at you")

                                                local snakeRiddle = io.read()
                                                if snakeRiddle == "1" then
                                                    print("")
                                                    print("The snake demon then recites a riddle. 'I am the only thing that always tells the truth. I show off everything that I see. I come in all shapes and sizes. So tell me what I must be!'")
                                                    print("You start to think. Based on the riddles and the clues from the old banyan tree you are confident that the answer is a mirror. You shout the answer and then the snake demon magically turns into the treasure.")
                                                    print("You feel happy and hurriedly bring the treasure back to the commissioner and receive your rewards.")
                                                    print("")
                                                    print("Good job on finishing the adventure! Enjoy your reward and Goodbye!")
                                                    os.exit()
                                                elseif snakeRiddle == "2" then
                                                    print("")
                                                    print("Bad choices. The snake demon got angry and ate you as their dinner. Restart the game?")
                                                    print("1. Yes")
                                                    print("2. No")
                                                    local lastStep = io.read()
                                                    if lastStep == "1" then
                                                        player.exploredForest = false
                                                        return
                                                    elseif lastStep == "2" then
                                                        print("Goodbye!")
                                                        os.exit()
                                                    else
                                                        print("Invalid choice. Please select a valid option.")
                                                    end
                                                else
                                                    print("Invalid choice. Please select a valid option.")
                                                end
                                            end
                                            if goToTreeChoice then
                                                break
                                            end
                                        else
                                            print("Invalid choice. Please select a valid option.")
                                        end
                                    elseif treeRequest == "2" then
                                        print("")
                                        print("The old banyan tree is pleased with your honesty and grants you the clues to the treasure.")
                                        print("You then continue to the snake demon cave for the treasure.")

                                        while true do
                                            print("")
                                            print("During your journey to the snake demon cave, you look at the clues you've gotten from the old banyan tree. 'Everything that reflects is everything that is true' You wonder what it means.")
                                            print("You then reach the snake demon cave. It told you if you want the treasure you need to answer a riddle in one attempt and if you lose it will eat you. What is your choice?")
                                            print("1. Accept the snake demon challenge")
                                            print("2. Demand the snake demon to just hand over the treasure at you")

                                            local snakeRiddle = io.read()
                                            if snakeRiddle == "1" then
                                                print("")
                                                print("The snake demon then recites a riddle. 'I am the only thing that always tells the truth. I show off everything that I see. I come in all shapes and sizes. So tell me what I must be!'")
                                                print("You start to think. Based on the riddles and the clues from the old banyan tree you are confident that the answer is a mirror. You shout the answer and then the snake demon magically turns into the treasure.")
                                                print("You feel happy and hurriedly bring the treasure back to the commissioner and receive your rewards.")
                                                print("")
                                                print("Good job on finishing the adventure! Enjoy your reward and Goodbye!")
                                                os.exit()
                                            elseif snakeRiddle == "2" then
                                                print("")
                                                print("Bad choices. The snake demon got angry and ate you as their dinner. Restart the game?")
                                                print("1. Yes")
                                                print("2. No")
                                                local lastStep = io.read()
                                                if lastStep == "1" then
                                                    player.exploredForest = false
                                                    return
                                                elseif lastStep == "2" then
                                                    print("Goodbye!")
                                                    os.exit()
                                                else
                                                    print("Invalid choice. Please select a valid option.")
                                                end
                                            else
                                                print("Invalid choice. Please select a valid option.")
                                            end
                                        end
                                    else
                                        print("Invalid choice. Please select a valid option.")
                                    end
                                end
                            elseif treeChoice == "2" then
                                print("")
                                print("The old banyan tree thinks that you are rude. It starts to shake and grow bigger to intimidate you. It gives you 1 more chance to be polite or it will punish you.")
                                print("1. Start apologizing and politely ask the old banyan tree for its help")
                                print("2. Show how brave you are and start threatening to cut the tree branches")

                                local badChoice = io.read()
                                if badChoice == "1" then
                                    print("")
                                    print("The old banyan tree gives you a chance and states its request.")
                                    local goToTreeChoice = false

                                    while true do
                                        print("")
                                        print("You feel burdened by the request but need to finish them in order to obtain the clue. What would you do?")
                                        print("1. You secretly use a net and jars to catch the butterflies")
                                        print("2. You oblige with the old banyan tree's rules and start to catch the butterflies by hand")

                                        local treeRequest = io.read()
                                        if treeRequest == "1" then
                                            print("")
                                            print("The old banyan tree knows that you are cheating.")
                                            print("1. Hold your ground and claim that you did not cheat")
                                            print("2. Admit your mistake and ask for another chance")

                                            local butterflyChoice = io.read()
                                            if butterflyChoice == "1" then
                                                print("")
                                                print("The old banyan tree is unmoved by your arguments and punishes you. You die. Restart the game?")
                                                print("1. Yes")
                                                print("2. No")

                                                local midGame = io.read()
                                                if midGame == "1" then
                                                    player.exploredForest = false
                                                    return
                                                elseif midGame == "2" then
                                                    print("Goodbye!")
                                                    os.exit()
                                                else
                                                    print("Invalid choice. Please select a valid option.")
                                                end
                                            elseif butterflyChoice == "2" then
                                                print("")
                                                print("The old banyan tree appreciates your honesty and grants you the clues to the treasure.")
                                                print("You then continue to the snake demon cave for the treasure.")

                                                while true do
                                                    print("")
                                                    print("During your journey to the snake demon cave, you look at the clues you've gotten from the old banyan tree. 'Everything that reflects is everything that is true' You wonder what it means.")
                                                    print("You then reach the snake demon cave. It told you if you want the treasure you need to answer a riddle in one attempt and if you lose it will eat you. What is your choice?")
                                                    print("1. Accept the snake demon challenge")
                                                    print("2. Demand the snake demon to just hand over the treasure at you")

                                                    local snakeRiddle = io.read()
                                                    if snakeRiddle == "1" then
                                                        print("")
                                                        print("The snake demon then recites a riddle. 'I am the only thing that always tells the truth. I show off everything that I see. I come in all shapes and sizes. So tell me what I must be!'")
                                                        print("You start to think. Based on the riddles and the clues from the old banyan tree you are confident that the answer is a mirror. You shout the answer and then the snake demon magically turns into the treasure.")
                                                        print("You feel happy and hurriedly bring the treasure back to the commissioner and receive your rewards.")
                                                        print("")
                                                        print("Good job on finishing the adventure! Enjoy your reward and Goodbye!")
                                                        os.exit()
                                                    elseif snakeRiddle == "2" then
                                                        print("")
                                                        print("Bad choices. The snake demon got angry and ate you as their dinner. Restart the game?")
                                                        print("1. Yes")
                                                        print("2. No")
                                                        local lastStep = io.read()
                                                        if lastStep == "1" then
                                                            player.exploredForest = false
                                                            return
                                                        elseif lastStep == "2" then
                                                            print("Goodbye!")
                                                            os.exit()
                                                        else
                                                            print("Invalid choice. Please select a valid option.")
                                                        end
                                                    else
                                                        print("Invalid choice. Please select a valid option.")
                                                    end
                                                end
                                            end
                                        elseif treeRequest == "2" then
                                            print("")
                                            print("The old banyan tree is pleased with your honesty and grants you the clues to the treasure.")
                                            print("You then continue to the snake demon cave for the treasure.")

                                            while true do
                                                print("")
                                                print("During your journey to the snake demon cave, you look at the clues you've gotten from the old banyan tree. 'Everything that reflects is everything that is true' You wonder what it means.")
                                                print("You then reach the snake demon cave. It told you if you want the treasure you need to answer a riddle in one attempt and if you lose it will eat you. What is your choice?")
                                                print("1. Accept the snake demon challenge")
                                                print("2. Demand the snake demon to just hand over the treasure at you")

                                                local snakeRiddle = io.read()
                                                if snakeRiddle == "1" then
                                                    print("")
                                                    print("The snake demon then recites a riddle. 'I am the only thing that always tells the truth. I show off everything that I see. I come in all shapes and sizes. So tell me what I must be!'")
                                                    print("You start to think. Based on the riddles and the clues from the old banyan tree you are confident that the answer is a mirror. You shout the answer and then the snake demon magically turns into the treasure.")
                                                    print("You feel happy and hurriedly bring the treasure back to the commissioner and receive your rewards.")
                                                    print("")
                                                    print("Good job on finishing the adventure! Enjoy your reward and Goodbye!")
                                                    os.exit()
                                                elseif snakeRiddle == "2" then
                                                    print("")
                                                    print("Bad choices. The snake demon got angry and ate you as their dinner. Restart the game?")
                                                    print("1. Yes")
                                                    print("2. No")
                                                    local lastStep = io.read()
                                                    if lastStep == "1" then
                                                        player.exploredForest = false
                                                        return
                                                    elseif lastStep == "2" then
                                                        print("Goodbye!")
                                                        os.exit()
                                                    else
                                                        print("Invalid choice. Please select a valid option.")
                                                    end
                                                else
                                                    print("Invalid choice. Please select a valid option.")
                                                end
                                            end
                                        else
                                            print("Invalid choice. Please select a valid option.")
                                        end
                                    end
                                elseif badChoice == "2" then
                                    print("")
                                    print("Bad choices. The old banyan tree got angry and struck its branches at you. You died. Restart the game?")
                                    print("1. Yes")
                                    print("2. No")
                                    local lastStep = io.read()
                                    if lastStep == "1" then
                                        player.exploredForest = false
                                        return
                                    elseif lastStep == "2" then
                                        print("Goodbye!")
                                        os.exit()
                                    else
                                        print("Invalid choice. Please select a valid option.")
                                    end
                                else
                                    print("Invalid choice. Please select a valid option.")
                                end
                            else
                                print("Invalid choice. Please select a valid option.")
                            end
                        end
                    else
                        print("Invalid choice. Please select a valid option.")
                    end
                end
            elseif choice == "2" then
                print("")
                print("You decided to quit exploring the forest and return to the main menu.")
                return
            else
                print("Invalid choice. Please select a valid option.")
            end
        end
    end)

    -- Start the coroutine
    coroutine.resume(adventureCoroutine)
end

-- Define a function for garbage collection
local function performGarbageCollection()
    collectgarbage("collect") -- Collect all garbage
    collectgarbage("stop")    -- Stop automatic collection
end
    
-- Main game loop

local continuePlaying = true
while continuePlaying do
    displayGame()
    print("")
    print("What would you like to do?")
        print("1. Start Game")
        print("2. Quit Game")

    local choice = io.read()

    if choice == "1" then
        explore()

        -- Perform garbage collection after each adventure to manage memory
        performGarbageCollection()
    elseif choice == "2" then
        print("Goodbye!")

        -- Perform garbage collection before exiting the game
        performGarbageCollection()

        continuePlaying = false
    else
        print("Invalid choice. Please select a valid option.")
    end
end
