-- Example integration

local player = game.Players.LocalPlayer

-- Determine pet strength
local petName = "Cat" -- Example pet name
local petStrength = getPetStrength(petName, player)
print(petName .. " Strength: " .. petStrength)

-- Determine strength from lifting weights
local baseStrengthFromLifting = 10 -- Example base strength value
local totalStrengthFromLifting = getLiftingStrength(player, baseStrengthFromLifting)
print("Total Strength from Lifting Weights: " .. totalStrengthFromLifting)

-- Determine strength from pull-ups
local baseStrengthFromPullUps = 5 -- Example base strength value
local totalStrengthFromPullUps = getPullUpsStrength(player, baseStrengthFromPullUps)
print("Total Strength from Pull-Ups: " .. totalStrengthFromPullUps)

-- Determine strength from push-ups
local baseStrengthFromPushUps = 7 -- Example base strength value
local totalStrengthFromPushUps = getPushUpsStrength(player, baseStrengthFromPushUps)
print("Total Strength from Push-Ups: " .. totalStrengthFromPushUps)
