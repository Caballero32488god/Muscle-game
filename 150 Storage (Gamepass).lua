-- Define the Inventory Frame and Buttons
local InventoryFrame = script.Parent
local LeftButtonFrame = InventoryFrame:FindFirstChild("LeftButtonFrame")
local PetsButton = LeftButtonFrame:FindFirstChild("PetsButton")
local AurasButton = LeftButtonFrame:FindFirstChild("AurasButton")
local PotionsButton = LeftButtonFrame:FindFirstChild("PotionsButton")
local PetsFrame = InventoryFrame:FindFirstChild("PetsFrame")
local AurasFrame = InventoryFrame:FindFirstChild("AurasFrame")
local PotionsFrame = InventoryFrame:FindFirstChild("PotionsFrame")

-- GamePass ID
local GAMEPASS_ID = 18870465136

-- Define the base inventory data structure
local baseSlots = {
    pets = 100,
    auras = 100,
    potions = 100
}

-- Define the inventory data structure
local inventory = {
    items = { pets = {}, auras = {}, potions = {} },
    maxSlots = {
        pets = baseSlots.pets,
        auras = baseSlots.auras,
        potions = baseSlots.potions
    }
}

-- Check if the player has the GamePass
local function hasGamePass(player)
    local success, hasPass = pcall(function()
        return player:HasPass(GAMEPASS_ID)
    end)
    return success and hasPass
end

-- Function to update slot counts based on GamePass ownership
local function updateSlotCounts(player)
    if hasGamePass(player) then
        inventory.maxSlots.pets = baseSlots.pets + 150
        inventory.maxSlots.auras = baseSlots.auras + 150
        inventory.maxSlots.potions = baseSlots.potions + 150
    else
        inventory.maxSlots.pets = baseSlots.pets
        inventory.maxSlots.auras = baseSlots.auras
        inventory.maxSlots.potions = baseSlots.potions
    end
end

-- Function to update the category frames
local function updateCategoryFrame(frame, items)
    local slots = frame:GetChildren()
    for i, slot in ipairs(slots) do
        if i <= #items then
            slot.Visible = true
            slot.Text = items[i] -- Set slot text or image based on item ID
        else
            slot.Visible = false
        end
    end
end

-- Function to show a specific category frame
local function showCategory(categoryFrame, items)
    PetsFrame.Visible = (categoryFrame == PetsFrame)
    AurasFrame.Visible = (categoryFrame == AurasFrame)
    PotionsFrame.Visible = (categoryFrame == PotionsFrame)
    if categoryFrame == PetsFrame then
        updateCategoryFrame(PetsFrame, getItemsByCategory("Pets"))
    elseif categoryFrame == AurasFrame then
        updateCategoryFrame(AurasFrame, getItemsByCategory("Auras"))
    elseif categoryFrame == PotionsFrame then
        updateCategoryFrame(PotionsFrame, getItemsByCategory("Potions"))
    end
end

-- Example function to get items by category
function getItemsByCategory(category)
    local itemsByCategory = {
        Pets = inventory.items.pets,
        Auras = inventory.items.auras,
        Potions = inventory.items.potions
    }
    return itemsByCategory[category] or {}
end

-- Button event handlers
PetsButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    updateSlotCounts(player)
    showCategory(PetsFrame, getItemsByCategory("Pets"))
end)

AurasButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    updateSlotCounts(player)
    showCategory(AurasFrame, getItemsByCategory("Auras"))
end)

PotionsButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    updateSlotCounts(player)
    showCategory(PotionsFrame, getItemsByCategory("Potions"))
end)

-- Optional: Show Pets category by default
local player = game.Players.LocalPlayer
updateSlotCounts(player)
showCategory(PetsFrame, getItemsByCategory("Pets"))

-- Inventory management functions
-- Function to add an item to the inventory
function addItem(itemID, category)
    if #inventory.items[category] < inventory.maxSlots[category] then
        table.insert(inventory.items[category], itemID)
        print("Item added: " .. itemID)
    else
        print("Inventory full!")
    end
end

-- Function to remove an item from the inventory
function removeItem(itemID, category)
    for i, item in ipairs(inventory.items[category]) do
        if item == itemID then
            table.remove(inventory.items[category], i)
            print("Item removed: " .. itemID)
            return
        end
    end
    print("Item not found!")
end

-- Function to display the full inventory (for debugging)
function displayInventory()
    print("Inventor
