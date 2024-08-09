-- AbbreviateNumber.lua

-- Function to abbreviate large numbers
local function abbreviateNumber(value)
    if value >= 1_000_000_000_000_000_000 then
        return string.format("%.1fN", value / 1_000_000_000_000_000_000) -- Nonillions
    elseif value >= 1_000_000_000_000_000 then
        return string.format("%.1fO", value / 1_000_000_000_000_000) -- Octillions
    elseif value >= 1_000_000_000_000 then
        return string.format("%.1fSp", value / 1_000_000_000_000) -- Septillions
    elseif value >= 1_000_000_000_000 then
        return string.format("%.1fSx", value / 1_000_000_000_000) -- Sextillions
    elseif value >= 1_000_000_000_000 then
        return string.format("%.1fQi", value / 1_000_000_000_000) -- Quintillions
    elseif value >= 1_000_000_000 then
        return string.format("%.1fT", value / 1_000_000_000) -- Trillions
    elseif value >= 1_000_000 then
        return string.format("%.1fB", value / 1_000_000) -- Billions
    elseif value >= 1_000 then
        return string.format("%.1fM", value / 1_000) -- Millions
    else
        return tostring(value)
    end
end

-- Function to update the UI with abbreviated Strength, Durability, and Rebirths
local function updateUI(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        local durability = leaderstats:FindFirstChild("Durability")
        local rebirths = leaderstats:FindFirstChild("Rebirths")
        
        if strength and durability and rebirths then
            local strengthValue = strength.Value
            local durabilityValue = durability.Value
            local rebirthsValue = rebirths.Value
            local abbreviatedStrength = abbreviateNumber(strengthValue)
            local abbreviatedDurability = abbreviateNumber(durabilityValue)
            local abbreviatedRebirths = abbreviateNumber(rebirthsValue)
            
            -- Find the UI elements to update (adjust the paths to your specific UI elements)
            local strengthLabel = player.PlayerGui:FindFirstChild("StrengthLabel")
            local durabilityLabel = player.PlayerGui:FindFirstChild("DurabilityLabel")
            local rebirthsLabel = player.PlayerGui:FindFirstChild("RebirthsLabel")
            
            if strengthLabel then
                strengthLabel.Text = "Strength: " .. abbreviatedStrength
            end
            
            if durabilityLabel then
                durabilityLabel.Text = "Durability: " .. abbreviatedDurability
            end
            
            if rebirthsLabel then
                rebirthsLabel.Text = "Rebirths: " .. abbreviatedRebirths
            end
        end
    end
end

-- Connect the update function to the player's CharacterAdded event
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updateUI(player)
    end)
end)

-- Optionally, you might also want to update the UI when the player's stats change.
game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        local durability = leaderstats:FindFirstChild("Durability")
        local rebirths = leaderstats:FindFirstChild("Rebirths")
        
        if strength then
            strength.Changed:Connect(function()
                updateUI(player)
            end)
        end
        if durability then
            durability.Changed:Connect(function()
                updateUI(player)
            end)
        end
        if rebirths then
            rebirths.Changed:Connect(function()
                updateUI(player)
            end)
        end
    end
end)
