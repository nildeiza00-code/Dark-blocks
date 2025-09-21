-- CÓDIGO PARA SER USADO NO EXECUTOR

-- Verifica se a GUI já existe para evitar criar múltiplas
if not pcall(function() return getgenv().TeleportGUI end) then
    getgenv().TeleportGUI = Instance.new("ScreenGui")
    getgenv().TeleportGUI.Name = "TeleportGUI"
    getgenv().TeleportGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = getgenv().TeleportGUI
ScreenGui.ResetOnSpawn = false

-- Cria o Frame principal do painel
local Frame = Instance.new("Frame")
Frame.Name = "TeleportFrame"
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BorderSizePixel = 2
Frame.Draggable = true -- Permite arrastar o painel
Frame.Parent = ScreenGui

-- Cria o botão de teleporte
local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(0, 150, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -75, 0.5, -25)
TeleportButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TeleportButton.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
TeleportButton.BorderSizePixel = 1
TeleportButton.Text = "Teleportar"
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 18
TeleportButton.Parent = Frame

-- Função principal do teleporte
local function teleportar(destino)
    local personagem = game.Players.LocalPlayer.Character
    if not personagem then
        warn("Personagem não encontrado.")
        return
    end

    local origem = personagem.PrimaryPart.CFrame.Position
    local distancia = (destino - origem).Magnitude
    
    -- Ajuste a velocidade para ser mais rápido ou mais lento
    local velocidade = 10 -- Mova 10 studs por frame
    
    local passos = math.ceil(distancia / velocidade)

    for i = 1, passos do
        local alpha = i / passos
        local novaPosicao = origem:Lerp(destino, alpha)
        
        personagem:SetPrimaryPartCFrame(CFrame.new(novaPosicao))
        
        -- Pequena pausa para o servidor processar
        task.wait() 
    end
end

-- Evento de clique no botão
TeleportButton.MouseButton1Click:Connect(function()
    -- Obtenha a posição do mouse na tela 3D do jogo
    local mouse = game.Players.LocalPlayer:GetMouse()
    local destino = mouse.Hit.p
    
    -- Se o destino for válido, inicie o teleporte
    if destino then
        teleportar(destino)
    end
end)
