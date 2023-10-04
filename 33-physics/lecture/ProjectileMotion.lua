-- ServerScriptService > Create Script > Name "ProjectileMotion"
while true do
	task.wait(5)

	local position1 = workspace.From.Position
	local position2 = workspace.To.Position

	local displacement = position2 - position1
	local duration = math.log(1.001 + displacement.Magnitude * 0.01)
	
	position2 = workspace.To.Position + workspace.To.AssemblyLinearVelocity * duration
	displacement = position2 - position1

	local force = displacement / duration + Vector3.new(0, game.Workspace.Gravity * duration * 0.5, 0)

	local clone = game.ServerStorage.Projectile:Clone()
	clone.Position = position1
	clone.Parent = workspace
	clone:ApplyImpulse(force * clone.AssemblyMass)
	clone:SetNetworkOwner(nil)
end
