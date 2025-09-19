--           --[[
Nome: DarkBlocks Executor-Safe
Descrição: Painel ADM seguro para testes via executor
Autor: Você
Uso: Copiar e colar no GitHub e executar em qualquer executor
]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Criar GUI
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

-- Função para criar lista de jogadores (somente nomes)
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

            -- Botão Freeze (somente afeta você)
            local freezeBtn = Instance.new("TextButton")
            freezeBtn.Text = "Freeze"
            freezeBtn.Size = UDim2.new(0, 70, 0, 30)
            freezeBtn.Position = UDim2.new(0.55, 0, 0.15, 0)
            freezeBtn.Parent = frame
            freezeBtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Anchored = true
                end
            end)

            -- Botão Unfreeze
            local unfreezeBtn = Instance.new("TextButton")
            unfreezeBtn.Text = "Unfreeze"
            unfreezeBtn.Size = UDim2.new(0, 70, 0, 30)
            unfreezeBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
            unfreezeBtn.Parent = frame
            unfreezeBtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end
            end)

            -- Botão Speed (aumenta sua velocidade)
            local speedBtn = Instance.new("TextButton")
            speedBtn.Text = "Speed +50"
            speedBtn.Size = UDim2.new(0, 70, 0, 30)
            speedBtn.Position = UDim2.new(0.87, 0, 0.15, 0)
            speedBtn.Parent = frame
            speedBtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(rebuildList)
Players.PlayerRemoving:Connect(rebuildList)
rebuildList()
