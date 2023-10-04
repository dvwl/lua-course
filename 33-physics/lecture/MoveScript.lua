-- "To" part > Create Script > Name "MoveScript"
local part = script.Parent
local alignPosition = part.AlignPosition

part:SetNetworkOwner(nil)

while true do
	task.wait(15)
	alignPosition.Position = Vector3.new(200, 8, 34)  -- you may need to update with your positions
	task.wait(15)
	alignPosition.Position = Vector3.new(37, 8, 34)
end
