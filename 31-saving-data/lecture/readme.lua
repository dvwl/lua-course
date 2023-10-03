-- This section talks about setting up data stores
-- We'll explore saving and updating saved data

-- Enabling Data Stores
-- 1. Make sure the experience is published to Roblox and not just saved locally on your computer.
-- 2. On the Home tab, click Game Settings.
-- 3. Select Security and turn on Enable Studio Access to API Services. You can then save and exit Game Settings.

-- Create a Data Store
local DataStoreService = game:GetService("DataStoreService")
local dataStoreName = DataStoreService:GetDataStore("DataStoreName")

-- Tips: Make sure names are unique

-- Using Data Store
local DataStoreService = game:GetService("DataStoreService")
local dataStoreName = DataStoreService:GetDataStore("DataStoreName")
-- Update info in the Data Store, or create a new key/value pair
local updateStat = dataStoreName:SetAsync("StatName", value)
-- Retrieve information from the store using the key name
local storedStat = dataStoreName:GetAsync("StatName")

-- Tip: SetAsync() will override the value of a key if it already exist

-- Setting up the Demo: Tracking Clicks / Interaction
-- 1. Insert a part (could be just a block or something fancy from Template), named it ClickCrate
-- 2. Insert a SurfaceGui into ClickCrate
-- 3. Insert TextLabel named ClickDisplay
-- 4. Insert ProximityPrompt named CratePrompt, modify HoldDuration to enable debounce
	-- Workspace
		-- ClickCrate
			-- CrateScript (in the lecture I called this UpdateDsiplay)
			-- CratePrompt
			-- SurfaceGui
				-- ClickDisplay
-- 5. You'll need two scripts, CrateManager and CrateScript (this updates the display).

-- Proctecting Your Data
-- Recall pcall()
-- You could update the while loop in CrateManager.lua to the following:

-- Update the Data Store every so often
while wait(SAVE_FREQUENCY) do
	local setSuccess, errorMessage = pcall(function()
		crateData:SetAsync("TotalClicks", totalClicks)
	end)
	if not setSuccess then
		print(errorMessage)
	else
		print("Current Coun t:")
		print(crateData:GetAsync("TotalClicks"))
	end
end

-- Saving Player Data
-- Tips: Player name may change. Use Player's ID.
local Players = game:GetService("Players")

local function onPlayerAdded(player)
	local playerKey = "Player _" .. player.UserId
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- UpdateAsync to Update a Data Store
-- Similar to SetAsync()
-- When called, UpdateAsync() returns the old value of a key and then updates it.
-- Here's an example:
local updateSuccess, errorMessage = pcall(function()
	pointsDataStore:UpdateAsync(playerKey, function(oldValue)
		local newValue = oldValue or 0
		newValue = newValue + GOLD_ON_JOIN
		return newValue
	end)
end)
