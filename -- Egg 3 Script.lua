-- Egg 3 Script
local egg3 = {
    pets = {
        {Name = "Mighty Cat", Strength = 3, Durability = 2, Probability = 0.20},
        {Name = "Mighty Dog", Strength = 2, Durability = 3, Probability = 0.20},
        {Name = "Super Fluffy", Strength = 5, Durability = 3, Probability = 0.20},
        {Name = "Dark Shadow", Strength = 7, Durability = 5, Probability = 0.20},
        {Name = "Platinum Cat", Strength = 8, Durability = 6, Probability = 0.20}
    },
    aura = {Name = "Radiant Aura", Strength = 3, Durability = 4}
}

-- Evolved Pets for Egg 3
local firstEvolutionPets3 = {
    {Name = "Ultimate Mighty Cat", Strength = 9, Durability = 5},
    {Name = "Mythical Mighty Dog", Strength = 8, Durability = 6},
    {Name = "Supreme Super Fluffy", Strength = 6, Durability = 6},
    {Name = "Shadow Master", Strength = 12, Durability = 7},
    {Name = "Platinum King", Strength = 15, Durability = 8}
}

local secondEvolutionPets3 = {
    {Name = "Legendary Mighty Cat", Strength = 18, Durability = 8},
    {Name = "Celestial Mighty Dog", Strength = 15, Durability = 10},
    {Name = "Mythic Super Fluffy", Strength = 12, Durability = 10},
    {Name = "Eclipse Dark Shadow", Strength = 20, Durability = 12},
    {Name = "Titanic Platinum Cat", Strength = 25, Durability = 14}
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
    local pet = getRandomPetFromEgg(egg3)
    if pet then
        addPetToInventory(player, pet.Name)
        print("Player " .. player.Name .. " got a " .. pet.Name)
        if egg3.aura then
            print("Player " .. player.Name .. " also got the aura: " .. egg
