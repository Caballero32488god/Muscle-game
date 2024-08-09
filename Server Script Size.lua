-- ServerScriptService/PlayerSettingsManager.lua
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerSettingsDataStore")

-- Default values
local defaultSize = 1
local defaultAgility = 16

-- Save player settings
local function savePlayerSettings(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local size = humanoid and humanoid.BodyScale and humanoid.BodyScale.Value or defaultSize
    local agility = humanoid and humanoid:FindFirstChild("Agility") or defaultAgility
    
    local data = {
        Size = size,
        Agility = agility
    }
    
    local success, errorMessage = pcall(function()
        playerDataStore:SetAsync(tostring(player.UserId), data)
    end)
    
    if not success then
        warn("Failed to save settings for player " .. player.Name .. ": " .. errorMessage)
    end
end

-- Load player settings
local function loadPlayerSettings(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    local success, data = pcall(function()
        return playerDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and data then
        if humanoid then
            humanoid.BodyScale.Value = data.Size or defaultSize
            humanoid:FindFirstChild("Agility").Value = data.Agility or defaultAgility
        end
    else
        -- Apply default settings
        if humanoid then
            humanoid.BodyScale.Value = defaultSize
            humanoid:FindFirstChild("Agility").Value = defaultAgility
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    loadPlayerSettings(player)
    player.CharacterAdded:Connect(function()
        loadPlayerSettings(player)
    end)
end)

Players.PlayerRemoving:Connect(savePlayerSettings)
