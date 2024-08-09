-- Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Constants
local GROUP_ID = 34532560 -- Replace with your actual group ID
local GAME_PASS_ID = 13600173502 -- Replace with your actual game pass ID
local LUCKY_POTION_DURATION = 600 -- Duration of the lucky potion effect in seconds (10 minutes)
local LUCKY_POTION_EFFECT_MULTIPLIER = 1.50
local LUCKY_POTION_ID = "LuckyPotionItem"

-- DataStores
local playerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Inventory Data
local inventory = {
    items = {}, -- stores item IDs or names
    maxSlots = 100,
    potions = {} -- stores potion IDs or names
}

-- Pets and Auras (for reference)
local pets = {
    {Name = "Cat", Strength = 1, Durability = 0, Probability = 0.25},
    {Name = "Dog", Strength = 0, Durability = 1, Probability = 0.25},
    {Name = "Fluffy", Strength = 2, Durability = 1, Probability = 0.20},
    {Name = "Shadow", Strength = 5, Durability = 2, Probability = 0.15},
    {Name = "Golden Dog", Strength = 4, Durability = 4, Probability = 0.10} -- Rarest pet
}

local auras = {
    {Name = "Powerful Aura", Strength = 2, Durability = 5, Probability = 0.05} -- Rarest aura
}

local playerBoosts = {}

-- Function to check if player is in the group
local function isPlayerInGroup(player)
    local success, result = pcall(function()
        return HttpService:GetAsync("https://api.roblox.com/users/" .. player.UserId .. "/groups")
    end)
    if success then
        local groups = HttpService:JSONDecode(result)
        for _, group in pairs(groups) do
            if group.Id == GROUP_ID then
                return true
            end
        end
    end
    return false
end

-- Function to check if player owns the game pass
local function hasGamePass(player)
    local success, result = pcall(function()
        return MarketplaceService:HasPass(player.UserId, GAME_PASS_ID)
    end)
    return success and result
end

-- Function to assign chat role with color to the player
local function assignChatRole(player)
    if isPlayerInGroup(player) then
        local chatService = require(game:GetService("Chat"))
        if chatService and chatService:SetPlayerTag then
            chatService:SetPlayerTag(player, "<font color=\"#006400\">[Supporter] " .. player.Name .. "</font>")
        else
            warn("Chat service or SetPlayerTag method not found!")
        end
    end
end

-- Function to activate potion effect
local function activatePotion(player)
    if not playerBoosts[player.UserId] then
        playerBoosts[player.UserId] = {
            EndTime = tick() + LUCKY_POTION_DURATION
        }
    else
        -- Extend the duration if already active
        playerBoosts[player.UserId].EndTime = tick() + LUCKY_POTION_DURATION
    end
    
    -- Save potion effect status to DataStore
    local success, errorMessage = pcall(function()
        playerDataStore:SetAsync(tostring(player.UserId), playerBoosts[player.UserId].EndTime)
    end)
    
    if not success then
        warn("Failed to save potion effect data: " .. errorMessage)
    end

    -- Apply the potion effect
    applyPotionEffect(player)
end

-- Function to apply potion effect
local function applyPotionEffect(player)
    local effectEndTime = playerBoosts[player.UserId] and playerBoosts[player.UserId].EndTime
    if effectEndTime and tick() < effectEndTime then
        -- Increase probabilities of all items by the specified multiplier
        for _, pet in ipairs(pets) do
            pet.OriginalProbability = pet.Probability
            pet.Probability = pet.Probability * LUCKY_POTION_EFFECT_MULTIPLIER
        end
        for _, aura in ipairs(auras) do
            aura.OriginalProbability = aura.Probability
            aura.Probability = aura.Probability * LUCKY_POTION_EFFECT_MULTIPLIER
        end
    else
        -- Remove potion effect if expired
        removePotionEffect(player)
    end
end

-- Function to remove potion effect
local function removePotionEffect(player)
    -- Reset probabilities
    for _, pet in ipairs(pets) do
        if pet.OriginalProbability then
            pet.Probability = pet.OriginalProbability
            pet.OriginalProbability = nil
        end
    end
    for _, aura in ipairs(auras) do
        if aura.OriginalProbability then
            aura.Probability = aura.OriginalProbability
            aura.OriginalProbability = nil
        end
    end
    
    -- Clear boost data
    playerBoosts[player.UserId] = nil

    -- Save potion effect status to DataStore
    local success, errorMessage = pcall(function()
        playerDataStore:RemoveAsync(tostring(player.UserId))
    end)
    
    if not success then
        warn("Failed to remove potion effect data: " .. errorMessage)
    end
end

-- Function to handle potion item use
local function usePotionItem(player)
    if inventory.potions[LUCKY_POTION_ID] then
        -- Use the potion
        inventory.potions[LUCKY_POTION_ID] = nil
        activatePotion(player)
    end
end

-- Function to handle player joining
local function onPlayerAdded(player)
    -- Load potion effect status from DataStore
    local success, endTime = pcall(function()
        return playerDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and endTime then
        playerBoosts[player.UserId] = { EndTime = endTime }
    end

    -- Apply potion effect if active
    applyPotionEffect(player)
end

-- Function to connect potion usage to GUI button
local function connectPotionButton(button)
    button.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        usePotionItem(player)
    end)
end

-- Function to connect egg opening to GUI button
local function connectEggButton(button)
    button.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        -- Handle egg opening functionality here if needed
    end)
end

-- Connect player added event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Example GUI button setup
local potionButton = script.Parent:FindFirstChild("UsePotionButton")
if potionButton then
    connectPotionButton(potionButton)
end

-- Note: Egg button connection is omitted as requested
