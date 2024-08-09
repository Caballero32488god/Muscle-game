-- Egg 4 Script
local egg4 = {
    pets = {
        {Name = "Elite Cat", Strength = 4, Durability = 3, Probability = 0.15},
        {Name = "Elite Dog", Strength = 3, Durability = 4, Probability = 0.15},
        {Name = "Ultimate Fluffy", Strength = 7, Durability = 4, Probability = 0.20},
        {Name = "Shadow King", Strength = 10, Durability = 6, Probability = 0.25},
        {Name = "Diamond Cat", Strength = 12, Durability = 7, Probability = 0.25}
    },
    aura = {Name = "Supreme Aura", Strength = 4, Durability = 5}
}

-- Evolved Pets for Egg 4
local firstEvolutionPets4 = {
    {Name = "Ultimate Elite Cat", Strength = 10, Durability = 6},
    {Name = "Mythical Elite Dog", Strength = 9, Durability = 7},
    {Name = "Supreme Ultimate Fluffy", Strength = 8, Durability = 7},
    {Name = "Shadow Emperor", Strength = 14, Durability = 8},
    {Name = "Diamond Monarch", Strength = 16, Durability = 9}
}

local secondEvolutionPets4 = {
    {Name = "Legendary Elite Cat", Strength = 20, Durability = 10},
    {Name = "Celestial Elite Dog", Strength = 18, Durability = 12},
    {Name = "Mythic Ultimate Fluffy", Strength = 15, Durability = 12},
    {Name = "Eclipse Shadow King", Strength = 25, Durability = 14},
    {Name = "Titanic Diamond Cat", Strength = 30, Durability = 16}
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
    local pet = getRandomPetFromEgg(egg4)
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
        if egg4.aura then
            print("Player " .. player.Name .. " also got the aura: " .. egg4.aura.Name)
        end
    end
end

local function evolvePets(player, petNames, evolutionStage)
    if evolutionStage == 1 then
        return evolvePetsStage1(player, petNames, firstEvolutionPets4)
    elseif evolutionStage == 2 then
        return evolvePetsStage2(player, petNames, secondEvolutionPets4)
    end
end

-- Connect GUI buttons
local eggButton = script.Parent:FindFirstChild("OpenEgg4Button")
if eggButton then
    eggButton.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        openEgg(player)
    end)
end
