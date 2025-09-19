-- invincible_darkblocks_v3_gui_optimized_fix.lua
-- Versão: 3.3.1
-- Dark Blocks - Invencibilidade otimizada (menos travamento)

if not getgenv then
    getgenv = getfenv or function() return _G end
end

getgenv().InvincibleSettings = getgenv().InvincibleSettings or {
    Enabled = false,
    MaxHealthOverride = 1e9,
    PreventDeathState = true,
    BlockRemoteDamage = true,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Protege humanoid sem travar
local function protectHumanoid(humanoid)
    if not humanoid or humanoid.Parent == nil then return end

    humanoid.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
    humanoid.Health = humanoid.MaxHealth

    if getgenv().InvincibleSettings.PreventDeathState and humanoid.SetStateEnabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end

    -- Atualiza health apenas se necessário, com debounce
    local updating = false
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().InvincibleSettings.Enabled then
            if conn then conn:Disconnect() end
            return
        end
        if not updating and humanoid.Health < humanoid.MaxHealth then
            updating = true
            pcall(function()
                humanoid.Health = humanoid.MaxHealth
            end)
            updating = false
        end
    end)
end

local function protectCharacter(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if humanoid then
        protectHumanoid(humanoid)
    end
end

if LocalPlayer.Character then protectCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(protectCharacter)

-- Hook para bloquear TakeDamage / Damage / SetHealth
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
