-- WeightToolScript.lua

local Tool = script.Parent
local DebounceTime = 2  -- Time in seconds between clicks
local BaseStrengthMin = 1  -- Base minimum amount of strength gained per click
local BaseStrengthMax = 22 -- Base maximum amount of strength gained per click
local UserDataStore = {}  -- Temporary storage for user strength data
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Function to handle clicking the tool
local function onActivated()
    local player = game.Players:GetPlayerFromCharacter(Tool.Parent)
    if not player then return end
    
    -- Ensure the player has a PlayerAttributes object (replace with your actual attributes method)
    local attributes = PlayerAttributes.new(player)
    
    -- Check if the user can click based on debounce
    if not UserDataStore[player.UserId] or tick() - UserDataStore[player.UserId] >= DebounceTime then
        -- Retrieve the strength multiplier and rebirths
        local rebirths = attributes:GetRebirths() or 0
        local strengthMultiplier = 1 + (rebirths * 0.1)  -- Increase by 10% per rebirth

        -- Calculate adjusted StrengthMin and StrengthMax with multiplier
        local adjustedStrengthMin = BaseStrengthMin * (1 + (rebirths * 0.1))
        local adjustedStrengthMax = BaseStrengthMax * (1 + (rebirths * 0.1))
        
        -- Calculate a random strength increment between adjusted StrengthMin and adjusted StrengthMax
        local strengthIncrement = math.random(adjustedStrengthMin, adjustedStrengthMax)
        
        -- Apply the strength increment with the multiplier
        local adjustedStrengthIncrement = strengthIncrement * strengthMultiplier
        attributes:EarnStrength(adjustedStrengthIncrement)
        
        -- Update the last click time for the player
        UserDataStore[player.UserId] = tick()
        
        -- Optional: Provide feedback to the player
        print(player.Name .. " has gained " .. adjustedStrengthIncrement .. " strength. Total strength: " .. attributes:GetStrength())
    end
end

-- Function to save player data
local function savePlayerData(player)
    local attributes = PlayerAttributes.new(player)
    local success, errorMessage = pcall(function()
        PlayerDataStore:SetAsync(tostring(player.UserId), {
            Strength = attributes:GetStrength(),
            Rebirths = attributes:GetRebirths()
        })
    end)
    if not success then
        warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
    end
end

-- Function to load player data
local function loadPlayerData(player)
    local attributes = PlayerAttributes.new(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(tostring(player.UserId))
    end)
    if success then
        if data then
            attributes:SetStrength(data.Strength or 0)
            attributes:SetRebirths(data.Rebirths or 0)
        else
            attributes:SetStrength(0) -- Default strength if no data exists
            attributes:SetRebirths(0) -- Default rebirths if no data exists
        end
    else
        warn("Failed to load data for " .. player.Name)
        attributes:SetStrength(0) -- Default strength if there is an error
        attributes:SetRebirths(0) -- Default rebirths if there is an error
    end
end

-- Connect the onActivated function to the tool's Activated event
Tool.Activated:Connect(onActivated)

-- Connect to PlayerAdded and PlayerRemoving events to handle data
game.Players.PlayerAdded:Connect(loadPlayerData)
game.Players.PlayerRemoving:Connect(savePlayerData)
