--[[
Nome: DarkBlocks
Descrição: Painel ADM completo para Roblox
Autor: Você
Funções: Freeze, Kick, WalkSpeed, JumpPower
Uso: Colar no seu jogo (Server + LocalScript juntos)
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Criar RemoteEvent para comunicação
local RemoteEvent = ReplicatedStorage:FindFirstChild("DarkBlocksEvent")
if not RemoteEvent then
    RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = "DarkBlocksEvent"
    RemoteEvent.Parent = ReplicatedStorage
end

-- Administradores (substitua pelos UserIds)
local ADMINS = {
    [12345678] = true,
}

-- Dados de jogadores congelados
local frozenData = {}

-- FUNÇÕES DO SERVIDOR
local function safeHumanoid(character)
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

local function freezePlayer(target)
    if not target or not target.Character then return end
    local hum = safeHumanoid(target.Character)
    if not hum then return end

    if frozenData[target.UserId] then return end

    local root = target.Character:FindFirstChild("HumanoidRootPart")
    frozenData[target.UserId] = {
        walkSpeed = hum.WalkSpeed,
        jumpPower = hum.JumpPower or 50,
        platformStand = hum.PlatformStand,
        anchored = root and root.Anchored
    }

    hum.WalkSpeed = 0
    hum.JumpPower = 0
    hum.PlatformStand = true
    if root then root.Anchored = true end
end

local function unfreezePlayer(target)
    local data = frozenData[target.UserId]
    if not data or not target.Character then return end

    local hum = safeHumanoid(target.Character)
    if hum then
        hum.WalkSpeed = data.walkSpeed or 16
        hum.JumpPower = data.jumpPower or 50
        hum.PlatformStand = data.platformStand or false
    end

    local root = target.Character:FindFirstChild("HumanoidRootPart")
    if root and data.anchored ~= nil then
        root.Anchored = data.anchored
    end

    frozenData[target.UserId] = nil
end

local function kickPlayer(target, reason)
    if target and target:IsDescendantOf(game) then
        target:Kick(reason or "Você foi kickado pelo ADM.")
    end
end

RemoteEvent.OnServerEvent:Connect(function(player, action, targetUserId, extra)
    if not ADMINS[player.UserId] then return end
    local target = Players:GetPlayerByUserId(targetUserId)
    if not target then return end

    if action == "freeze" then
        freezePlayer(target)
    elseif action == "unfreeze" then
        unfreezePlayer(target)
    elseif action == "kick" then
        kickPlayer(target, extra)
    elseif action == "setspeed" then
        local hum = safeHumanoid(target.Character)
        if hum and extra then
            hum.WalkSpeed = tonumber(extra) or hum.WalkSpeed
        end
    elseif action == "setjump" then
        local hum = safeHumanoid(target.Character)
        if hum and extra then
            hum.JumpPower = tonumber(extra) or hum.JumpPower
        end
    end
end)

--[[
LOCAL SCRIPT - Painel ADM
Este código cria o painel e envia eventos para o servidor
Pode ser colocado dentro de StarterGui → LocalScript
]]

local LocalPlayer = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkBlocksGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0.65, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = screenGui

local uiList = Instance.new("UIListLayout")
uiList.Parent = main
uiList.Padding = UDim.new(0,5)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

local function rebuildList()
    for _, v in pairs(main:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            frame.Parent = main

            local label = Instance.new("TextLabel")
            label.Text = pl.Name
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,1,1)
            label.Parent = frame

            local freezeBtn = Instance.new("TextButton")
            freezeBtn.Text = "Freeze"
            freezeBtn.Size = UDim2.new(0, 70, 0, 30)
            freezeBtn.Position = UDim2.new(0.55, 0, 0.15, 0)
            freezeBtn.Parent = frame
            freezeBtn.MouseButton1Click:Connect(function()
                RemoteEvent:FireServer("freeze", pl.UserId)
            end)

            local unfreezeBtn = Instance.new("TextButton")
            unfreezeBtn.Text = "Unfreeze"
            unfreezeBtn.Size = UDim2.new(0, 70, 0, 30)
            unfreezeBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
            unfreezeBtn.Parent = frame
            unfreezeBtn.MouseButton1Click:Connect(function()
                RemoteEvent:FireServer("unfreeze", pl.UserId)
            end)

            local kickBtn = Instance.new("TextButton")
            kickBtn.Text = "Kick"
            kickBtn.Size = UDim2.new(0, 50, 0, 30)
            kickBtn.Position = UDim2.new(0.87, 0, 0.15, 0)
            kickBtn.Parent = frame
            kickBtn.MouseButton1Click:Connect(function()
                RemoteEvent:FireServer("kick", pl.UserId, "Kickado pelo DarkBlocks")
            end)
        end
    end
end

Players.PlayerAdded:Connect(rebuildList)
Players.PlayerRemoving:Connect(rebuildList)
rebuildList()
