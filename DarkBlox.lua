-- Nome do script: DarkBlox Avançado
-- Painel funcional com teleporte animado e suporte a múltiplas funções

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkBloxGUI"
ScreenGui.Parent = game.CoreGui

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.8, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Visible = true

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox v2"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

-- Função para criar botões
local function createButton(name, yPos, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 220, 0, 40)
    button.Position = UDim2.new(0, 15, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    button.TextColor3 = Color3.new(1,1,1)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = Frame
    button.MouseButton1Click:Connect(func)
    return button
end

-- Teleporte para o spawn do personagem, mantendo itens na mão
local function teleportToSpawn()
    if HRP and LocalPlayer then
        -- Pega o spawn do personagem
        local spawnLocation = LocalPlayer.RespawnLocation or Workspace:FindFirstChild("SpawnLocation")
        local targetCFrame

        if spawnLocation then
            targetCFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0) -- Leva 3 studs acima para evitar prender no chão
        else
            targetCFrame = HRP.CFrame -- fallback caso não encontre spawn
        end

        -- Teleporte animado
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- Exemplo de função adicional: Teleporte aleatório
local function teleportRandom()
    if HRP then
        local randomPos = Vector3.new(math.random(-100,100), 10, math.random(-100,100))
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(randomPos)})
        tween:Play()
    end
end

-- Criar botões
createButton("Ir para o Spawn", 40, teleportToSpawn)
createButton("Teleporte Aleatório", 90, teleportRandom)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSpawn()
    elseif input.KeyCode == Enum.KeyCode.R then
        teleportRandom()
    end
end)
