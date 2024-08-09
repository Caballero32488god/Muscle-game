-- Define the Inventory Frame and Buttons
local InventoryFrame = script.Parent
local LeftButtonFrame = InventoryFrame:FindFirstChild("LeftButtonFrame")
local PetsButton = LeftButtonFrame:FindFirstChild("PetsButton")
local AurasButton = LeftButtonFrame:FindFirstChild("AurasButton")
local PotionsButton = LeftButtonFrame:FindFirstChild("PotionsButton")
local PetsFrame = InventoryFrame:FindFirstChild("PetsFrame")
local AurasFrame = InventoryFrame:FindFirstChild("AurasFrame")
local PotionsFrame = InventoryFrame:FindFirstChild("PotionsFrame")

-- Define the inventory data structure with 100 slots
local inventory = {
    items = {}, -- stores item IDs or names
    maxSlots = 100 -- maximum number of slots
}

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

-- Example function to get items by category (you need to implement this based on your item data)
function getItemsByCategory(category)
    local itemsByCategory = {
        Pets = {"Pet1", "Pet2", "Pet3"},
        Auras = {"Aura1", "Aura2", "Aura3"},
        Potions = {"Potion1", "Potion2", "Potion3"}
    }
    return itemsByCategory[category] or {}
end

-- Button event handlers
PetsButton.MouseButton1Click:Connect(function()
    showCategory(PetsFrame, getItemsByCategory("Pets"))
end)

AurasButton.MouseButton1Click:Connect(function()
    showCategory(AurasFrame, getItemsByCategory("Auras"))
end)

PotionsButton.MouseButton1Click:Connect(function()
    showCategory(PotionsFrame, getItemsByCategory("Potions"))
end)

-- Optional: Show Pets category by default
showCategory(PetsFrame, getItemsByCategory("Pets"))

-- Inventory management functions
-- Function to add an item to the inventory
function addItem(itemID)
    if #inventory.items < inventory.maxSlots then
        table.insert(inventory.items, itemID)
        print("Item added: " .. itemID)
    else
        print("Inventory full!")
    end
end

-- Function to remove an item from the inventory
function removeItem(itemID)
    for i, item in ipairs(inventory.items) do
        if item == itemID then
            table.remove(inventory.items, i)
            print("Item removed: " .. itemID)
            return
        end
    end
    print("Item not found!")
end

-- Function to display the full inventory (for debugging)
function displayInventory()
    print("Inventory:")
    for i, item in ipairs(inventory.items) do
        print("Slot " .. i .. ": " .. item)
    end
end

-- Example event connection for adding an item (e.g., button click or other game event)
local addItemButton = InventoryFrame:FindFirstChild("AddItemButton")
if addItemButton then
    addItemButton.MouseButton1Click:Connect(function()
        addItem("NewItem")
        showCategory(PetsFrame, getItemsByCategory("Pets")) -- Refresh the Pets category for demonstration
    end)
end
