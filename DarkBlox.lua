-- DarkBlox Robin Hood - Teleporte Profissional Anti-Bug
-- Teleporta para spawn, mantém itens, Humanoid vivo e burlar scripts de volta

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Spawn inicial
local spawnCFrame = HRP.CFrame + Vector3.new(0,3,0)

-- Atualiza referência ao reaparecer
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
Frame.Size = UDim2.new(0,250,0,150)
Frame.Position = UDim2.new(0.5,-125,0.8,-75)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "DarkBlox v3"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

-- Função de botão
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

-- Teleporte anti-volta
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

        -- Destino seguro
        local spawnLocation = LocalPlayer.RespawnLocation or Workspace:FindFirstChild("SpawnLocation")
        local targetCFrame = spawnLocation and spawnLocation.CFrame + Vector3.new(0,3,0) or spawnCFrame

        -- Teleporte rápido múltiplo para burlar scripts do jogo
        for i = 1,5 do
            HRP.CFrame = targetCFrame
            task.wait(0.03)
        end

        -- Fixa posição por alguns frames para garantir que não volte
        local fixDuration = 0.3
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if tick() - startTime < fixDuration then
                HRP.CFrame = targetCFrame
            else
                connection:Disconnect()
            end
        end)

        -- Restaura colisão após 0.6s
        task.delay(0.6,function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Backpack) then
                    part.CanCollide = true
                end
            end
        end)
    end
end

-- Botão
createButton("Ir para Spawn",50,teleportToSpawn)

-- Keybind T
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        teleportToSpawn()
    end
end)
