local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local espColor = Color3.new(0, 1, 0) -- Green outline

local function createOutline(targetCharacter)
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end

    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(1, 0, 1, 0) -- Head size
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.Parent = targetRoot

    local outlineFrame = Instance.new("Frame")
    outlineFrame.Size = UDim2.new(1, 0, 1, 0) -- same as BillboardGui
    outlineFrame.BorderSizePixel = 2
    outlineFrame.BackgroundTransparency = 1
    outlineFrame.BorderColor3 = espColor
    outlineFrame.Parent = billboardGui

    return billboardGui
end

local outlines = {}

local function updateOutlines()
    if not localPlayer or not localPlayer.Character or not rootPart then return end
    local currentPlayers = Players:GetPlayers()
    for _, player in ipairs(currentPlayers) do
        if player ~= localPlayer then
            local targetCharacter = player.Character
            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                if not outlines[player] then
                  outlines[player] = createOutline(targetCharacter)
                  if not outlines[player] then
                      outlines[player] = nil
                  end
                end
            else
              if outlines[player] then
                  outlines[player]:Destroy()
                  outlines[player] = nil
               end
            end
        end
    end
   for player, gui in pairs(outlines) do
       if not Players:GetPlayerFromCharacter(gui.Parent.Parent) then
            gui:Destroy()
            outlines[player] = nil
        end
    end

end
