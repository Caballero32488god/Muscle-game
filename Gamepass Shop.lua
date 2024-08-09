-- Define the GamePass IDs
local GAMEPASS_IDS = {
    ["Extra Pet Slots"] = 18870465136,
    ["2x Strength"] = 18870512707,
    ["Double XP"] = 18870901007,
    ["8x Eggs Opening"] = 13600173502
}

-- Define UI elements
local ShopFrame = script.Parent:FindFirstChild("ShopFrame")
local BuyButtons = {
    ["Extra Pet Slots"] = ShopFrame:FindFirstChild("ExtraPetSlotsButton"),
    ["2x Strength"] = ShopFrame:FindFirstChild("TwoXStrengthButton"),
    ["Double XP"] = ShopFrame:FindFirstChild("DoubleXPButton"),
    ["8x Eggs Opening"] = ShopFrame:FindFirstChild("EightXEggsButton")
}

-- Function to open the Roblox GamePass page
local function openGamePassPage(gamePassId)
    local player = game.Players.LocalPlayer
    if player then
        game:GetService("MarketplaceService"):PromptPurchase(player, gamePassId)
    end
end

-- Function to set up button click events
local function setupButton(button, gamePassId)
    button.MouseButton1Click:Connect(function()
        openGamePassPage(gamePassId)
    end)
end

-- Setup buttons with their corresponding GamePass IDs
for passName, button in pairs(BuyButtons) do
    local gamePassId = GAMEPASS_IDS[passName]
    if button and gamePassId then
        setupButton(button, gamePassId)
    else
        warn("Button or GamePass ID not found for: " .. passName)
    end
end

-- Function to grant Premium benefits
local function grantPremiumBenefits(player)
    if player.MembershipType == Enum.MembershipType.Premium then
        -- Grant special pet
        local specialPet = "Special Premium PET"
        local specialAura = "Special Premium AURA"
        local petStats = {strength = 500, durability = 500, agility = 500}
        local auraStats = {strength = 500, durability = 500, agility = 500}

        -- Add the special pet and aura to the player's inventory
        -- Example functions to add items; replace these with your own implementation
        addItemToInventory(player, specialPet, "pets")
        addItemToInventory(player, specialAura, "auras")

        -- Grant extra pet slots
        player.PetSlots = (player.PetSlots or 0) + 2

        -- Grant extra inventory space
        player.InventorySpace = (player.InventorySpace or 0) + 500

        -- Grant 3x increased experience gain
        player.ExperienceMultiplier = 3
    end
end

-- Check and grant Premium benefits when the player joins
game.Players.PlayerAdded:Connect(grantPremiumBenefits)
