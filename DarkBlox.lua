-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Função para teleporte rápido
local function quickTeleport(targetCFrame)
    for i = 1, 5 do
        HRP.CFrame = targetCFrame
        task.wait(0.05)
    end
end

-- Função principal de teleporte
local function teleportToSpawn()
    if HRP and Humanoid then
        -- Desativa colisão temporária
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end

        -- Mantém Humanoid vivo
        Humanoid.Health = Humanoid.Health

        -- Define o ponto de destino
        local spawnLocation = LocalPlayer.RespawnLocation or Workspace:FindFirstChild("SpawnLocation")
        local targetCFrame = spawnLocation and spawnLocation.CFrame + Vector3.new(0, 3, 0) or HRP.CFrame

        -- Realiza o teleporte rápido
        quickTeleport(targetCFrame)

        -- Restaura colisão após 0.5s
        task.delay(0.5, function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                    part.CanCollide = true
                end
            end
        end)
    end
end

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox v4"
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
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = Frame
    button.MouseButton1Click:Connect(func)
    return button
end

-- Criar botão
createButton("Ir para o Spawn", 50, teleportToSpawn)

-- Keybind
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSpawn()
    end
end)
