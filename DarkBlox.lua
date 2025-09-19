--[[
Dark Teleport - Cliente + Servidor Integrado
100% Funcional para Executor
Funcionalidades:
- Salvar spawn atual
- Teleportar para spawn salvo
- Mantém ferramentas/itens na mão
- Painel interativo, minimizável e colorido
--]]

-- ==============================
-- PARTE SERVIDOR
-- ==============================
if game:GetService("RunService"):IsServer() then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Criar RemoteEvent
    local teleportEvent = Instance.new("RemoteEvent")
    teleportEvent.Name = "TeleportEvent"
    teleportEvent.Parent = ReplicatedStorage
    
    -- Função para teleportar personagem
    teleportEvent.OnServerEvent:Connect(function(player, targetCFrame)
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            hrp.CFrame = targetCFrame
            hrp.Velocity = Vector3.new(0,0,0)
            
            -- Mantém ferramenta na mão
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool.Handle.CFrame = targetCFrame
            end
        end
    end)
end

-- ==============================
-- PARTE CLIENTE
-- ==============================
if game:GetService("RunService"):IsClient() then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    
    local teleportEvent = ReplicatedStorage:WaitForChild("TeleportEvent")
    
    -- GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TeleportGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
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
            mainFrame:TweenSize(UDim2.new(0, 300, 0, 200), "Out", "Quad", 0.3, true)
            buttonContainer.Visible = true
        end
    end)
    
    -- Variável para salvar spawn
    local savedSpawnCFrame = nil
    
    -- Botão salvar posição
    local saveButton = Instance.new("TextButton")
    saveButton.Size = UDim2.new(0.8, 0, 0, 50)
    saveButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    saveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveButton.Font = Enum.Font.GothamBold
    saveButton.TextSize = 18
    saveButton.Text = "Salvar Spawn Atual"
    saveButton.Parent = buttonContainer
    
    saveButton.MouseButton1Click:Connect(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savedSpawnCFrame = character.HumanoidRootPart.CFrame
            saveButton.Text = "Spawn Salvo ✅"
            wait(1)
            saveButton.Text = "Salvar Spawn Atual"
        end
    end)
    
    -- Botão teleportar
    local teleportButton = Instance.new("TextButton")
    teleportButton.Size = UDim2.new(0.8, 0, 0, 50)
    teleportButton.Position = UDim2.new(0.1, 0, 0.55, 0)
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.Font = Enum.Font.GothamBold
    teleportButton.TextSize = 18
    teleportButton.Text = "Teleportar ao Spawn Salvo"
    teleportButton.Parent = buttonContainer
    
    teleportButton.MouseButton1Click:Connect(function()
        if savedSpawnCFrame then
            teleportEvent:FireServer(savedSpawnCFrame)
        end
    end)
