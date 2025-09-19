-- invincible_darkblocks_v4_ultra_light.lua
-- Versão: 4.0 (ultra leve, funcional, sem travamentos)
-- Dark Blocks - Invencibilidade real + GUI leve + ativar/desligar + minimizar
-- Teste em conta alternativa primeiro.

if not getgenv then
    getgenv = getfenv or function() return _G end
end

-- Configurações globais
getgenv().InvincibleSettings = getgenv().InvincibleSettings or {
    Enabled = false,
    MaxHealthOverride = 1e9,
    PreventDeathState = true,
    BlockRemoteDamage = true,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Função ultra leve para proteger humanoid
local function protectHumanoid(humanoid)
    if not humanoid or humanoid.Parent == nil then return end
    humanoid.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
    humanoid.Health = humanoid.MaxHealth

    if getgenv().InvincibleSettings.PreventDeathState and humanoid.SetStateEnabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end

    -- Intercepta apenas mudanças de Health
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if getgenv().InvincibleSettings.Enabled then
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end

local function protectCharacter(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",5)
    if humanoid then
        protectHumanoid(humanoid)
    end
end

-- Protege personagem atual e futuros
if LocalPlayer.Character then protectCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(protectCharacter)

-- Hook leve para bloquear RemoteEvents de dano
pcall(function()
    if hookmetamethod and type(hookmetamethod) == "function" then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if getgenv().InvincibleSettings.Enabled then
                -- Bloqueia dano direto no Humanoid
                if typeof(self) == "Instance" and self:IsA("Humanoid") then
                    if method == "TakeDamage" or method == "Damage" or method == "SetHealth" then
                        local char = LocalPlayer.Character
                        if char and self:IsDescendantOf(char) then
                            return nil
                        end
                    end
                end
                -- Bloqueia possíveis RemoteEvents de dano
                if getgenv().InvincibleSettings.BlockRemoteDamage then
                    if method == "FireServer" or method == "InvokeServer" then
                        local str = tostring(self):lower()
                        if str:find("damage") or str:find("hit") then
                            return nil
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end)

-- GUI ultra leve
do
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
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
    frame.BackgroundColor3 = Color3.fromRGB(75, 0, 140)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1,0,0,40)
    titleBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
    titleBar.BackgroundTransparency = 0.12
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.Text = " Dark Blocks"
    title.Size = UDim2.new(1, -30,1,0)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local btnMinimize = Instance.new("TextButton")
    btnMinimize.Text = "-"
    btnMinimize.Size = UDim2.new(0,30,0,30)
    btnMinimize.Position = UDim2.new(1,-35,0,5)
    btnMinimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btnMinimize.TextColor3 = Color3.fromRGB(255,255,255)
    btnMinimize.Font = Enum.Font.GothamBold
    btnMinimize.TextSize = 20
    btnMinimize.Parent = titleBar

    local minimized = false
    btnMinimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        for i,v in pairs(frame:GetChildren()) do
            if v ~= titleBar then v.Visible = not minimized end
        end
        frame.Size = minimized and UDim2.new(0,300,0,40) or UDim2.new(0,300,0,170)
    end)

    local btnOn = Instance.new("TextButton")
    btnOn.Text = "Ativar Invencibilidade"
    btnOn.Size = UDim2.new(0.84,0,0,40)
    btnOn.Position = UDim2.new(0.08,0,0.38,0)
    btnOn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    btnOn.TextColor3 = Color3.fromRGB(255,255,255)
    btnOn.Font = Enum.Font.GothamBold
    btnOn.TextSize = 16
    btnOn.Parent = frame

    local btnOff = Instance.new("TextButton")
    btnOff.Text = "Desligar Invencibilidade"
    btnOff.Size = UDim2.new(0.84,0,0,36)
    btnOff.Position = UDim2.new(0.08,0,0.68,0)
    btnOff.BackgroundColor3 = Color3.fromRGB(180,50,70)
    btnOff.TextColor3 = Color3.fromRGB(255,255,255)
    btnOff.Font = Enum.Font.GothamBold
    btnOff.TextSize = 15
    btnOff.Parent = frame

    local status = Instance.new("TextLabel")
    status.Text = "Status: Desligado"
    status.Size = UDim2.new(1,-10,0,22)
    status.Position = UDim2.new(0,5,1,-26)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(220,220,220)
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.Parent = frame

    local function ligar()
        getgenv().InvincibleSettings.Enabled = true
        local char = LocalPlayer.Character
        if char then protectCharacter(char) end
        btnOn.Text = "Invencibilidade: ON"
        btnOn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        status.Text = "Status: Ativo (você NÃO recebe dano)"
    end

    local function desligar()
        getgenv().InvincibleSettings.Enabled = false
        btnOn.Text = "Ativar Invencibilidade"
        btnOn.BackgroundColor3 = Color3.fromRGB(0,170,255)
        status.Text = "Status: Desligado (você recebe dano)"
    end

    btnOn.MouseButton1Click:Connect(ligar)
    btnOff.MouseButton1Click:Connect(desligar)
end
