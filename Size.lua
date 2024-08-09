-- GrowthScript.lua
local Players = game:GetService("Players")

-- Maximum scale factor to prevent excessive growth
local maxScaleFactor = 500  -- The maximum multiplier for size growth

-- Function to scale the player based on strength
local function scalePlayer(player)
    local character = player.Character
    local leaderstats = player:FindFirstChild("leaderstats")
    
    if character and leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        if strength then
            -- Calculate the scaling factor with 0.10 growth per 10 strength
            local growthPer10Strength = 0.10
            local scaleFactor = 1 + (strength.Value / 10 * growthPer10Strength)
            -- Cap the scale factor to the maximum allowed value
            scaleFactor = math.min(scaleFactor, maxScaleFactor)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                -- Apply the scaling to the player's Humanoid properties
                humanoid.BodyWidthScale.Value = scaleFactor
                humanoid.BodyHeightScale.Value = scaleFactor
                humanoid.BodyDepthScale.Value = scaleFactor
            end
        end
    end
end

-- Function to update player size whenever their strength changes
local function onPlayerAdded(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        if strength then
            strength.Changed:Connect(function()
                scalePlayer(player)
            end)
        end
    end

    -- Scale player when they first join
    scalePlayer(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
