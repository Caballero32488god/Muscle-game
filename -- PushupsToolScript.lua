-- PushupsToolScript.lua

local Tool = script.Parent
local DebounceTime = 1  -- Time in seconds between activations
local BaseMinValue = 1 -- Base minimum value for Strength and Durability
local BaseMaxValue = 35 -- Base maximum value for Strength and Durability
local RequiredStrength = 1000  -- Required Strength to use the tool
local UserDataStore = {}  -- Temporary storage for user click data
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Function to calculate adjusted values for Strength and Durability based on rebirths
local function getAdjustedValues(player)
    local attributes = PlayerAttributes.new(player)
    local rebirths = attributes:GetRebirths() or 0
    
    -- Calculate the percentage increase per rebirth
    local increaseFactor = 0.1  -- 10% increase
    local multiplier = 1 + (rebirths * increaseFactor)
    
    -- Calculate adjusted min and max values
    local minValue = BaseMinValue * (1 + (rebirths * increaseFactor))
    local maxValue = BaseMaxValue * (1 + (rebirths * increaseFactor))
    
    return minValue, maxValue, multiplier
end

-- Function to generate random values for Strength and Durability
local function getRandomValue(minValue, maxValue)
    return math.random(minValue, maxValue)
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

-- Function to give the Pushups tool to the player
local function givePushupsTool(player)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        local existingTool = backpack:FindFirstChild("Pushups")
        if not existingTool then
            local newTool = Tool:Clone()
            newTool.Name = "Pushups"
            newTool.Parent = backpack
        end
    end
end

-- Function to remove the Pushups tool from the player
local function removePushupsTool(player)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild("Pushups")
        if tool then
            tool:Destroy()
        end
    end
end

-- Function to handle the tool activation
local function onActivated()
    local player = game.Players:GetPlayerFromCharacter(Tool.Parent)
    if not player then return end

    -- Check if player has the Pushups tool
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack and backpack:FindFirstChild("Pushups") then
        -- Ensure that the click is not too frequent
        if not UserDataStore[player.UserId] or tick() - UserDataStore[player.UserId] >= DebounceTime then
            -- Retrieve adjusted values based on rebirths
            local minValue, maxValue, multiplier = getAdjustedValues(player)

            -- Generate random values for Strength and Durability
            local strengthValue = getRandomValue(minValue, maxValue)
            local durabilityValue = getRandomValue(minValue, maxValue)

            -- Get the player's leaderstats folder
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                -- Get or create Strength and Durability attributes
                local strength = leaderstats:FindFirstChild("Strength")
                local durability = leaderstats:FindFirstChild("Durability")

                if strength then
                    strength.Value = strength.Value + (strengthValue * multiplier)
                end

                if durability then
                    durability.Value = durability.Value + (durabilityValue * multiplier)
                end

                -- Save player data
                savePlayerData(player)

                -- Update the last click time for the player
                UserDataStore[player.UserId] = tick()
            end
        end
    end
end

-- Function to check player's strength and manage tool visibility
local function manageTool(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local strength = leaderstats:FindFirstChild("Strength")
        if strength then
            if strength.Value >= RequiredStrength then
                givePushupsTool(player)
            else
                removePushupsTool(player)
            end
        end
    end
end

-- Connect the function to PlayerAdded and CharacterAdded events
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        manageTool(player)
    end)
end)

-- Check player's strength every few seconds to manage the tool
game:GetService("RunService").Stepped:Connect(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        manageTool(player)
    end
end)
