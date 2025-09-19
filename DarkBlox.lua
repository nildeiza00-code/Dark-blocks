-- Dark Teleport Executor-Safe 100%
-- Teleporte com GUI, funcional em qualquer executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BorderSizePixel = 0
title.Text = "Painel de Teleporte"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0, 40)
teleportButton.Position = UDim2.new(0.1, 0, 0.4, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 16
teleportButton.Text = "Teleportar ao Spawn"
teleportButton.Parent = mainFrame

-- Função de teleporte
local function teleportToSpawn()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:WaitForChild("SpawnLocation")
    if spawnLocation then
        -- Teleporta o personagem
        character:SetPrimaryPartCFrame(spawnLocation.CFrame)
        
        -- Teleporta item que estiver na mão (se houver)
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool.Handle.CFrame = character.HumanoidRootPart.CFrame
        end
    end
end

teleportButton.MouseButton1Click:Connect(teleportToSpawn)
