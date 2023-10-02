-- Game by: Mohamad Amirul Afieq Danial Azlan
-- remark: the game is about dating simulation that happen in lua island, to create the game i divide it to 4 main part which is Characterlist,affection meter,story table, and user interface, after that i use chat gpt to generate the main base for the coding before modifying it as i see fit

-- Define female character details in Lua tables
local femaleCharacters = {
    {
        name = "Alice",
        gender = "Female",
        age = 20,
        personality = "cheerful,positive",
        likes = "Reading, hiking",
        dislikes = "Spiders, fast food",
        favorability = 10, -- Starting favorability
    },
    {
        name = "Emma",
        gender = "Female",
        age = 21,
        personality = "mature,cold",
        likes = "Cooking, painting",
        dislikes = "Crowded places, reality TV",
        favorability = 20,
    },
}

-- Define favorability levels and their corresponding states
local favorabilityLevels = {
    { level = 20, state = "acquaintance" },
    { level = 50, state = "friend" },
    { level = 120, state = "close friend" },
    { level = 200, state = "lover" },
}

-- Function to display character details (age, gender, and favorability state)
local function displayCharacterDetails(character)
    print("><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>:")
    print("\nCharacter Details                                               ")
    print("Name              : " .. character.name.."                        ")
    print("Gender            : " .. character.gender.."                      ")
    print("personality       : " .. character.personality.."                 ")
    print("Age               : " .. character.age.."                         ")

    -- Determine favorability state
    local favorabilityState = "stranger"
    for _, levelData in ipairs(favorabilityLevels) do
        if character.favorability >= levelData.level then
            favorabilityState = levelData.state
        else
            break
        end
    end

    print("Favorability State: " .. favorabilityState.."                     ")
    print("><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>:")
end

print("PROLOGUE")
print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,")
print("you suddenly been kidnapped out of places, without any knowledge nor tools you are left with nothing,")
print("to survive 'urgh, where am I?' wondering around in the loneliness soon you found out there was a    ,")
print("nearby village where you will meet the heroine in order to survive the upcoming event, you need to  ,")print("make sure the heroine fall in love with you or your death will be guaranteed!                       ,")
print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,")
print("")

-- Define storylines for Alice
local aliceStorylines = {
    {
        question = "1. (after a few minute regaining my conciousness, I currently wondering around without any guide, suddenly a fair and light voice greet me in surprise) 'hey,hey are you alright??",
        A = {
            text = "(I smile gently enduring my excruciating pain) thank you I,m bit alright!",
            affectionChange = 20,
            nextSegment = 2,
        },
        B = {
            text = "Oh, that's a shame.",
            affectionChange = -10,
            nextSegment = 2,
        },
    },
    {
        question = "2. oh, hehe forgot to introduce myself, I'm Alice! just your friendly neighborhood Alice.btw what are you doing here, its dangerous you know? come follow me to the village (as I follow Alice, the cheerful vibe she give me gradually change and know she completely as ice untill we arrive at her hut) sigh... that was stressful remember when you go out around the village don't show any reaction",
        A = {
            text = " is there any monster that will take your emotion as you express it around here or something haha (it was supposed to be a joke however seeing her reaction, i was hit by the sudden reality of how dangerous my current situation is!).",
            affectionChange = 15,
            nextSegment = 3,
        },
        B = {
            text = "I think I'll go alone for a while.",
            affectionChange = -5,
            nextSegment = 3,
        },
    },
    {
        question = "3. (Alice just nod silently), actually this island is called lualand a very dangerous island, I don't know the logic however you can't escape this island as long the guardian still existed, food is very limited so each vllager here will only think about themselve so when you find any valuable don't tell them! they would just rob you",
        A = {
            text = "can i just pass the guardian by asking the villager for some help?.",
            affectionChange = 15,
            nextSegment = 4,
        },
        B = {
            text = "eh!!? (suddenly i was hit by a sudden strong sense of deja vu) wait, wait a bit Alice so are you saying you been trap here?",
            affectionChange = 10,
            nextSegment = 4,
        },
    },
    {
        question = "4. How do you feel about this place?(I couldn't help to honestly answer it was pretty creepy)pin pong! you're right, asking the villager?? don't be ridiculous after staying here for so long, they already turn into bunch of maniac that would do everything to survive and they would even it you alive you know~...let be honest... will you escape with me together?",
        A = {
            text = "of course! I want to survive after all.",
            affectionChange = 20,
            nextSegment = 5,
        },
        B = {
            text = "Don't worry I'll be your ally (but still lua land? isn't it the name of my game i wrote? don't tell me it become reality?pfft ahaha there's no way....right??)",
            affectionChange = 30,
            nextSegment = 5,
        },
    },
    {
        question = "5. really!?? hooray! (seeing Alice cheerfully celebrate, I smile and made a promise to myself that i would send this girl out to escape) hehe now that i have ally, we can finally begin the escaping mission *clap*clap* (after that Alice told me that she actually already prepared the escape plan long ago however she was threatened by the villlager to stay put. when she explain the plan i was amazed on how detail it could be!)",
        A = {
            text = "what are through plan you're amazing Alice, so the first step is to secure the boat at northeast of the island right? so we just need to deal with the beast there",
            affectionChange = 20,
            nextSegment = 6,
        },
        B = {
            text = "hmm, so first we need to find the supply that you have buried in the mountain then come back to prepare the escaping tools right?.",
            affectionChange = 0,
            nextSegment = 6,
        },
    },
    {
        question = "6. (as we start splitting, we search for sny supplies and making sure the boat position of the boat at the northeast and it's condition ) our plan seems doable, we even manage to obtain lot of loots,hehe these old fossil who only know to cower in fear will never know (Alice giggle like a little girl, then we start to move in the boat direction however unexpectedly we encounter a ferocious beast on the way)",
        A = {
            text = "oh darn it, what a bad luck should we run for it? .",
            affectionChange = 20,
            nextSegment = 7,
        },
        B = {
            text = "urgh a beast, should we fight it?.",
            affectionChange = -5,
            nextSegment = 7,
        },
    },
    {
        question = "7. Hmm, i think even if we left it alone, it would not be a problem.... gotta run hehe!(we decide to escape and find another route) fuh finally, this is the moment...(suddenly a tear drop fall from Alice face, i was concerned about it)oh haha its nothing, it just finally i will gain freedom for my life",
        A = {
            text = "(hearing the line i suddenlly feel ominous and gain realization)...wait lua land? Alice? oh no! (no doubt this was the game i wrote in my spare time and right now i suddently appear in it, wait Alice line!!) Alice let's head back you will die at this rate!",
            affectionChange = 20,
            nextSegment = 8,
        },
        B = {
            text = "(hearing the line i suddenlly feel ominous and gain realization)...wait lua land? Alice? oh no! (no doubt this was the game i wrote in my spare time and right now i suddently appear in it, wait Alice line!!) Alice lets find another route (as i remember if we continue ahead we will definitely died the same way in the game) don't worry we will survive.",
            affectionChange = 50,
            nextSegment = 8,
        },
    },
    {
        question = "8. Huh but why? (i know, i also wonder why however after remembering everything that this was the curse romance game that i made, i realized that going forward will only raise the death flag to survive we need to go another route) we just step ahead",
        A = {
            text = " Alice please believe me we will survive this (after that we got through another route which take us a bit more time however we manage to take the boat more easily)",
            affectionChange = 20,
            nextSegment = 9,
        },
        B = {
            text = "just follow me i will guide you, you don't have to think too much Alice.",
            affectionChange = -5,
            nextSegment = 9,
        },
    },
    {
        question = "9. is this the end (i nod, we are currently on the boat but i know for those who stay their fate is worst than death) hey..hey lo..look at that?? (i grimly watch the sight of the island that gradually been consumed by a dark fog after a while we could only see the remnant of skeleton floating around) hiee..(Alice hug me tight;y not daring to see the phenomenon) if..if we stay would we be like them?",
        A = {
            text = "yes! and probably.... no, never mind (i smile at Alice) lets go back home!",
            affectionChange = 20,
            nextSegment = 10,
        },
        B = {
            text = "who knows? maybe their death is already something that had been determined. lets go back home",
            affectionChange = -5,
            nextSegment = 10,
        },
    },
    {
        question = "10. sigh' i really don't want to know about the island anymore, so how do we got back (i remember at this time an emergency helicopter will come to observe the weird phenomenon that just occurred) hmm what's up?",
        A = {
            text = "(As Alice look up i suddenly embraced her tightly, at first she struggle but overtime she hug back, and that how the story end)",
            affectionChange = 50,
            nextSegment = 11, -- Ending
        },
        B = {
            text = "(Alice smile as i smile back) finally its time to go back home....",
            affectionChange = -10,
            nextSegment = 11, -- Ending
        },
    },
    -- Ending segments for Alice
    {
        endingText = "Bad Ending: Your relationship with Alice didn't work out.",
    },
    {
        endingText = "Normal Ending: You and Alice became good friends.",
    },
    {
        endingText = "Good Ending: Congratulations! Alice has fallen in love with you!",
    },
}

-- Define storylines for Emma
local emmaStorylines = {
    {
        question = "1. hey wake up, do you know where we are (as i open my eye i was greeted by a beautiful woman in front of me, i couldn't help but ask her name) me? I'm Emma and it seems both of us are stranded on a strange island together",
        A = {
            text = "Strange island? is there any people here? but then again it would be weird for people to live here",
            affectionChange = 15,
            nextSegment = 2,
        },
        B = {
            text = "urgh my head, strange island!?? what is this place?.",
            affectionChange = -5,
            nextSegment = 2,
        },
    },
    {
        question = "2. people? don't bother the last time i tried asking them what is this place, they eyes become red and suddenly kick me out of the village like a madmen! while there's alright there is also some people who look at me like a food making me shivered... good thing, I met with this girl call Alice who explain to me about our condition",
        A = {
            text = "Alice! urg!!(i could feel my head hurts as if i was remebering my past life memories) wait, wait is this place called lua island?.",
            affectionChange = 20,
            nextSegment = 3,
        },
        B = {
            text = "the villager? bloodthirsty? island? where did i hear this before...!!! (hit by a sudden realization i seem to remeber that this place was a game setting i created before)",
            affectionChange = 10,
            nextSegment = 3,
        },
    },
    {
        question = "3. (Emma look at my suprise face calmly) what's wrong you seem pale?",
        A = {
            text = "Emma! we need to leave this place immediately or we will die...",
            affectionChange = 15,
            nextSegment = 4,
        },
        B = {
            text = "stranger it may sound sudden but we need to escape this place early!",
            affectionChange = 10,
            nextSegment = 4,
        },
    },
    {
        question = "4. huh? (Emma made a confuse face) what are you talking about? (then i begin to explain to her about my memory and about this island in which one of the game i created for fun) what a cursed game to think 9 out of 10 is bad ending and most of it end with the island being it by large unknown beast, dissapear into fog and etc. are you sure you are ok making this game",
        A = {
            text = "(I want to blame my idiocy for making such game if i know i would reduce the difficulty) we don't have much time from i know there is a boat at the northeast of this island",
            affectionChange = 20,
            nextSegment = 5,
        },
        B = {
            text = "urg your comment hurt, anyway there is a boat in the northeast island however it will take 3-4 day to walk there by foot we need to prepare well",
            affectionChange = -5,
            nextSegment = 5,
        },
    },
    {
        question = "5. (we began to prepare everything we need for the trip, instead of asking the vllager Emma and I search for food in the wilderness, i was suprised by how efficient emma is) heh well that's a given i'm pretty good with my hand",
        A = {
            text = "(we began to move forward facing the challenge together)",
            affectionChange = 20,
            nextSegment = 6,
        },
        B = {
            text = "(most of the time, I always go out alone before journeying together)",
            affectionChange = -5,
            nextSegment = 6,
        },
    },
    {
        question = "6. wait what is that?(when we arrive at certain cave we found many remnant of skeleton) this... looks like human skeleton ",
        A = {
            text = "you look pretty calm facing this.",
            affectionChange = 20,
            nextSegment = 7,
        },
        B = {
            text = "aren't you disgust by it?",
            affectionChange = -5,
            nextSegment = 7,
        },
    },
    {
        question = "7. well i was a med student after all (suddenly behind a rushing bush a man came out) man: hey it.. its dangerous here you need to run away there's man eater beast roaming around (i noticed a strong stench of blood from this man but i just ignored it) a beast, what a troublesome could you scout a bit",
        A = {
            text = "(i just nod) sure i'll be back by later. after an hour i didn't found any man eater beast but i found a huge pile of bad meat to be specifically human meat, don't tell me.... darn it!!",
            affectionChange = 20,
            nextSegment = 8,
        },
        B = {
            text = "be on your guard, this guy seems weird (emma reassured me with the handcraft knife she made) while i was scouting, i suddenly remember in the game there is villager who practise cannibalism... oh no !! EMMA IN DANGER! ",
            affectionChange = 30,
            nextSegment = 8,
        },
    },
    {
        question = "8. kuh you bastard let me go! man: don..don't struggle you will call the beasstt! huh the beast i feel like you are the beast here. man: arghhh don't cal..call me beast YOU WOMAN! (Emma close her eye tiightly)",
        A = {
            text = "(seeing the crazy npc just like in the game and emma being tied I hurried up my pace) hey you bastard im here! (i punch the madman however i received injury)",
            affectionChange = -10,
            nextSegment = 9,
        },
        B = {
            text = "(looking at the madman trying to shove his weapon i guard it with my body causing me to bleed) urgh, that's hurt you crazy npc of mine (i kicked the madman far away)",
            affectionChange = -5,
            nextSegment = 9,
        },
    },
    {
        question = "9. HEY ARE YOU OK? (as we rushing in mad,making our escape the calm and mature emma was frantically worried about my injuries) im sorry, im med student but i couldn't notice such thick blood smell from him ",
        A = {
            text = "its ok we need to get to the boat now, its already 3 day. In my calculation the ending will happen soon(finally we arrive at our escape boat and hurriedly start the engine)",
            affectionChange = 20,
            nextSegment = 10,
        },
        B = {
            text = "don't mind me hurried up to the boat in a few hour this island will be no more(we start the engine as soon as we get to the boat)",
            affectionChange = -5,
            nextSegment = 10,
        },
    },
    {
        question = "10. (sigh' i finally breathe in relief as we got far from the boat) *sniff* i'm sorry really (i smile and pat emma head) hey...hey where..where is the island?",
        A = {
            text = "(Emma voice trembling in fear as she witness there was nothing from the place she escape before) its ok(i hug emma tightly and smile because i know after this there will be rescuer on the way to investigate this matter) thank you emma for being with me (story end)",
            affectionChange = 50,
            nextSegment = 11, -- Ending
        },
        B = {
            text = "the island is gone (emma just stare dumbly at the scene before smile back at me) hah its ok there will be recuer soon on the way let just take this time to relax shall we(story end)",
            affectionChange = -10,
            nextSegment = 11, -- Ending
        },
    },
    -- Ending segments for Emma
    {
        endingText = "Bad Ending: Your relationship with Emma didn't work out.",
    },
    {
        endingText = "Normal Ending: You and Emma became good friends.",
    },
    {
        endingText = "Good Ending: Congratulations! Emma has fallen in love with you!",
    },
}

-- Main program
print("")
print("-----------------------------------------------------------------:")
print("Welcome to the Lua land Dating Game!                             :")

while true do
    -- Display a menu to choose a female character
    print("\nPlease choose from these two heroines:")
    for i, character in ipairs(femaleCharacters) do
        print(i .. ". " .. character.name)
    end

    print("0. Exit")
    print("-----------------------------------------------------------------:")

    -- Prompt the user to pick a character by number
    io.write("Enter the number of your chosen character (0 to exit):")
    local chosenIndex = tonumber(io.read("*n"))

    -- Check if the user wants to exit
    if chosenIndex == 0 then
        break
    elseif chosenIndex >= 1 and chosenIndex <= #femaleCharacters then
        local chosenCharacter = femaleCharacters[chosenIndex]

        -- Display the selected character's age and gender
        displayCharacterDetails(chosenCharacter)

        -- Initialize variables for the story
        local storyChoiceCount = 0
        local affectionLevel = chosenCharacter.favorability
        local storySegment = 1
        local storyComplete = false

        -- Start the story
        while storyChoiceCount < 10 and not storyComplete do
            print("-------------------------------------------------------------------------------------:")
            print("\nChoose an option:")
            print("A. Continue with the Story")
            print("B. Back to Menu")
            io.write("Enter your choice (A/B): ")
            local choice = io.read()
            if choice == "A" or choice == "a" then
                local currentSegment = chosenCharacter.name == "Alice" and aliceStorylines[storySegment] or emmaStorylines[storySegment]
                print("======================================================================================")
                print("" .. currentSegment.question)
                print("")
                print("A. " .. currentSegment.A.text)
                print("B. " .. currentSegment.B.text)
                print("======================================================================================")
                io.write("Enter your choice (A/B): ")
                choice = io.read()

                if choice == "A" or choice == "a" then
                    affectionLevel = affectionLevel + currentSegment.A.affectionChange
                    storySegment = currentSegment.A.nextSegment
                elseif choice == "B" or choice == "b" then
                    affectionLevel = affectionLevel + currentSegment.B.affectionChange
                    storySegment = currentSegment.B.nextSegment
                else
                    print("Invalid choice. Please choose A or B.")
                end
                storyChoiceCount = storyChoiceCount + 1
            elseif choice == "B" or choice == "b" then
                break -- Go back to the main menu
            else
                print("Invalid choice. Please choose A or B.")
            end

            if storyChoiceCount == 10 then
                storyComplete = true
            end
        end

        -- Display the ending based on the affection level
        local endingSegment = 11 -- Default ending segment
        if storySegment == 11 then
            if affectionLevel < 120 then
                endingSegment = 9 -- Bad ending
            elseif affectionLevel >= 120 and affectionLevel < 199 then
                endingSegment = 8 -- Normal ending with becoming friends
            elseif affectionLevel >= 200 then
                endingSegment = 7 -- Good ending
            end
        end

      	-- Display the current affection and ending story
		print("\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
		print("== CURRENT AFFECTION LEVEL: " .. affectionLevel .. " ==")
		print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")

		local endingText = ""
		if chosenCharacter.name == "Alice" then
			endingText = aliceStorylines[endingSegment].endingText
		elseif chosenCharacter.name == "Emma" then
			endingText = emmaStorylines[endingSegment].endingText
		end

		print("\n" .. endingText)
        -- Ask the user to continue or go back to the main menu
        if storyChoiceCount < 10 then
            print("\nOptions:")
            print("1. Continue")
            print("2. Back to Menu")
            io.write("Choose an option: ")
            local option = tonumber(io.read("*n"))
            if option == 2 then
                break -- Go back to the main menu
            end
        end
    else
        print("Invalid selection. Please choose a valid character number.")
    end
end

print("Goodbye!")
