-- DarkBlox Final Corrigido: Teleporte + WallHack real
-- Funciona atravessando qualquer parede, grade e mantendo itens

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Armazena spawn seguro inicial
local initialCFrame = HRP.CFrame + Vector3.new(0,3,0)

local wallHackEnabled = false

-- Atualiza referência do personagem ao reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    initialCFrame = HRP.CFrame + Vector3.new(0,3,0)

    if wallHackEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end
    end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkBloxGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.8, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Visible = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox vFinal"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

local function createButton(name,yPos,func)
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

-- Teleporte seguro completo: ignora colisão do personagem e força de scripts
local function teleportToSafeSpawn()
    if HRP then
        -- Desativa colisão temporariamente
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end

        local targetCFrame = initialCFrame
        HRP.CFrame = targetCFrame -- teleporte instantâneo para evitar "voltar"
    end
end

-- Teleporte aleatório mantendo itens
local function teleportRandom()
    if HRP then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end
        local randomPos = HRP.Position + Vector3.new(math.random(-50,50),0,math.random(-50,50))
        HRP.CFrame = CFrame.new(randomPos + Vector3.new(0,3,0))
    end
end

-- WallHack seguro: atravessar qualquer parede, grades, mantendo objetos
local function toggleWallHack()
    wallHackEnabled = not wallHackEnabled
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = not wallHackEnabled == false
            end
        end
    end
end

-- Botões
createButton("Ir para Spawn Seguro",40,teleportToSafeSpawn)
createButton("Teleporte Aleatório",90,teleportRandom)
createButton("WallHack (Atravessar paredes)",140,toggleWallHack)

-- Keybinds
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSafeSpawn()
    elseif input.KeyCode == Enum.KeyCode.R then
        teleportRandom()
    elseif input.KeyCode == Enum.KeyCode.Y then
        toggleWallHack()
    end
end)

-- Mantém WallHack ativo ao reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    if wallHackEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                part.CanCollide = false
            end
        end
    end
end)
