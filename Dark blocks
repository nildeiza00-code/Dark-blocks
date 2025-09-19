-- invincible_darkblocks_v3_gui.lua
-- Versão: 3.1
-- Dark Blocks - Invencibilidade (receptiva a danos externos) + GUI com ativar / desativar
-- Feito para executores (ex: Delta). Teste em conta alternativa. Use por sua conta e risco.

-- Compatibilidade de ambiente
if not getgenv then
    getgenv = getfenv or function() return _G end
end

-- Configurações iniciais (visíveis/alteráveis via console do executor)
getgenv().InvincibleSettings = getgenv().InvincibleSettings or {
    Enabled = false,                -- começa desligado; GUI ativa/desativa
    MaxHealthOverride = 1e9,        -- MaxHealth alto
    PreventDeathState = true,       -- tenta desativar estado Dead
    FallbackInterval = 0.12,        -- intervalo do loop fallback
    BlockRemoteDamage = true,       -- melhor esforço para ignorar remotes que enviem ref ao seu humanoid
}

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Função para aplicar proteção em um Humanoid
local function protectHumanoid(humanoid)
    if not humanoid or humanoid.Parent == nil then return end

    pcall(function()
        humanoid.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
        humanoid.Health = humanoid.MaxHealth
    end)

    pcall(function()
        if getgenv().InvincibleSettings.PreventDeathState and humanoid.SetStateEnabled then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)

    -- restaura health imediatamente caso algo aplique dano
    local conn
    conn = humanoid.HealthChanged:Connect(function()
        if not getgenv().InvincibleSettings.Enabled then
            if conn then conn:Disconnect() end
            return
        end
        if humanoid.Health < humanoid.MaxHealth then
            pcall(function() humanoid.Health = humanoid.MaxHealth end)
        end
    end)

    humanoid.Died:Connect(function()
        if not getgenv().InvincibleSettings.Enabled then return end
        wait(0.08)
        pcall(function() humanoid.Health = humanoid.MaxHealth end)
    end)
end

-- Aplica proteção ao Character
local function protectCharacter(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if humanoid then
        protectHumanoid(humanoid)
    end
end

-- Conecta proteção ao spawn/respawn
if LocalPlayer.Character then
    protectCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(function(c) wait(0.12); protectCharacter(c) end)

-- Loop fallback para reforçar Health/MaxHealth enquanto ativado
spawn(function()
    while true do
        if not getgenv().InvincibleSettings.Enabled then
            wait(0.5)
        else
            local char = LocalPlayer.Character
            if char then
                local h = char:FindFirstChildOfClass("Humanoid")
                if h and h.Parent then
                    pcall(function()
                        if h.MaxHealth < getgenv().InvincibleSettings.MaxHealthOverride then
                            h.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
                        end
                        if h.Health < h.MaxHealth then
                            h.Health = h.MaxHealth
                        end
                    end)
                end
            end
            wait(getgenv().InvincibleSettings.FallbackInterval or 0.12)
        end
    end
end)

---------------------------
-- Hook de namecall (quando executor suporta): bloqueia chamadas Damage/TakeDamage/SetHealth direcionadas ao seu Humanoid
---------------------------
pcall(function()
    if hookmetamethod and type(hookmetamethod) == "function" then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if getgenv().InvincibleSettings.Enabled and typeof(self) == "Instance" and self:IsA("Humanoid") then
                if method == "TakeDamage" or method == "Damage" or method == "SetHealth" then
                    local char = LocalPlayer.Character
                    if char and self:IsDescendantOf(char) then
                        return nil
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end)

---------------------------
-- Melhor esforço: intercepta eventos Remotes no cliente para ignorar envios que contenham referência ao seu Humanoid/Model
-- (previne danos que dependem de dados enviados ao cliente). Não cobre dano que o servidor aplique diretamente.
---------------------------
pcall(function()
    local function try_wrap_remote(remote)
        if not remote then return end
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                if not getgenv().InvincibleSettings.Enabled then return end
                if not getgenv().InvincibleSettings.BlockRemoteDamage then return end
                local args = {...}
                for _, a in pairs(args) do
                    if typeof(a) == "Instance" and (a:IsA("Humanoid") or (a:IsA("Model") and a.PrimaryPart)) then
                        if LocalPlayer.Character and (a:IsDescendantOf(LocalPlayer.Character) or (a:IsA("Humanoid") and a:IsDescendantOf(LocalPlayer.Character))) then
                            -- detectado envio de referência ao nosso humanoid/model -> ignorar efeitos locais
                            return
                        end
                    end
                end
                -- caso não seja relacionado ao nosso humanoid, não fazemos nada (não quebramos o jogo)
            end)
        elseif remote:IsA("RemoteFunction") then
            -- Protege OnClientInvoke se estiver presente (melhor esforço)
            if remote.OnClientInvoke then
                local oldInvoke = remote.OnClientInvoke
                remote.OnClientInvoke = function(...)
                    if not getgenv().InvincibleSettings.Enabled then
                        return oldInvoke(...)
                    end
                    local args = {...}
                    for _, a in pairs(args) do
                        if typeof(a) == "Instance" and (a:IsA("Humanoid") or (a:IsA("Model") and a.PrimaryPart)) then
                            if LocalPlayer.Character and (a:IsDescendantOf(LocalPlayer.Character) or (a:IsA("Humanoid") and a:IsDescendantOf(LocalPlayer.Character))) then
                                return -- evita efeitos locais
                            end
                        end
                    end
                    return oldInvoke(...)
                end
            end
        end
    end

    -- Aplica a remotes já presentes
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            pcall(function() try_wrap_remote(v) end)
        end
    end
    -- Aplica a remotes futuros
    ReplicatedStorage.DescendantAdded:Connect(function(d)
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
            pcall(function() try_wrap_remote(d) end)
        end
    end)
end)

---------------------------
-- GUI: Dark Blocks (abre automaticamente quando o script é executado)
---------------------------
do
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    -- Remove GUI anterior caso exista (evita duplicatas)
    local old = playerGui:FindFirstChild("DarkBlocksGui")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "DarkBlocksGui"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 170)
    frame.Position = UDim2.new(0.5, -150, 0.5, -85)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(75, 0, 140) -- roxo escuro
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 0.12
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.Text = " Dark Blocks"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    -- Ativar botão
    local btnOn = Instance.new("TextButton")
    btnOn.Text = "Ativar Invencibilidade"
    btnOn.Size = UDim2.new(0.84, 0, 0, 40)
    btnOn.Position = UDim2.new(0.08, 0, 0.38, 0)
    btnOn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- azul claro
    btnOn.BorderSizePixel = 0
    btnOn.TextColor3 = Color3.fromRGB(255,255,255)
    btnOn.Font = Enum.Font.GothamBold
    btnOn.TextSize = 16
    btnOn.Parent = frame

    -- Desligar botão
    local btnOff = Instance.new("TextButton")
    btnOff.Text = "Desligar Invencibilidade"
    btnOff.Size = UDim2.new(0.84, 0, 0, 36)
    btnOff.Position = UDim2.new(0.08, 0, 0.68, 0)
    btnOff.BackgroundColor3 = Color3.fromRGB(180, 50, 70) -- vermelho suave
    btnOff.BorderSizePixel = 0
    btnOff.TextColor3 = Color3.fromRGB(255,255,255)
    btnOff.Font = Enum.Font.GothamBold
    btnOff.TextSize = 15
    btnOff.Parent = frame

    -- Status label
    local status = Instance.new("TextLabel")
    status.Text = "Status: Desligado"
    status.Size = UDim2.new(1, -10, 0, 22)
    status.Position = UDim2.new(0, 5, 1, -26)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(220,220,220)
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.Parent = frame

    -- Função para ligar
    local function ligar()
        getgenv().InvincibleSettings.Enabled = true
        -- reaplica proteção imediata
        local char = LocalPlayer.Character
        if char then protectCharacter(char) end
        btnOn.Text = "Invencibilidade: ON"
        btnOn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
        status.Text = "Status: Ativo (você NÃO recebe dano)"
    end

    -- Função para desligar
    local function desligar()
        getgenv().InvincibleSettings.Enabled = false
        btnOn.Text = "Ativar Invencibilidade"
        btnOn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        status.Text = "Status: Desligado (você recebe dano)"
    end

    -- Botões
    btnOn.MouseButton1Click:Connect(function()
        ligar()
    end)
    btnOff.MouseButton1Click:Connect(function()
        desligar()
    end)
end

-- Pequena API (console do executor) para controle:
-- getgenv().InvincibleSettings.Enabled = true  -- ligar
-- getgenv().InvincibleSettings.Enabled = false -- desligar

return true
