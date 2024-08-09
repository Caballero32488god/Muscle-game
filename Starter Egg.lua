-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Constants
local GROUP_ID = 34532560 -- Replace with your actual group ID
local GAME_PASS_ID = 13600173502 -- Updated with your actual game pass ID
local EGG_DISTANCE = 10 -- Distance at which the button appears

-- Egg Model and ProximityPrompt
local egg = script.Parent -- The egg model
local ProximityPrompt = egg:FindFirstChildOfClass("ProximityPrompt")

-- ScreenGui and Button
local player = Players.LocalPlayer
local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui")
local button = screenGui and screenGui:FindFirstChild("TextButton")
if not screenGui or not button then
    warn("ScreenGui or TextButton not found!")
    return
end

-- Pet Definitions with Attributes and Probabilities
local pets = {
    {Name = "Cat", Strength = 1, Durability = 0, Probability = 0.25},
    {Name = "Dog", Strength = 0, Durability = 1, Probability = 0.25},
    {Name = "Fluffy", Strength = 2, Durability = 1, Probability = 0.20},
    {Name = "Shadow", Strength = 5, Durability = 2, Probability = 0.15},
    {Name = "Golden Dog", Strength = 4, Durability = 4, Probability = 0.10} -- Rarest pet
}

-- Aura Definitions with Attributes and Probabilities
local auras = {
    {Name = "Powerful Aura", Strength = 2, Durability = 5, Probability = 0.05} -- Rarest aura
}

-- Function to check if player is in the group
local function isPlayerInGroup(player)
    local success, result = pcall(function()
        return HttpService:GetAsync("https://api.roblox.com/users/" .. player.UserId .. "/groups")
    end)
    if success then
        local groups = HttpService:JSONDecode(result)
        for _, group in pairs(groups) do
            if group.Id == GROUP_ID then
                return true
            end
        end
    end
    return false
end

-- Function to check if player owns the game pass
local function hasGamePass(player)
    local success, result = pcall(function()
        return MarketplaceService:HasPass(player.UserId, GAME_PASS_ID)
    end)
    return success and result
end

-- Function to assign chat role with color to the player
local function assignChatRole(player)
    if isPlayerInGroup(player) then
        local chatService = require(game:GetService("Chat"))
        
        if chatService and chatService:SetPlayerTag then
            chatService:SetPlayerTag(player, "<font color=\"#006400\">[Supporter] " .. player.Name .. "</font>")
        else
            warn("Chat service or SetPlayerTag method not found!")
        end
    end
end

-- Function to add item to inventory (pets or auras)
local function addItemToInventory(item)
    -- Example function to add an item to the player's inventory
    -- Implement this based on your inventory system
    print(player.Name .. " received: " .. item.Name)
end

-- Function to get a random item (pet or aura) based on probabilities
local function getRandomItem()
    local randomValue = math.random()
    local cumulativeProbability = 0
    local itemList = {}
    
    -- Add all items (pets and auras) to itemList
    for _, pet in ipairs(pets) do
        table.insert(itemList, {Type = "Pet", Data = pet, Probability = pet.Probability})
    end
    for _, aura in ipairs(auras) do
        table.insert(itemList, {Type = "Aura", Data = aura, Probability = aura.Probability})
    end
    
    -- Get a random item based on probabilities
    for _, item in ipairs(itemList) do
        cumulativeProbability = cumulativeProbability + item.Probability
        if randomValue <= cumulativeProbability then
            return item
        end
    end
end

-- Function to handle egg interaction
local function onEggInteraction()
    if button then
        button.Visible = false
    end
    
    local item = getRandomItem()
    addItemToInventory(item.Data)
    
    playHatchingAnimation()
    print(player.Name .. " has opened an egg and received: " .. item.Data.Name)
    egg:Destroy()
end

-- Function to handle opening multiple eggs
local function onOpenEggs()
    local openCount = 1
    if hasGamePass(player) then
        openCount = 8
    elseif isPlayerInGroup(player) then
        openCount = 3
    end
    
    for i = 1, openCount do
        onEggInteraction()
        wait(1)
    end
end

-- Function to play egg hatching animation
local function playHatchingAnimation()
    local eggAnimation = Instance.new("Animation")
    eggAnimation.Name = "HatchAnimation"
    eggAnimation.AnimationId = "rbxassetid://507771019" -- Replace with your animation ID
    local animationTrack = player.Character and player.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(eggAnimation)
    
    if animationTrack then
        animationTrack:Play()
        wait(2)
        animationTrack:Stop()
    else
        warn("Humanoid not found or animation failed to load.")
    end
end

-- Function to update button visibility based on proximity
local function updateButtonVisibility()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - egg.Position).magnitude
        if distance <= EGG_DISTANCE then
            button.Visible = true
            button.Text = hasGamePass(player) and "8X Hatch" or (isPlayerInGroup(player) and "3X Hatch" or "1X Hatch")
        else
            button.Visible = false
        end
    end
end

-- Connect ProximityPrompt
if ProximityPrompt then
    ProximityPrompt.ActionText = "Open Egg"
    ProximityPrompt.ObjectText = "1X Hatch"
    ProximityPrompt.Triggered:Connect(onOpenEggs)
end

-- Connect custom GUI button
button.MouseButton1Click:Connect(onOpenEggs)

-- Connect player added event to assign chat role
Players.PlayerAdded:Connect(function(player)
    assignChatRole(player)
end)

-- Update button visibility periodically
RunService.Heartbeat:Connect(updateButtonVisibility)
