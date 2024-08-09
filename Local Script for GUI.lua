-- StarterGui/SettingsGUI.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Create UI elements
local sizeSlider = Instance.new("Slider", screenGui)
sizeSlider.Position = UDim2.new(0.5, -100, 0.4, -10)
sizeSlider.Size = UDim2.new(0, 200, 0, 20)
sizeSlider.MinValue = 0.1
sizeSlider.MaxValue = 5
sizeSlider.Value = humanoid.BodyScale.Value
sizeSlider.Step = 0.1
sizeSlider.Name = "SizeSlider"

local sizeLabel = Instance.new("TextLabel", screenGui)
sizeLabel.Position = UDim2.new(0.5, -100, 0.4, 20)
sizeLabel.Size = UDim2.new(0, 200, 0, 20)
sizeLabel.Text = "Size: " .. sizeSlider.Value
sizeLabel.Name = "SizeLabel"

local agilitySlider = Instance.new("Slider", screenGui)
agilitySlider.Position = UDim2.new(0.5, -100, 0.6, -10)
agilitySlider.Size = UDim2.new(0, 200, 0, 20)
agilitySlider.MinValue = 16
agilitySlider.MaxValue = 500
agilitySlider.Value = humanoid:FindFirstChild("Agility").Value
agilitySlider.Step = 1
agilitySlider.Name = "AgilitySlider"

local agilityLabel = Instance.new("TextLabel", screenGui)
agilityLabel.Position = UDim2.new(0.5, -100, 0.6, 20)
agilityLabel.Size = UDim2.new(0, 200, 0, 20)
agilityLabel.Text = "Agility: " .. agilitySlider.Value
agilityLabel.Name = "AgilityLabel"

-- Update size and agility
local function updateSettings()
    if humanoid then
        humanoid.BodyScale.Value = sizeSlider.Value
        humanoid:FindFirstChild("Agility").Value = agilitySlider.Value
        
        -- Notify server to save the new settings
        local remote = game.ReplicatedStorage:WaitForChild("SettingsChangeEvent")
        remote:FireServer(sizeSlider.Value, agilitySlider.Value)
    end
end

sizeSlider.Changed:Connect(function()
    sizeLabel.Text = "Size: " .. string.format("%.1f", sizeSlider.Value)
    updateSettings()
end)

agilitySlider.Changed:Connect(function()
    agilityLabel.Text = "Agility: " .. string.format("%.1f", agilitySlider.Value)
    updateSettings()
end)
