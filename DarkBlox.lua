-- Dark Teleport Executor 100% Profissional
-- Painel interativo com teleporte real ao spawn
-- Funciona com qualquer item na mão
-- Pode ser minimizado, colorido e totalmente funcional

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkTeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Cores do painel
local frameColor = Color3.fromRGB(60, 60, 60)
local titleColor = Color3.fromRGB(30, 30, 30)
local buttonColor = Color3.fromRGB(0, 170, 255)

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = frameColor
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = titleColor
title.BorderSizePixel = 0
title.Text = "Painel de Teleporte"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Botão minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 35, 0, 35)
minimizeButton.Position = UDim2.new(1, -35, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.Parent = mainFrame

-- Container de botões
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -35)
buttonContainer.Position = UDim2.new(0, 0, 0, 35)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Função de minimizar/restaurar
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 200, 0, 40), "Out", "Quad", 0.3, true)
        buttonContainer.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 180), "Out", "Quad", 0.3, true)
        buttonContainer.Visible = true
    end
end)

-- Função de teleporte ao spawn
local function teleportToSpawn()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Pega a posição real do spawn do personagem
    local spawnCFrame
    if workspace:FindFirstChild("SpawnLocation") then
        spawnCFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 3, 0)
    else
        -- Se não houver SpawnLocation, mantém a posição inicial do personagem
        spawnCFrame = character.HumanoidRootPart.CFrame
    end

    -- Teleporte suave usando Tween
    local hrp = character.HumanoidRootPart
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = spawnCFrame})
    tween:Play()

    -- Teleporta item que estiver na mão (Tool)
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.CFrame = hrp.CFrame
    end
end

-- Botão de teleporte
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0.2, 0)
teleportButton.BackgroundColor3 = buttonColor
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 18
teleportButton.Text = "Teleportar ao Spawn"
teleportButton.Parent = buttonContainer
teleportButton.MouseButton1Click:Connect(teleportToSpawn)

-- Botão extra: Teleporte aleatório (opcional)
local randomButton = Instance.new("TextButton")
randomButton.Size = UDim2.new(0.8, 0, 0, 50)
randomButton.Position = UDim2.new(0.1, 0, 0.6, 0)
randomButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
randomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
randomButton.Font = Enum.Font.GothamBold
randomButton.TextSize = 18
randomButton.Text = "Teleporte Aleatório"
randomButton.Parent = buttonContainer
randomButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local randomPos = Vector3.new(math.random(-500, 500), 10, math.random(-500, 500))
    character.HumanoidRootPart.CFrame = CFrame.new(randomPos)
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.CFrame = character.HumanoidRootPart.CFrame
    end
end)
