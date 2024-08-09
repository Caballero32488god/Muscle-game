-- FistToolScript.lua

local Tool = script.Parent
local DebounceTime = 1  -- Time in seconds between clicks
local MinDamage = 1     -- Minimum amount of damage
local MaxDamage = 22    -- Maximum amount of damage
local UserDataStore = {}  -- Temporary storage for user click data
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Function to generate a random damage amount
local function getRandomDamage()
    return math.random(MinDamage, MaxDamage)
end

-- Function to save player data
local function savePlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        local durability = leaderstats:FindFirstChild("Durability")
        local data = {
            Strength = strength and strength.Value or 0,
            Durability = durability and durability.Value or 0
        }
        local success, errorMessage = pcall(function()
            playerDataStore:SetAsync(tostring(player.UserId), data)
        end)
        if not success then
            warn("Failed to save data for player " .. player.Name .. ": " .. errorMessage)
        end
    end
end

-- Function to handle the tool activation
local function onActivated()
    local player = game.Players:GetPlayerFromCharacter(Tool.Parent)
    if not player then return end

    -- Ensure that the click is not too frequent
    if not UserDataStore[player.UserId] or tick() - UserDataStore[player.UserId] >= DebounceTime then
        -- Get the player's character and humanoid
        local character = player.Character
        if not character then return end

        -- Check if the tool hit any other player
        local mouse = player:GetMouse()
        local target = mouse.Target
        local targetCharacter = target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") and target.Parent
        
        if targetCharacter and targetCharacter ~= character then
            -- Apply random damage to the target player's durability (health)
            local targetPlayer = game.Players:GetPlayerFromCharacter(targetCharacter.Parent)
            if targetPlayer then
                local leaderstats = targetPlayer:FindFirstChild("leaderstats")
                if leaderstats then
                    local durability = leaderstats:FindFirstChild("Durability")
                    if durability then
                        -- Get a random damage amount
                        local damageAmount = getRandomDamage()

                        -- Reduce the target's durability by the random damage amount
                        durability.Value = durability.Value - damageAmount

                        -- Optional: Check if the target's durability has dropped below 0 and handle death
                        if durability.Value <= 0 then
                            durability.Value = 0
                            -- Handle player death (e.g., respawn or game over)
                            local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                            if targetHumanoid then
                                targetHumanoid.Health = 0  -- Set Humanoid health to 0 to trigger death
                            end
                        end

                        -- Save the target player's data after taking damage
                        savePlayerData(targetPlayer)
                    end
                end
            end
        end

        -- Update the last click time for the player
        UserDataStore[player.UserId] = tick()
    end
end

-- Connect the onActivated function to the tool's Activated event
Tool.Activated:Connect(onActivated)
