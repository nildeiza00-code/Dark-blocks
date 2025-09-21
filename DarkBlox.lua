--[[
Script de Teleporte Funcional
Painel + Botão + Teleporte suavizado
]]

-- Obter o Player e o PlayerGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verifica se o GUI já existe e remove para evitar duplicação
if playerGui:FindFirstChild("TeleportGUI") then
    playerGui.TeleportGUI:Destroy()
end

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Criar Frame principal
local Frame = Instance.new("Frame")
Frame.Name = "TeleportFrame"
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50) -- Centralizado
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 2
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Criar botão de teleporte
local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(0, 150, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -75, 0.5, -25)
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.BorderColor3 = Color3.fromRGB(40, 40, 40)
TeleportButton.BorderSizePixel = 1
TeleportButton.Text = "Teleportar"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 18
TeleportButton.Parent = Frame

-- Função de teleporte suavizado
local function teleportar(destino)
    local character = player.Character
    if not character or not character.PrimaryPart then
        warn("Personagem ou PrimaryPart não encontrado.")
        return
    end

    local origem = character.PrimaryPart.Position
    local distancia = (destino - origem).Magnitude
    local velocidade = 10
    local passos = math.ceil(distancia / velocidade)

    for i = 1, passos do
        local alpha = i / passos
        local novaPos = origem:Lerp(destino, alpha)
        character:SetPrimaryPartCFrame(CFrame.new(novaPos))
        task.wait() -- Mantém a suavidade
    end
end

-- Evento do botão
TeleportButton.MouseButton1Click:Connect(function()
    local mouse = player:GetMouse()
    local destino = mouse.Hit and mouse.Hit.p
    if destino then
        teleportar(destino)
    else
        warn("Destino inválido!")
    end
end)
