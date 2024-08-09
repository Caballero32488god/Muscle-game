-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Pet DataStore
local petDataStore = DataStoreService:GetDataStore("PetDataStore")

-- Define base stats, growth per level, and evolutions
local baseStats = {
    Cat = {strength = 1, durability = 0},
    Dog = {strength = 1, durability = 1},
    Fluffy = {strength = 2, durability = 1},
    Shadow = {strength = 5, durability = 2},
    GoldenDog = {strength = 4, durability = 4},
    
    MegaCat = {strength = 10, durability = 5},
    UltraDog = {strength = 12, durability = 6},
    GigaFluffy = {strength = 15, durability = 7},
    TitanShadow = {strength = 20, durability = 10},
    OmegaGoldenDog = {strength = 25, durability = 12}
}

local statsPerLevel = {
    strength = 2,
    durability = 1
}

-- Define evolutions
local singleEvolutions = {
    ["Cat"] = "MegaCat",
    ["Dog"] = "UltraDog",
    ["Fluffy"] = "GigaFluffy",
    ["Shadow"] = "TitanShadow",
    ["GoldenDog"] = "OmegaGoldenDog"
}

local doubleEvolutions = {
    ["MegaCat"] = "SuperMegaCat",
    ["UltraDog"] = "SuperUltraDog",
    ["GigaFluffy"] = "SuperGigaFluffy",
    ["TitanShadow"] = "SuperTitanShadow",
    ["OmegaGoldenDog"] = "SuperOmegaGoldenDog"
}

-- Initialize pets data
local petsData = {
    ["Cat"] = {level = 1, experience = 0},
    ["Dog"] = {level = 1, experience = 0},
    ["Fluffy"] = {level = 1, experience = 0},
    ["Shadow"] = {level = 1, experience = 0},
    ["GoldenDog"] = {level = 1, experience = 0},
    ["MegaCat"] = {level = 1, experience = 0},
    ["UltraDog"] = {level = 1, experience = 0},
    ["GigaFluffy"] = {level = 1, experience = 0},
    ["TitanShadow"] = {level = 1, experience = 0},
    ["OmegaGoldenDog"] = {level = 1, experience = 0},
    ["SuperMegaCat"] = {level = 1, experience = 0},
    ["SuperUltraDog"] = {level = 1, experience = 0},
    ["SuperGigaFluffy"] = {level = 1, experience = 0},
    ["SuperTitanShadow"] = {level = 1, experience = 0},
    ["SuperOmegaGoldenDog"] = {level = 1, experience = 0}
}

-- Function to calculate experience required for next level
local function experienceForLevel(level)
    return level * 100 -- Example: 100 XP per level
end

-- Function to level up a pet
local function levelUpPet(petName)
    local pet = petsData[petName]
    if pet then
        local requiredXP = experienceForLevel(pet.level)
        while pet.experience >= requiredXP do
            pet.experience = pet.experience - requiredXP
            pet.level = pet.level + 1
            print(petName .. " leveled up to level " .. pet.level)
            requiredXP = experienceForLevel(pet.level)
        end
    end
end

-- Function to add experience to a pet
local function addExperience(petName, amount)
    local pet = petsData[petName]
    if pet then
        pet.experience = pet.experience + amount
        print(petName .. " gained " .. amount .. " XP")
        levelUpPet(petName)
    end
end

-- Function to evolve a pet
local function evolvePet(petName)
    local evolvedPetName = singleEvolutions[petName]
    if evolvedPetName then
        local pet = petsData[petName]
        if pet then
            local evolvedPet = petsData[evolvedPetName]
            if evolvedPet then
                evolvedPet.level = math.max(evolvedPet.level, pet.level)
                evolvedPet.experience = pet.experience
                petsData[petName] = nil
                print(petName .. " evolved into " .. evolvedPetName)
            end
        end
    end
end

-- Function to double-evolve a pet
local function doubleEvolvePet(petName)
    local evolvedPetName = doubleEvolutions[petName]
    if evolvedPetName then
        local pet = petsData[petName]
        if pet then
            local evolvedPet = petsData[evolvedPetName]
            if evolvedPet then
                evolvedPet.level = math.max(evolvedPet.level, pet.level)
                evolvedPet.experience = pet.experience
                petsData[petName] = nil
                print(petName .. " double-evolved into " .. evolvedPetName)
            end
        end
    end
end

-- Function to get pet stats based on level
local function getPetStats(petName)
    local pet = petsData[petName]
    if pet then
        local baseStat = baseStats[petName]
        local level = pet.level
        local stats = {
            strength = baseStat.strength + (level - 1) * statsPerLevel.strength,
            durability = baseStat.durability + (level - 1) * statsPerLevel.durability
        }
        return stats
    end
    return {strength = 0, durability = 0}
end

-- Save pet data
local function savePetData(player, petName)
    local pet = petsData[petName]
    if pet then
        local success, errorMessage = pcall(function()
            petDataStore:SetAsync(player.UserId .. "_" .. petName, pet)
        end)
        if not success then
            warn("Failed to save pet data: " .. errorMessage)
        end
    end
end

-- Load pet data
local function loadPetData(player, petName)
    local success, data = pcall(function()
        return petDataStore:GetAsync(player.UserId .. "_" .. petName)
    end)
    if success and data then
        petsData[petName] = data
    end
end

-- Example Integration: Connect lifting weights and hitting rocks
-- Replace with actual game object references

-- Example for lifting weights
game.Workspace.WeightLiftingPart.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        local petName = "Cat" -- Example pet name, should be dynamic based on player's pet
        addExperience(petName, 10) -- Example XP reward for lifting weights
    end
end)

-- Example for hitting rocks
game.Workspace.RockHittingPart.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        local petName = "Dog" -- Example pet name, should be dynamic based on player's pet
        addExperience(petName, 5) -- Example XP reward for hitting rocks
    end
end)

-- Load pet data when player joins
Players.PlayerAdded:Connect(function(player)
    for petName, _ in pairs(petsData) do
        loadPetData(player, petName)
    end
end)

-- Save pet data when player leaves
Players.PlayerRemoving:Connect(function(player)
    for petName, _ in pairs(petsData) do
        savePetData(player, petName)
    end
end)

-- Example commands to evolve and double-evolve pets (for testing)
local function evolveAndDoubleEvolveExamplePets()
    evolvePet("Cat")
    doubleEvolvePet("MegaCat")
end

evolveAndDoubleEvolveExamplePets() -- Call this function to evolve and double-evolve example pets
