-- ClickCrate Part > Create "Scripts" > Name "CrateScript"
local DataStoreService = game:GetService("DataStoreService")
local crateData = DataStoreService:GetDataStore("CrateData")

local crate = script.Parent
local clickDisplay = crate:FindFirstChild("ClickDisplay", true)

local DEFAULT_VALUE = 0
local totalClicks = crateData:GetAsync("TotalClicks")

lickDisplay.Text = totalClicks or DEFAULT_VALUE
