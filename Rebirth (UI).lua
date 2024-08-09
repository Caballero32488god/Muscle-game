-- Define the Rebirth Button and Frame
local RebirthButton = script.Parent:FindFirstChild("RebirthButton")
local RebirthFrame = script.Parent:FindFirstChild("RebirthFrame")

-- Define base rebirth cost and increment
local BASE_REBIRTH_COST = 10000
local COST_INCREMENT = 5000

-- Define rewards for rebirthing
local REBIRTH_REWARDS = {
    petSlots = 2, -- Extra pet slots
    auraSlots = 2, -- Extra aura slots
    potionSlots = 2, -- Extra potion slots
    strengthBoostIncrement = 0.25 -- Incremental strength boost multiplier per rebirth
}

-- Function to calculate rebirth cost
local function getRebirthCost(rebirths)
    return BASE_REBIRTH_COST + (rebirths - 1) * COST_INCREMENT
end

-- Function to handle the rebirth process
local function handleRebirth(player)
    local rebirths = player.leaderstats.Rebirths.Value
    local rebirthCost = getRebirthCost(rebirths)

    -- Check if the player has enough currency to rebirth
    if player.leaderstats.Currency.Value >= rebirthCost then
        -- Deduct the currency cost
        player.leaderstats.Currency.Value = player.leaderstats.Currency.Value - rebirthCost
        
        -- Reset player stats (implement your own resetting logic here)
        player.leaderstats.Strength.Value = 0
        player.leaderstats.Durability.Value = 0
        player.leaderstats.Agility.Value = 16 -- Set Agility to 16 after rebirthing

        -- Grant rebirth rewards
        player.PetSlots = (player.PetSlots or 0) + REBIRTH_REWARDS.petSlots
        player.AuraSlots = (player.AuraSlots or 0) + REBIRTH_REWARDS.auraSlots
        player.PotionSlots = (player.PotionSlots or 0) + REBIRTH_REWARDS.potionSlots

        -- Calculate and apply the new strength multiplier
        local currentMultiplier = player.StrengthMultiplier or 1
        local newMultiplier = currentMultiplier + REBIRTH_REWARDS.strengthBoostIncrement
        player.StrengthMultiplier = newMultiplier

        -- Increment rebirth count
        player.leaderstats.Rebirths.Value = rebirths + 1

        -- Provide feedback to the player
        print("Rebirth successful! Rewards granted.")
        RebirthFrame.Visible = false -- Hide the rebirth frame
    else
        print("Not enough currency to rebirth. Required: " .. rebirthCost)
    end
end

-- Connect the Rebirth Button to the rebirth function
RebirthButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player then
        handleRebirth(player)
    end
end)

-- Optionally, show the Rebirth Frame with a button
-- You might want to show this frame when certain conditions are met (e.g., player clicks a "Rebirth" button)
