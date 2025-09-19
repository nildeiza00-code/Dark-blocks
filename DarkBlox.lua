-- DarkBlox Robin Hood - Teleporte Profissional
-- Teleporta para o ponto de spawn mantendo itens na mão e sem morrer

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Ponto de spawn inicial
local spawnCFrame = HRP.CFrame + Vector3.new(0,3,0)

-- Atualiza referência do personagem ao reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    spawnCFrame = HRP.CFrame + Vector3.new(0,3,0)
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkBloxGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,250,0,120)
Frame.Position = UDim2.new(0.5,-125,0.8,-60)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox Robin Hood"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

-- Função para criar botão
local function createButton(name, yPos, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,220,0,40)
    button.Position = UDim2.new(0,15,0,yPos)
    button.BackgroundColor3 = Color3.fromRGB(0,170,255)
    button.TextColor3 = Color3.new(1,1,1)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = Frame
    button.MouseButton1Click:Connect(func)
    return button
end

-- Função de teleporte seguro
local function teleportToSpawn()
    if HRP and Humanoid then
        -- Desativa colisão temporária
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end

        -- Mantém Humanoid ativo para não morrer
        Humanoid.Health = Humanoid.Health

        -- Teleporte instantâneo
        HRP.CFrame = spawnCFrame

        -- Restaura colisão após 0.5s
        task.delay(0.5,function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                    part.CanCollide = true
                end
            end
        end)
    end
end

-- Criar botão no GUI
createButton("Ir para Spawn", 50, teleportToSpawn)

-- Keybind (opcional)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSpawn()
    end
end)
