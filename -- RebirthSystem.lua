local Players = game:GetService("Players")

-- Cooldown time in seconds
local DebounceTime = 1

-- Table to store the last rebirth time for each player
local lastRebirthTime = {}

-- Function to calculate the rebirth cost
local function getRebirthCost(rebirthCount)
    local baseCost = 10000  -- Initial cost
    local increment = 5000   -- Amount to increase per rebirth
    return baseCost + (rebirthCount * increment)
end

-- Function to calculate the Gem reward
local function getRebirthGemReward(rebirthCount)
    local baseReward = 5000  -- Initial reward
    local increment = 5000   -- Amount to increase per rebirth
    return baseReward + (rebirthCount * increment)
end

-- Function to calculate the strength multiplier
local function getStrengthMultiplier(rebirthCount)
    local baseMultiplier = 1.0  -- Base multiplier (no increase at 0 rebirths)
    local multiplierIncrement = 0.1  -- 10% increase per rebirth
    return baseMultiplier + (rebirthCount * multiplierIncrement)
end

-- Function to handle rebirth
local function onRebirthButtonClicked(player)
    local currentTime = tick()
    local playerId = player.UserId
    
    -- Check if the player is on cooldown
    if lastRebirthTime[playerId] and currentTime - lastRebirthTime[playerId] < DebounceTime then
        return  -- Exit the function if the player is still on cooldown
    end

    -- Update the last rebirth time
    lastRebirthTime[playerId] = currentTime

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        local durability = leaderstats:FindFirstChild("Durability")
        local agility = leaderstats:FindFirstChild("Agility")
        local rebirths = leaderstats:FindFirstChild("Rebirths")
        local gems = leaderstats:FindFirstChild("Gems")
        local strengthMultiplier = leaderstats:FindFirstChild("StrengthMultiplier")

        if strength and durability and agility and rebirths and gems and strengthMultiplier then
            local rebirthCount = rebirths.Value
            local rebirthCost = getRebirthCost(rebirthCount)
            local gemReward = getRebirthGemReward(rebirthCount)
            local multiplier = getStrengthMultiplier(rebirthCount)

            -- Check if the player has enough strength to rebirth
            if strength.Value >= rebirthCost then
                -- Deduct the strength cost
                strength.Value = strength.Value - rebirthCost
                
                -- Increase rebirth count
                rebirths.Value = rebirths.Value + 1
                
                -- Reset stats
                strength.Value = 0
                durability.Value = 0
                
                -- Deduct 50% of Agility
                agility.Value = agility.Value * 0.5
                
                -- Award Gems
                gems.Value = gems.Value + gemReward

                -- Update the strength multiplier
                strengthMultiplier.Value = multiplier

                -- Notify the player
                player:SendNotification({
                    Title = "Rebirth Successful!",
                    Text = "You have rebirthed, received " .. gemReward .. " Gems, and your strength multiplier is now " .. string.format("%.1f", multiplier) .. "x. Your new rebirth cost is " .. getRebirthCost(rebirths.Value) .. " Strength. Your Agility has been reduced by 50%.",
                    Duration = 5
                })
            else
                -- Notify the player they need more strength
                player:SendNotification({
                    Title = "Rebirth Failed",
                    Text = "You need at least " .. rebirthCost .. " Strength to rebirth.",
                    Duration = 5
                })
            end
        end
    end
end

-- Connect to the rebirth button click event
local function onPlayerAdded(player)
    local playerGui = player:WaitForChild("PlayerGui")
    local rebirthButton = playerGui:FindFirstChild("RebirthButton")
    
    if rebirthButton then
        rebirthButton.MouseButton1Click:Connect(function()
            onRebirthButtonClicked(player)
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
