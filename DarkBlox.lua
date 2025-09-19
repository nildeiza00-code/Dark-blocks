-- DarkBlocks Executor-Safe Melhorado
-- Painel Executor-Safe arrastável, minimizável e funcional
-- Autor: Você
-- Funciona em qualquer executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkBlocksGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Painel Principal
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.7, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(35,35,35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = screenGui

-- Barra superior (para arrastar e minimizar)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
topBar.Parent = main

local title = Instance.new("TextLabel")
title.Text = "Dark Blocks"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(0.9, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Parent = topBar

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 1, -30)
buttonsFrame.Position = UDim2.new(0, 0, 0, 30)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = main

-- Função para criar botões
local function createButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.45, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Layout para os botões
local uiList = Instance.new("UIListLayout")
uiList.Parent = buttonsFrame
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)

-- Criar botões Executor-Safe
createButton("Freeze", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
    end
end)

createButton("Unfreeze", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)

createButton("WalkSpeed +50", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
    end
end)

createButton("WalkSpeed +100", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
    end
end)

createButton("JumpPower +100", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 100
    end
end)

createButton("JumpPower +200", buttonsFrame, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 200
    end
end)

-- Minimizar / abrir novamente
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        buttonsFrame.Visible = false
        main.Size = UDim2.new(0,300,0,30)
    else
        buttonsFrame.Visible = true
        main.Size = UDim2.new(0,300,0,200)
    end
end)
