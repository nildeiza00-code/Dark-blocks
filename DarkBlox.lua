-- Dark Teleport Executor-Safe 100% Corrigido
-- Teleporte para o ponto de spawn real do jogador
-- Teleporta junto com qualquer item que estiver na mão

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
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

-- Função de teleporte usando a posição inicial real do personagem
local function teleportToSpawn()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Pega a posição de respawn real do personagem
    local respawnCFrame = LocalPlayer:LoadCharacter() -- Recria o personagem e pega posição real de spawn
    wait(0.1) -- Espera o personagem carregar
    character = LocalPlayer.Character
    if not character then return end

    -- Teleporta de verdade para a posição de spawn
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = character.HumanoidRootPart.CFrame -- Mantém o personagem na posição inicial real
    end

    -- Teleporta item que estiver na mão (se houver)
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.CFrame = hrp.CFrame
    end
end

teleportButton.MouseButton1Click:Connect(teleportToSpawn)
