-- This section talks about physics
-- We'll explore motion

-- Setting up the demo for projectile motion
-- 1. Create the Parts
	-- Workspace
		-- From
		-- To
	-- ServerStorage
		-- Projectile (I'm using "Bullet Smoke Trail by WaddelsG")
			-- Attachment
			-- Attachment
			-- BulletSmoke
-- 2. Both From and To are set Transparent 0.8, CanCollide = false, CanTouch = false, CanQuery = false, Anchored = true
-- 3. Set Projectile's Anchored = false
-- 4. Create a script inside ServerScriptService that clones the Projectile and place it on the From part

-- Setting up the demo for projectile motion (part 2)
-- 1. Modify the "To" Part, anchored = false, an Attachment, and add an AlignPosition with OneAttachment mode, position using To's position, max velocity to 15 and Attachment0 to Attachment.
	-- To
		-- AlignPosition
		-- Attachment
		-- MoveScript
-- 2. Refer to MoveScript.lua
