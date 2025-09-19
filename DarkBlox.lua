-- Nome do script: DarkBlox Final
-- Totalmente funcional para Robbery on Brinhot

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Armazena a posição inicial segura do personagem
local initialCFrame = HRP.CFrame + Vector3.new(0,3,0)

-- Atualiza referência do personagem ao reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    -- Atualiza posição inicial do spawn seguro caso precise
    initialCFrame = HRP.CFrame + Vector3.new(0,3,0)
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
Title.Text = "DarkBlox vFinal"
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

-- Teleporte seguro para o spawn inicial
local function teleportToSafeSpawn()
    if HRP then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = initialCFrame})
        tween:Play()
    end
end

-- Teleporte aleatório mantendo itens
local function teleportRandom()
    if HRP then
        local randomPos = Vector3.new(math.random(-100,100), 10, math.random(-100,100))
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(randomPos)})
        tween:Play()
    end
end

-- Criar botões
createButton("Ir para Spawn Seguro", 40, teleportToSafeSpawn)
createButton("Teleporte Aleatório", 90, teleportRandom)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSafeSpawn()
    elseif input.KeyCode == Enum.KeyCode.R then
        teleportRandom()
    end
end)
