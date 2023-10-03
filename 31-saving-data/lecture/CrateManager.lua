-- ServerScriptStorage > Create "Scripts" > Name "CrateManager"
local ProximityPromptService = game:GetService("ProximityPromptService")
local DataStoreService = game:GetService("DataStoreService")
local crateData = DataStoreService:GetDataStore("CrateData")

local DISABLED_DURATION = 0.1
local SAVE_FREQUENCY = 10.0

-- Get the current value of TotalClicks, or set to 0 if it doesn't exist
local totalClicks = crateData:GetAsync("TotalClicks") or 0

local function onPromptTriggered(prompt, player)
	if prompt.Name == "CratePrompt" then
		prompt.Enabled = false

		local crate = prompt.parent
		local clickDisplay = crate:FindFirstChild("ClickDisplay", true)
		
		totalClicks = totalClicks + 1
		clickDisplay.Text = totalClicks

		wait(DISABLED_DURATION)
		prompt.Enabled = true
	end
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)

-- Update the Data Store every so often
while wait(SAVE_FREQUENCY) do
	crateData:Set Async("TotalClicks", totalClicks)
end

-- To Do: This calls the API too often even when there are not changes.
-- How do we limit the number of calls?
-- Normally, APIs are pay-as-you-go and the more calls you make, the more expensive this is.
