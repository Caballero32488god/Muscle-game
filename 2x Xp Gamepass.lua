local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local DOUBLE_XP_GAMEPASS_ID = 18870901007 -- Replace with your actual Gamepass ID
local XP_BOOST_MULTIPLIER = 2 -- Double XP

-- Function to check if player owns the gamepass
local function hasDoubleXP(player)
    local success, hasGamePass = pcall(function()
        return player:HasPass(DOUBLE_XP_GAMEPASS_ID)
    end)
    return success and hasGamePass
end

-- Function to apply XP boost
local function applyXPBoost(player, baseXP)
    if hasDoubleXP(player) then
        return baseXP * XP_BOOST_MULTIPLIER
    else
        return baseXP
    end
end

-- Function to give XP to a pet
local function givePetXP(pet, xpAmount)
    local player = Players:GetPlayerFromCharacter(pet.Parent)
    if player then
        local boostedXP = applyXPBoost(player, xpAmount)
        -- Assuming pets have a `XP` property or similar
        pet.XP = pet.XP + boostedXP
    end
end

-- Example function for task completion
local function onPetCompleteTask(pet)
    local baseXP = 30 -- Replace with your base XP amount
    givePetXP(pet, baseXP)
end

-- Connect to relevant event (example: task completion)
-- game.ReplicatedStorage.TaskCompletedEvent.OnServerEvent:Connect(onPetCompleteTask)
