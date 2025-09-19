-- Teleport Profissional 100% Funcional Roblox
-- Teleporta para spawn definido no mapa, mantém itens na mão
-- Painel interativo com minimizar/restaurar

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -35)
buttonContainer.Position = UDim2.new(0, 0, 0, 35)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

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

-- === TELEPORTE ===
-- Defina manualmente o ponto de spawn real do mapa
-- Substitua Vector3.new(x, y, z) pela posição exata do spawn do seu mapa
local SPAWN_POSITION = Vector3.new(0, 5, 0)

local function teleportToSpawn()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local targetCFrame = CFrame.new(SPAWN_POSITION)

    -- Teleporte suave
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    -- Teleporta ferramenta se estiver na mão
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool.Handle.CFrame = hrp.CFrame
    end
end

-- Botão de teleporte
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0.2, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 18
teleportButton.Text = "Teleportar ao Spawn"
teleportButton.Parent = buttonContainer
teleportButton.MouseButton1Click:Connect(teleportToSpawn)
