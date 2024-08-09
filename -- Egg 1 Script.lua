-- Egg 1 Script
local egg1 = {
    pets = {
        {Name = "Kitten", Strength = 1, Durability = 0, Probability = 0.30},
        {Name = "Puppy", Strength = 0, Durability = 1, Probability = 0.30},
        {Name = "Tiny Fluffy", Strength = 2, Durability = 1, Probability = 0.20},
        {Name = "Small Shadow", Strength = 3, Durability = 2, Probability = 0.15},
        {Name = "Gold Cat", Strength = 4, Durability = 3, Probability = 0.05}
    },
    aura = {Name = "Glimmer Aura", Strength = 1, Durability = 2}
}

-- Evolved Pets for Egg 1
local firstEvolutionPets1 = {
    {Name = "Ultimate Kitten", Strength = 6, Durability = 3},
    {Name = "Mythical Puppy", Strength = 5, Durability = 4},
    {Name = "Supreme Tiny Fluffy", Strength = 4, Durability = 4},
    {Name = "Shadow Master", Strength = 8, Durability = 5},
    {Name = "Golden King", Strength = 10, Durability = 6}
}

local secondEvolutionPets1 = {
    {Name = "Legendary Kitten", Strength = 12, Durability = 6},
    {Name = "Celestial Puppy", Strength = 10, Durability = 8},
    {Name = "Mythic Tiny Fluffy", Strength = 8, Durability = 8},
    {Name = "Eclipse Shadow", Strength = 15, Durability = 10},
    {Name = "Titanic Gold Cat", Strength = 18, Durability = 12}
}

local function getRandomPetFromEgg(egg)
    local rand = math.random()
    local cumulativeProbability = 0

    for _, pet in ipairs(egg.pets) do
        cumulativeProbability = cumulativeProbability + pet.Probability
        if rand <= cumulativeProbability then
            return pet
        end
    end
end

local function openEgg(player)
    local pet = getRandomPetFromEgg(egg1)
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
        if egg1.aura then
            print("Player " .. player.Name .. " also got the aura: " .. egg1.aura.Name)
        end
    end
end

local function evolvePets(player, petNames, evolutionStage)
    if evolutionStage == 1 then
        return evolvePetsStage1(player, petNames, firstEvolutionPets1)
    elseif evolutionStage == 2 then
        return evolvePetsStage2(player, petNames, secondEvolutionPets1)
    end
end

-- Connect GUI buttons
local eggButton = script.Parent:FindFirstChild("OpenEgg1Button")
if eggButton then
    eggButton.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        openEgg(player)
    end)
end
