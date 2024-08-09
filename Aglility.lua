-- PlayerMovementScript.lua

local Players = game:GetService("Players")

-- Define constants
local BASE_SPEED = 16  -- Default base speed
local SPEED_LIMIT = 500  -- Maximum speed limit

-- Function to update player speed based on Agility
local function updateSpeed(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local agility = leaderstats:FindFirstChild("Agility")
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if agility and humanoid then
            -- Calculate new speed based on Agility
            local newSpeed = BASE_SPEED + (agility.Value - BASE_SPEED)
            
            -- Ensure speed does not exceed the limit
            humanoid.WalkSpeed = math.min(newSpeed, SPEED_LIMIT)
        end
    end
end

-- Connect to the player's Agility change
local function onPlayerAdded(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local agility = leaderstats:FindFirstChild("Agility")
        if agility then
            agility.Changed:Connect(function()
                updateSpeed(player)
            end)
        end
    end
    
    -- Update speed when the player first joins
    updateSpeed(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
