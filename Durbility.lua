-- ServerScriptService/SetupPlayerAttributes.lua

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    -- Create a leaderstats folder if it doesn't exist
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    -- Create the Durability attribute (used as health)
    local durability = Instance.new("IntValue")
    durability.Name = "Durability"
    durability.Value = 100  -- Default value for durability (adjust as needed)
    durability.Parent = leaderstats
end)
