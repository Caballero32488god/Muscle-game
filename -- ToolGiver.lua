-- ToolGiver.lua

local Players = game:GetService("Players")
local Tool = game.ServerStorage:FindFirstChild("Weight")  -- Ensure the tool is in ServerStorage

-- Function to give the tool to a player
local function onPlayerAdded(player)
    -- Wait for the character to load
    player.CharacterAdded:Connect(function(character)
        -- Clone the tool from ServerStorage and give it to the player
        local toolClone = Tool:Clone()
        toolClone.Parent = player.Backpack
    end)
end

-- Connect the function to the PlayerAdded event
Players.PlayerAdded:Connect(onPlayerAdded)



move the "Weight" tool you created from StarterPack to ServerStorage.
This is important because the ToolGiver script references the tool in ServerStorage to give it to players.


Ensure you have a PlayerAttributes module script that defines how player attributes like strength are managed.
Make sure all scripts are properly linked to their respective services and objects
 (e.g., ServerScriptService, StarterPack, ServerStorage).

 the connection between the scripts happens automatically when you place the scripts in their respective locations:

The Tool Script inside the Weight tool handles its own functionality and should be placed inside the tool.
The ToolGiver Script in ServerScriptService handles distributing the tool and should be placed in ServerScriptService.