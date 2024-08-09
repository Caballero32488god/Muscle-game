-- Define the XP required for each level (example: linear growth)
local xpTable = {}
for level = 1, 250 do
    xpTable[level] = level * 100 -- Example: adjust as needed
end

-- Define base stats and how they increase with levels
local baseStats = {
    strength = 500,
    durability = 500,
    agility = 500
}

local function getPetStats(level)
    local growthFactor = 1.5 -- Stats increase factor per level
    local stats = {}
    for stat, base in pairs(baseStats) do
        stats[stat] = base + (level - 1) * growthFactor
    end
    return stats
end

-- Define pet evolution data
local petEvolutionData = {
    BasePet = {
        EvolvedPet = {
            Name = "EvolvedPetName",
            Stats = { strength = 1000, durability = 1000, agility = 1000 }
        }
    },
    EvolvedPet = {
        DoubleEvolvedPet = {
            Name = "DoubleEvolvedPetName",
            Stats = { strength = 1500, durability = 1500, agility = 1500 }
        }
    }
}

-- Track pet XP and levels
local playerPetData = {}
local playerPetEvolutionState = {}

-- Function to add XP to a pet
function addPetXP(player, petName, xp)
    local petData = playerPetData[player.UserId] or {}
    local pet = petData[petName] or { level = 1, xp = 0 }
    
    pet.xp = pet.xp + xp
    local requiredXP = xpTable[pet.level] or 0
    
    while pet.xp >= requiredXP and pet.level < 250 do
        pet.xp = pet.xp - requiredXP
        pet.level = pet.level + 1
        requiredXP = xpTable[pet.level] or 0
    end
    
    playerPetData[player.UserId] = petData
    print(player.Name .. "'s " .. petName .. " is now level " .. pet.level)
end

-- Function to check if a pet can evolve
function canEvolvePet(player, petName)
    local petData = playerPetData[player.UserId] or {}
    local pet = petData[petName] or { level = 1 }
    
    -- Check if the pet has reached level 25
    return pet.level >= 25
end

-- Function to evolve a pet
function evolvePet(player, petName)
    if canEvolvePet(player, petName) then
        local petData = petEvolutionData.BasePet
        local evolvedPet = petData.EvolvedPet
        local petStats = getPetStats(playerPetData[player.UserId][petName].level)
        addItemToInventory(player, evolvedPet.Name, petStats)
        removeItemFromInventory(player, petName)
        print("Pet evolved to: " .. evolvedPet.Name)
        
        -- Update evolution state
        local pets = playerPetEvolutionState[player.UserId] or {}
        pets[petName] = "EvolvedPet"
        playerPetEvolutionState[player.UserId] = pets
    else
        print("Pet cannot be evolved. It must be at least level 25.")
    end
end

-- Function to evolve a pet again (second evolution)
function evolvePetTwice(player, petName)
    if canEvolvePet(player, petName) then
        local evolvedPet = petEvolutionData.BasePet.EvolvedPet
        local doubleEvolvedPet = petEvolutionData.EvolvedPet.DoubleEvolvedPet
        local petStats = getPetStats(playerPetData[player.UserId][petName].level)
        addItemToInventory(player, doubleEvolvedPet.Name, petStats)
        removeItemFromInventory(player, petName)
        print("Pet double evolved to: " .. doubleEvolvedPet.Name)
        
        -- Update evolution state
        local pets = playerPetEvolutionState[player.UserId] or {}
        pets[petName] = "DoubleEvolvedPet"
        playerPetEvolutionState[player.UserId] = pets
    else
        print("Pet cannot be double evolved. It must be at least level 25.")
    end
end

-- Handle premium user rewards
local premiumGroupId = 34532560
local function grantPremiumRewards(player)
    if player.MembershipType == Enum.MembershipType.Premium then
        local petStats = { strength = 500, durability = 500, agility = 500 }
        addItemToInventory(player, "Special Premium PET", petStats)
        addItemToAuraInventory(player, "Special Premium AURA", petStats)
        player.PremiumPetSlots = (player.PremiumPetSlots or 0) + 2
        player.ExtraInventorySpace = (player.ExtraInventorySpace or 0) + 500
        player.ExperienceMultiplier = 3 -- 3x Increased Experience
        print(player.Name .. " has been granted premium rewards!")
    end
end

-- Check if player is in a group
local function isInGroup(player)
    return player:IsInGroup(premiumGroupId)
end

-- Function to use a potion
local function usePotion(player, potionName)
    if potionName == "Lucky Potion 1" then
        player.PotionBoost = { luck = 1.5, duration = 10 * 60 } -- 10 minutes
        print(player.Name .. " used Lucky Potion 1!")
    end
end

-- Function to handle pet actions (e.g., lifting weights, hitting rocks)
local function handlePetAction(player, petName, action)
    if action == "lifting" or action == "rockHit" then
        local xpGain = 10 -- Example XP gain
        if player.PotionBoost and player.PotionBoost.luck then
            xpGain = xpGain * player.PotionBoost.luck
        end
        addPetXP(player, petName, xpGain)
    end
end

-- Connect evolution and action buttons
game.Workspace.EvolutionButton.Click:Connect(function(player, petName)
    evolvePet(player, petName)
end)

game.Workspace.DoubleEvolutionButton.Click:Connect(function(player, petName)
    evolvePetTwice(player, petName)
end)

game.Workspace.LiftWeightButton.Click:Connect(function(player, petName)
    handlePetAction(player, petName, "lifting")
end)

game.Workspace.HitRockButton.Click:Connect(function(player, petName)
    handlePetAction(player, petName, "rockHit")
end)

-- Handle player joining
game.Players.PlayerAdded:Connect(function(player)
    grantPremiumRewards(player)
end)

-- Example function for using potions
game.Workspace.UsePotionButton.Click:Connect(function(player, potionName)
    usePotion(player, potionName)
end)
