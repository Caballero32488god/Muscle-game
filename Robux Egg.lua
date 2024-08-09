-- ServerScriptService

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local devProductId = 1902493631 -- Your Developer Product ID

-- Define Pets and Stats
local pets = {
    {name = "Blaze Hound", strength = 1000, durability = 1000, agility = 1000},
    {name = "Thunder Tiger", strength = 1500, durability = 1500, agility = 1500},
    {name = "Mystic Dragon", strength = 2000, durability = 2000, agility = 2000},
    {name = "Inferno Phoenix", strength = 3000, durability = 3000, agility = 3000}
}

-- Create Pets Folder in ReplicatedStorage
local petsFolder = Instance.new("Folder")
petsFolder.Name = "Pets"
petsFolder.Parent = ReplicatedStorage

-- Create Pet Models in ReplicatedStorage
for _, pet in ipairs(pets) do
    local petModel = Instance.new("Model")
    petModel.Name = pet.name
    petModel.Parent = petsFolder

    local strength = Instance.new("IntValue")
    strength.Name = "Strength"
    strength.Value = pet.strength
    strength.Parent = petModel

    local durability = Instance.new("IntValue")
    durability.Name = "Durability"
    durability.Value = pet.durability
    durability.Parent = petModel

    local agility = Instance.new("IntValue")
    agility.Name = "Agility"
    agility.Value = pet.agility
    agility.Parent = petModel
end

-- Create Robux Egg Model
local egg = Instance.new("Model")
egg.Name = "Robux Egg"
egg.Parent = workspace -- Or place it in a desired location

local clickablePart = Instance.new("Part")
clickablePart.Name = "ClickableArea"
clickablePart.Size = Vector3.new(5, 5, 5) -- Adjust size as needed
clickablePart.Anchored = true
clickablePart.CanCollide = false
clickablePart.Parent = egg

local proximityPrompt = Instance.new("ProximityPrompt")
proximityPrompt.ActionText = "Open Robux Egg"
proximityPrompt.ObjectText = "Robux Egg"
proximityPrompt.MaxActivationDistance = 10 -- Adjust as needed
proximityPrompt.Parent = clickablePart

-- Local Script for UI and Purchase Handling
local function createPurchaseUi(player)
    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end

    local purchaseGui = Instance.new("ScreenGui")
    purchaseGui.Name = "PurchaseGui"
    purchaseGui.Parent = playerGui

    local purchaseFrame = Instance.new("Frame")
    purchaseFrame.Name = "PurchaseFrame"
    purchaseFrame.Size = UDim2.new(0.5, 0, 0.3, 0)
    purchaseFrame.Position = UDim2.new(0.25, 0, 0.35, 0)
    purchaseFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    purchaseFrame.BackgroundTransparency = 0.5
    purchaseFrame.Parent = purchaseGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "Buy 1 Robux Egg for 100 Robux"
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = purchaseFrame

    local purchaseButton = Instance.new("TextButton")
    purchaseButton.Text = "Purchase"
    purchaseButton.Size = UDim2.new(1, 0, 0.4, 0)
    purchaseButton.Position = UDim2.new(0, 0, 0.6, 0)
    purchaseButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    purchaseButton.Parent = purchaseFrame

    purchaseButton.MouseButton1Click:Connect(function()
        MarketplaceService:PromptProductPurchase(player, devProductId)
    end)

    return purchaseGui
end

-- Function to Get a Random Pet
local function getRandomPet()
    local petNames = {}
    for _, pet in ipairs(pets) do
        table.insert(petNames, pet.name)
    end
    local randomIndex = math.random(1, #petNames)
    return petsFolder:FindFirstChild(petNames[randomIndex]):Clone()
end

-- Handle Purchase Receipt
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if player and receiptInfo.ProductId == devProductId then
        local pet = getRandomPet()
        local clonedPet = pet:Clone()
        clonedPet.Parent = player.Backpack

        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        if playerGui and playerGui:FindFirstChild("PurchaseGui") then
            playerGui.PurchaseGui.PurchaseFrame.Visible = false
        end

        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- LocalScript to Handle Interaction and UI
local function onProximityPromptTriggered(player)
    local purchaseGui = createPurchaseUi(player)
    purchaseGui.Parent = player:FindFirstChildOfClass("PlayerGui")
end

clickablePart.ProximityPrompt.Triggered:Connect(onProximityPromptTriggered)
