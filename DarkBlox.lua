-- DarkBlocks Teleporte Profissional
-- Teleporta para o spawn real sem resetar, mantendo itens na mão
-- Painel arrastável, minimizável, cores verde e amarelo

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent para teleporte (necessário se quiser funcionar em servidores com scripts de respawn)
local teleportEvent = ReplicatedStorage:FindFirstChild("DarkBlocksTeleport")
if not teleportEvent then
    teleportEvent = Instance.new("RemoteEvent")
    teleportEvent.Name = "DarkBlocksTeleport"
    teleportEvent.Parent = ReplicatedStorage
end

-- Salvar spawn automaticamente ao nascer
local savedSpawnCFrame = nil
local function saveSpawn()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedSpawnCFrame = character.HumanoidRootPart.CFrame
    end
end

-- Evento para salvar spawn ao nascer
LocalPlayer.CharacterAdded:Connect(function()
    -- Delay mínimo para garantir que HumanoidRootPart exista
    wait(0.5)
    saveSpawn()
end)

-- Função de teleporte real
local function teleportToSpawn()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not savedSpawnCFrame then return end
    local hrp = character.HumanoidRootPart

    -- Teleporte real via RemoteEvent
    if teleportEvent then
        teleportEvent:FireServer(savedSpawnCFrame)
    end

    -- Atualiza CFrame localmente para evitar visual instável
    hrp.CFrame = savedSpawnCFrame
    hrp.Velocity = Vector3.new(0,0,0)

    -- Mantém ferramenta na mão
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.CFrame = savedSpawnCFrame
    end
end

-- =========================
-- GUI - Painel Arrastável e Minimável
-- =========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkBlocksGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- verde
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Arrastável
local dragging = false
local dragInput, mousePos, framePos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                       framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- amarelo
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "DarkBlocks Teleporte"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Botão minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = mainFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -30)
buttonContainer.Position = UDim2.new(0, 0, 0, 30)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 150, 0, 30)
        buttonContainer.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 250, 0, 120)
        buttonContainer.Visible = true
    end
end)

-- Botão Teleportar
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0.25, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- amarelo
teleportButton.TextColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 16
teleportButton.Text = "Teleportar para Spawn"
teleportButton.Parent = buttonContainer

teleportButton.MouseButton1Click:Connect(function()
    teleportToSpawn()
end)
