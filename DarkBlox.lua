-- Nome do script: DarkBlox Avançado
-- Teleporte para spawn sem quebrar o script, funciona múltiplas vezes

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Função para atualizar referência do personagem
local function updateCharacter()
    Character = LocalPlayer.Character
    HRP = Character:WaitForChild("HumanoidRootPart")
end

-- Atualiza referência quando o personagem morre e reaparece
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkBloxGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.8, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Visible = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox v2"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

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

-- Teleporte para spawn do personagem (funciona várias vezes)
local function teleportToSpawn()
    if HRP and LocalPlayer then
        local spawnLocation = LocalPlayer.RespawnLocation or Workspace:FindFirstChild("SpawnLocation")
        local targetCFrame

        if spawnLocation then
            targetCFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0)
        else
            targetCFrame = HRP.CFrame
        end

        -- Teleporte animado
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- Teleporte aleatório (mantendo itens)
local function teleportRandom()
    if HRP then
        local randomPos = Vector3.new(math.random(-100,100), 10, math.random(-100,100))
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(randomPos)})
        tween:Play()
    end
end

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
