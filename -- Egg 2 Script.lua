-- Egg 2 Script
local egg2 = {
    pets = {
        {Name = "Young Cat", Strength = 2, Durability = 1, Probability = 0.25},
        {Name = "Young Dog", Strength = 1, Durability = 2, Probability = 0.25},
        {Name = "Fluffy", Strength = 3, Durability = 2, Probability = 0.20},
        {Name = "Shadow Pup", Strength = 5, Durability = 3, Probability = 0.20},
        {Name = "Golden Cat", Strength = 6, Durability = 4, Probability = 0.10}
    },
    aura = {Name = "Shining Aura", Strength = 2, Durability = 3}
}

-- Evolved Pets for Egg 2
local firstEvolutionPets2 = {
    {Name = "Ultimate Young Cat", Strength = 7, Durability = 4},
    {Name = "Mythical Young Dog", Strength = 6, Durability = 5},
    {Name = "Supreme Fluffy", Strength = 5, Durability = 5},
    {Name = "Shadow King", Strength = 9, Durability = 6},
    {Name = "Golden Monarch", Strength = 11, Durability = 7}
}

local secondEvolutionPets2 = {
    {Name = "Legendary Young Cat", Strength = 14, Durability = 8},
    {Name = "Celestial Young Dog", Strength = 12, Durability = 10},
    {Name = "Mythic Fluffy", Strength = 10, Durability = 10},
    {Name = "Eclipse Shadow Pup", Strength = 18, Durability = 12},
    {Name = "Titanic Golden Cat", Strength = 22, Durability = 14}
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
    local pet = getRandomPetFromEgg(egg2)
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
        if egg2.aura then
            print("Player " .. player.Name .. " also got the aura: " .. egg2.aura.Name)
        end
    end
end

local function evolvePets(player, petNames, evolutionStage)
    if evolutionStage == 1 then
        return evolvePetsStage1(player, petNames, firstEvolutionPets2)
    elseif evolutionStage == 2 then
        return evolvePetsStage2(player, petNames, secondEvolutionPets2)
    end
end

-- Connect GUI buttons
local eggButton = script.Parent:FindFirstChild("OpenEgg2Button")
if eggButton then
    eggButton.MouseButton1Click:Connect(function()
        local player = Players.LocalPlayer
        openEgg(player)
    end)
end
