-- ServerScriptStorage > Create "Scripts" > Name "RoundManager"
-- Services
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Module Scripts
local moduleScripts = ServerStorage.ModuleScripts
local playerManager = require(moduleScripts.PlayerManager)
local roundSettings = require(moduleScripts.RoundSettings)

-- Events
local events = ServerStorage.Events
local roundStart = events.RoundStart
local roundEnd = events.RoundEnd

-- runs the game loop
while true do
	repeat
		wait(roundSettings.breakDuration)
	until Players.NumPlayers >= roundSettings.minimumPeople
	roundStart:Fire()
	wait(roundSettings.roundDuration)
	roundEnd:Fire()
end