-- ServerStorage > Folder "ModuleScripts" > Create "ModuleScripts" > Name "PlayerManager"
local PlayerManager = {}

-- Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Variables
local lobbySpawn = workspace.Lobby.StartSpawn
local arenaMap = workspace.Arena
local arenaSpawn = arenaMap.SpawnLocation

local events = ServerStorage.Events
local roundEnd = events.RoundEnd
local roundStart = events.RoundStart

local function onPlayerJoin(player)
	player.RespawnLocation = lobbySpawn
end

local function onRoundStart()
	for _, player in ipairs(Players:GetPlayers()) do
		player.RespawnLocation = arenaSpawn
		player:LoadCharacter()
	end
end

local function onRoundEnd()
	for _, player in ipairs(Players:GetPlayers()) do
		player.RespawnLocation = lobbySpawn
		player:LoadCharacter()
	end
end

-- Connect the functions
Players.PlayerAdded:Connect(onPlayerJoin)
roundStart.Event:Connect(onRoundStart)
roundEnd.Event:Connect(onRoundEnd)

return PlayerManager