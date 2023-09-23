-- Give a player super powers by making them go fast when they touch a speed booster! A Humanoid’s default WalkSpeed property is set to 16. Not so bad, but it’d be a lot cooler to go a lot faster. Make a part that temporarily allows a user to go way faster and then returns them to their original speed after a few seconds. 

-- To do so, you can use the onTouch pattern you’ve been working with and some if/then statements. As an added twist, use a ParticleEmitter object to stream sparkles behind them while they’re powered up.

-- Tips
-- ParticleEmitters can be stored in ServerStorage
-- Get ServerStorage using GetService()
-- Use if/then to check for a Humanoid
-- Change the Humanoid's WalkSpeed property from the default value of 16 to 50.
-- Use the method Clone() to make a copu of the particle and then parent it to the runner.
-- After a few seconds, reset WalkSpeed to 16, and destroy the ParticleEmitter.
