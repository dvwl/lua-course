-- ServerScriptService > Create Script > Name "LinearMotion"
-- Creates a new instance of a ball and moves it
-- Create a sphere programatically
local mySphere = Instance.new("Part")
mySphere.Shape = Enum.PartType.Ball
mySphere.Size = Vector3.new(4,4,4)
mySphere.Position = Vector3.new(18, 2, 4)
mySphere.Parent = game.Workspace

-- Define initial variables
local initialPosition = mySphere.Position -- Initial position
local initialVelocity = Vector3.new(2, 0, 0) -- Initial velocity (horizontal components)

local time = 0 -- Initial time
local timeStep = 0.1 -- Time step for simulation

-- Create a TweenInfo object for the rotation animation
local tweenInfo = TweenInfo.new(
	2,               -- Duration (in seconds)
	Enum.EasingStyle.Linear, -- Easing style
	Enum.EasingDirection.In, -- Easing direction
	-1,              -- Number of repetitions
	false,           -- Reverses the animation between repetitions
	0                -- Delay before starting
)

-- Create a new Tween for the sphere's rotation
local rotationTween = game:GetService("TweenService"):Create(mySphere, tweenInfo, {
	Rotation = Vector3.new(0, 0, -360)  -- Rotate 360 degrees around the z-axis
})

-- Start the rotation animation
rotationTween:Play()

-- Update the object's position over time
while true do
	local horizontalXDisplacement = initialVelocity.x * time
	local newPosition = initialPosition + Vector3.new(horizontalXDisplacement, 0, 0)

	mySphere.Position = newPosition
	
	time = time + timeStep
	wait(timeStep)
end
