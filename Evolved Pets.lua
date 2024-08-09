-- Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- DataStores
local playerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Inventory Data
local inventory = {
    items = {}, -- stores item IDs or names
    maxSlots = 100,
    pets = {}, -- stores pet IDs or names
    potions = {} -- stores potion IDs or names
}

-- Pets Definition
local pets = {
    {Name = "Cat", Strength = 1, Durability = 0, Probability = 0.25},
    {Name = "Dog", Strength = 0, Durability = 1, Probability = 0.25},
    {Name = "Fluffy", Strength = 2, Durability = 1, Probability = 0.20},
    {Name = "Shadow", Strength = 5, Durability = 2, Probability = 0.15},
    {Name = "Golden Dog", Strength = 4, Durability = 4, Probability = 0.10}
}

-- Evolved Pet Definitions (First Evolution)
local firstEvolutionPets = {
    {Name = "Ultimate Cat", Strength = 10, Durability = 5},
    {Name = "Mythical Dog", Strength = 8, Durability = 7},
    {Name = "Supreme Fluffy", Strength = 6, Durability = 6},
    {Name = "Shadow Lord", Strength = 12, Durability = 8},
    {Name = "Golden Titan", Strength = 14, Durability = 10}
}

-- Evolved Pet Definitions (Second Evolution)
local secondEvolutionPets = {
    {Name = "Legendary Cat", Strength = 20, Durability = 10},
    {Name = "Celestial Dog", Strength = 16, Durability = 14},
    {Name = "Mythic Fluffy", Strength = 12, Durability = 12},
    {Name = "Eclipse Shadow", Strength = 25, Durability = 16},
    {Name = "Mania Golden Dog", Strength = 30, Durability = 20}
}

-- Potions
local potions = {
    LuckyPotion1 = {
        EffectMultiplier = 1.50,
        Duration = 600 -- 10 minutes
    }
}

local playerBoosts = {}

-- Function to get a random pet based on probabilities
local function getRandomPet()
    local rand = math.random()
    local cumulativeProbability = 0

    for _, pet in ipairs(pets) do
        cumulativeProbability = cumulativeProbability + pet.Probability
        if rand <= cumulativeProbability then
            return pet
        end
    end
end

-- Function to add a pet to inventory
local function addPetToInventory(player, petName)
    if #inventory.pets < inventory.maxSlots then
        table.insert(inventory.pets, petName)
        print("Pet added: " .. petName)
    else
        print("Inventory full!")
    end
end

-- Function to remove a pet from inventory
local function removePetFromInventory(petName)
    for i, pet in ipairs(inventory.pets) do
        if pet == petName then
            table.remove(inventory.pets, i)
            print("Pet removed: " .. petName)
            return
        end
    end
    print("Pet not found!")
end

-- Function to evolve pets
local function evolvePets(player, petNames, evolutionStage)
    if #petNames ~= 5 then
        return "You need exactly 5 pets to evolve."
    end

    -- Check if the player has these pets
    for _, petName in ipairs(petNames) do
        local found = false
        for _, inventoryPet in ipairs(inventory.pets) do
            if inventoryPet == petName then
                found = true
                break
            end
        end
        if not found then
            return "One or more pets are not in your inventory."
        end
    end

    -- Remove the pets from inventory
    for _, petName in ipairs(petNames) do
        removePetFromInventory(petName)
    end

    -- Add the evolved pet
    local evolvedPet
    if evolutionStage == 1 then
        evolvedPet = firstEvolutionPets[math.random(#firstEvolutionPets)]
    elseif evolutionStage == 2 then
        evolvedPet = secondEvolutionPets[math.random(#secondEvolutionPets)]
    else
        return "Invalid evolution stage."
    end

    addPetToInventory(player, evolvedPet.Name)
    
    return "Congratulations! You've evolved into " .. evolvedPet.Name
end

-- Function to activate potion effect
local function activatePotion(player, potionID)
    local potion = potions[potionID]
    if potion then
        playerBoosts[player.UserId] = {
            EndTime = tick() + potion.Duration,
            Multiplier = potion.EffectMultiplier
        }
        
        -- Apply the potion effect
        applyPotionEffect(player)
    end
end

-- Function to apply potion effect
local function applyPotionEffect(player)
    local boost = playerBoosts[player.UserId]
    if boost and tick() < boost.EndTime then
        -- Increase probabilities of all items by the specified multiplier
        for _, pet in ipairs(pets) do
            pet.OriginalProbability = pet.Probability
            pet.Probability = pet.Probability * boost.Multiplier
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
    
    -- Clear boost data
    playerBoosts[player.UserId] = nil
end

-- Function to handle egg opening
local function openEgg(player)
    local pet = getRandomPet()
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
    end
end

-- Function to handle potion item use
local function usePotionItem(player, potionID)
    if inventory.potions[potionID] then
        -- Use the potion
        inventory.potions[potionID] = nil
        activatePotion(player, potionID)
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

-- Function to handle evolution GUI buttons
local function connectEvolutionButtons()
    local firstEvolveButton = script.Parent:FindFirstChild("FirstEvolveButton")
    if firstEvolveButton then
        firstEvolveButton.MouseButton1Click:Connect(function()
            local player = Players.LocalPlayer
            local selectedPets = {} -- Get selected pets from the GUI
            selectedPets = {"Cat", "Dog", "Fluffy", "Shadow", "Golden Dog"} -- Example

            local result = evolvePets(player, selectedPets, 1)
            print(result)
            -- Update GUI with result message
        end)
    end

    local secondEvolveButton = script.Parent:FindFirstChild("SecondEvolveButton")
    if secondEvolveButton then
        secondEvolveButton.MouseButton1Click:Connect(function()
            local player = Players.LocalPlayer
            local selectedPets = {} -- Get selected pets from the GUI
            selectedPets = {"Ultimate Cat", "Mythical Dog", "Supreme Fluffy", "Shadow Lord", "Golden Titan"} -- Example

            local result = evolvePets(player, selectedPets, 2)
            print(result)
            -- Update GUI with result message
        end)
    end
end

-- Function to handle potion GUI button
local function connectPotionButton()
    local potionButton = script.Parent:FindFirstChild("UsePotionButton")
    if potionButton then
        potionButton.MouseButton1Click:Connect(function()
            local player = Players.LocalPlayer
            local potionID = "LuckyPotion1" -- Example potion ID
            usePotionItem(player, potionID)
        end)
    end
end

-- Function to handle egg GUI button
local function connectEggButton()
    local eggButton = script.Parent:FindFirstChild("OpenEggButton")
    if eggButton then
        eggButton.MouseButton1Click:Connect(function()
            local player = Players.LocalPlayer
            openEgg(player)
        end)
    end
end

-- Connect player added event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Initialize GUI button connections
connectEvolutionButtons()
connectPotionButton()
connectEggButton()
