-- A common set of stats in competitive experiences are a person’s number of kills, deaths, and assists (other people’s kills they’ve contributed to). Take a sample dictionary such as the one shown here, and sort it according to who has the most kills. If people are tied for kills, prioritize who has assisted other members of the team the most.

-- Tips:
-- Include three to five different players and try to make sure some of them are tied for most kills. You can use the following example dictionary if you like: 
local playerKDA = {
	Ana = {kills = 0, deaths = 2, assists = 20},
	Beth = {kills = 7, deaths = 5, assists = 0},
	Cat = {kills = 7, deaths = 0, assists = 5},
	Dani = {kills = 5, deaths = 20, assists = 8},
	Ed = {kills = 1, deaths = 1, assists = 8},
}

-- You will have to convert the dictionary to an array.
-- Printing the array right after it’s created and before it’s sorted can be a good troubleshooting step for making sure the array looks the way you expect.
-- You may display this sorted dictionary in a leaderboard
