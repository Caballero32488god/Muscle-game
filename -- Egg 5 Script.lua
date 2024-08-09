-- Egg 5 Script
local egg5 = {
    pets = {
        {Name = "Legendary Cat", Strength = 6, Durability = 5, Probability = 0.10},
        {Name = "Legendary Dog", Strength = 5, Durability = 6, Probability = 0.10},
        {Name = "Mythical Fluffy", Strength = 9, Durability = 6, Probability = 0.20},
        {Name = "Eclipse Shadow", Strength = 15, Durability = 8, Probability = 0.25},
        {Name = "Eternal Cat", Strength = 20, Durability = 10, Probability = 0.35}
    },
    aura = {Name = "Celestial Aura", Strength = 5, Durability = 6}
}

-- Evolved Pets for Egg 5
local firstEvolutionPets5 = {
    {Name = "Ultimate Legendary Cat", Strength = 15, Durability = 8},
    {Name = "Mythical Legendary Dog", Strength = 13, Durability = 9},
    {Name = "Supreme Mythical Fluffy", Strength = 11, Durability = 9},
    {Name = "Shadow Titan", Strength = 18, Durability = 12},
    {Name = "Eternal Monarch", Strength = 25, Durability = 15}
}

local secondEvolutionPets5 = {
    {Name = "Legendary Eternal Cat", Strength = 25, Durability = 12},
    {Name = "Celestial Eternal Dog", Strength = 22, Durability = 14},
    {Name = "Mythic Eternal Fluffy", Strength = 18, Durability = 14},
    {Name = "Eclipse Titan Shadow", Strength = 30, Durability = 16},
    {Name = "Titanic Eternal Monarch", Strength = 35, Durability = 18}
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
    local pet = getRandomPetFromEgg(egg5)
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
        if egg5.aura then
            print("Player " .. player.Name .. " also got the aura: " .. egg5.aura.Name)
        end
    end
end

local function evolvePets(player, petNames, evolutionStage)
    if evolutionStage == 1 then
        return evolvePetsStage1(player, petNames, firstEvolutionPets5)
    elseif evolutionStage == 2 then
        return evolvePetsStage2(player, petNames, secondEvolutionPets5)
    end
end

-- Connect GUI buttons
local eggButton = script.Parent:FindFirstChild("OpenEgg5Button")
if eggButton then
    eggButton.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        openEgg(player)
    end)
end
