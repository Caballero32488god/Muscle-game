-- RockInteractionScript
local rock = script.Parent
local clickDetector = rock:FindFirstChildOfClass("ClickDetector")

-- Function to handle player hitting the rock
local function onClicked(player)
    -- Ensure the player has a leaderstats folder
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local durability = leaderstats:FindFirstChild("Durability")
        local normalDurabilityGain = leaderstats:FindFirstChild("NormalDurabilityGain")

        if durability and normalDurabilityGain then
            -- Increase durability based on the player's normal gain rate
            local gainAmount = normalDurabilityGain.Value
            durability.Value = durability.Value + gainAmount
        end
    end
end

-- Connect the ClickDetector's MouseClick event to the onClicked function
clickDetector.MouseClick:Connect(onClicked)
