-- invincible_darkblocks_v3_gui_optimized.lua
-- Versão otimizada: 3.2 (2024-09)
-- Invencibilidade + GUI para ROBLOX (ex: Blox Fruits)
- Sempre use contas alternativas! Existe risco de banimento em jogos com anti-cheat.

-- Compatibilidade de ambiente
se não getgenv então
    getgenv = getfenv ou function() retornar _G fim
fim

-- Configuração global
getgenv().InvincibleSettings = getgenv().InvincibleSettings ou {
    Habilitado = falso,
    MaxHealthOverride = 1e9,
    PreventDeathState = verdadeiro,
    Intervalo de fallback = 0,12,
    BlockRemoteDamage = verdadeiro,
}

-- Serviços
Jogadores locais = jogo:GetService("Jogadores")
local RunService = jogo:GetService("RunService")
Armazenamento Replicado local = jogo:GetService("Armazenamento Replicado")
local LocalPlayer = Jogadores.LocalPlayer ou Jogadores.PlayerAdded:Wait()

-- Função para proteger Humanoid
função local protectHumanoid(humanóide)
    se não for humanoide ou humanoid.Parent == nil então retorne fim

    -- MaxHealth e Saúde
    pcall(função()
        humanoide.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
        humanoide.Saúde = humanoide.SaúdeMáxima
    fim)

    -- Bloqueia estado Morto
    pcall(função()
        se getgenv().InvincibleSettings.PreventDeathState e humanoid.SetStateEnabled então
            humanoide:SetStateEnabled(Enum.HumanoidStateType.Dead, falso)
        fim
    fim)

    -- Proteção reativa à mudança de vida
    conexão local
    conn = humanoid.HealthChanged:Connect(função()
        se não getgenv().InvincibleSettings.Enabled então
            se conn então conn:Disconnect() fim
            retornar
        fim
        se humanoid.Health < humanoid.MaxHealth então
            pcall(função() humanoide.Saúde = humanoide.SaúdeMáxima fim)
        fim
    fim)

    humanoide.Morreu:Conectar(função()
        se não getgenv().InvincibleSettings.Enabled então retorne end
        tarefa.espera(0,07)
        pcall(função() humanoide.Saúde = humanoide.SaúdeMáxima fim)
    fim)
fim

-- Personagem Protege
função local protectCharacter(char)
    se não for char então retorne end
    humanoide local = char:FindFirstChildOfClass("Humanoid") ou char:WaitForChild("Humanoid", 5)
    se humanóide então
        protegerHumanoid(humanóide)
    fim
fim

-- Auto-proteção em spawn/respawn
se LocalPlayer.Character então
    protegerPersonagem(LocalPlayer.Personagem)
fim
LocalPlayer.CharacterAdded:Conectar(função(c)
    tarefa.espera(0,12)
    protegerPersonagem(c)
fim)

-- Loop fallback: reforça invencibilidade
tarefa.spawn(função()
    enquanto verdadeiro faça
        se não getgenv().InvincibleSettings.Enabled então
            tarefa.espera(0,5)
        outro
            char local = LocalPlayer.Character
            se char então
                local h = char:FindFirstChildOfClass("Humanoide")
                se h e h.Parent então
                    pcall(função()
                        se h.MaxHealth < getgenv().InvincibleSettings.MaxHealthOverride então
                            h.MaxHealth = getgenv().InvincibleSettings.MaxHealthOverride
                        fim
                        se h.Health < h.MaxHealth então
                            h.Saúde = h.SaúdeMáxima
                        fim
                    fim)
                fim
            fim
            task.wait(getgenv().InvincibleSettings.FallbackInterval ou 0,12)
        fim
    fim
fim)

-- Gancho de chamada de nome (TakeDamage/Damage/SetHealth)
pcall(função()
    se hookmetamethod e type(hookmetamethod) == "function" então
        antigo nome local
        oldNamecall = hookmetamethod(jogo, "__namecall", função(self, ...)
            método local = getnamecallmethod()
            se getgenv().InvincibleSettings.Enabled e typeof(self) == "Instance" e self:IsA("Humanoid") então
                se método == "TakeDamage" ou método == "Damage" ou método == "SetHealth" então
                    char local = LocalPlayer.Character
                    se char e self:IsDescendantOf(char) então
                        retornar nulo
                    fim
                fim
            fim
            retornar oldNamecall(self, ...)
        fim)
    fim
fim)

-- Interceptação básica de Remotes
pcall(função()
    função local try_wrap_remote(remoto)
        se não for remoto, retorne end
        se remoto:IsA("RemoteEvent") então
            remoto.OnClientEvent:Connect(função (...))
                se não getgenv().InvincibleSettings.Enabled ou não getgenv().InvincibleSettings.BlockRemoteDamage então retorne end
                argumentos locais = {...}
                para _, a em pares(args) faça
                    se typeof(a) == "Instance" e (a:IsA("Humanoid") ou (a:IsA("Model") e a.PrimaryPart)) então
                        se LocalPlayer.Character e (a:IsDescendantOf(LocalPlayer.Character) ou (a:IsA("Humanoid") e a:IsDescendantOf(LocalPlayer.Character))) então
                            retornar
                        fim
                    fim
                fim
            fim)
        elseif remoto:IsA("RemoteFunction") então
            se remoto.OnClientInvoke então
                local oldInvoke = remoto.OnClientInvoke
                remoto.OnClientInvoke = função (...)
                    se não getgenv().InvincibleSettings.Enabled então
                        retornar oldInvoke(...)
                    fim
                    argumentos locais = {...}
                    para _, a em pares(args) faça
                        se typeof(a) == "Instance" e (a:IsA("Humanoid") ou (a:IsA("Model") e a.PrimaryPart)) então
                            se LocalPlayer.Character e (a:IsDescendantOf(LocalPlayer.Character) ou (a:IsA("Humanoid") e a:IsDescendantOf(LocalPlayer.Character))) então
                                retornar
                            fim
                        fim
                    fim
                    retornar oldInvoke(...)
                fim
            fim
        fim
    fim

    -- Controles remotos já existentes
    para _, v em pares(ReplicatedStorage:GetDescendants()) faça
        se v:IsA("RemoteEvent") ou v:IsA("RemoteFunction") então
            pcall(função() try_wrap_remote(v) fim)
        fim
    fim
    -- Novos Controles Remotos
    ReplicatedStorage.DescendantAdded:Connect(função(d)
        se d:IsA("RemoteEvent") ou d:IsA("RemoteFunction") então
            pcall(função() try_wrap_remote(d) fim)
        fim
    fim)
fim)

-- GUI: Blocos Escuros
fazer
    playerGui local = LocalPlayer:WaitForChild("PlayerGui")
    local antigo = playerGui:FindFirstChild("DarkBlocksGui")
    se antigo então antigo:Destroy() fim

    interface gráfica local = Instância.new("ScreenGui")
    gui.Nome = "DarkBlocksGui"
    gui.ResetOnSpawn = falso
    gui.Parent = jogadorGui

    quadro local = Instance.new("Quadro")
    frame.Size = UDim2.new(0, 300, 0, 170)
    frame.Posição = UDim2.new(0,5, -150, 0,5, -85)
    quadro.AnchorPoint = Vetor2.novo(0,5, 0,5)
    quadro.BackgroundColor3 = Cor3.fromRGB(75, 0, 140)
    quadro.BorderSizePixel = 0
    frame.Active = verdadeiro
    se pcall(function() frame.Draggable = true end) então fim
    quadro.Parent = gui

    titleBar local = Instance.new("Quadro")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 0,12
    titleBar.BackgroundColor3 = Cor3.fromRGB(0, 0, 0)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = quadro

    título local = Instance.new("TextLabel")
    title.Text = "Blocos Escuros"
    título.Tamanho = UDim2.novo(1, 0, 1, 0)
    título.Posição = UDim2.novo(0, 0, 0, 0)
    título.TransparênciaDeFundo = 1
    title.TextColor3 = Color3.fromRGB(255.255.255)
    título.Fonte = Enum.Fonte.GothamBold
    título.TamanhoDoTexto = 20
    título.TextXAligment = Enum.TextXAligment.Left
    título.Parent = titleBar

    btnOn local = Instância.new("TextButton")
    btnOn.Text = "Ativar Invencibilidade"
    btnOn.Size = UDim2.new(0,84, 0, 0, 40)
    btnOn.Posição = UDim2.novo(0,08, 0, 0,38, 0)
    btnOn.BackgroundColor3 = Cor3.fromRGB(0, 170, 255)
    btnOn.BorderSizePixel = 0
    btnOn.TextColor3 = Color3.fromRGB(255.255.255)
    btnOn.Font = Enum.Font.GothamBold
    btnOn.TextSize = 16
    btnOn.Parent = quadro

    btnOff local = Instância.new("TextButton")
    btnOff.Text = "Desligar Invencibilidade"
    btnOff.Size = UDim2.new(0,84, 0, 0, 36)
    btnOff.Position = UDim2.new(0,08, 0, 0,68, 0)
    btnOff.BackgroundColor3 = Cor3.fromRGB(180, 50, 70)
    btnOff.BorderSizePixel = 0
    btnOff.TextColor3 = Color3.fromRGB(255.255.255)
    btnOff.Fonte = Enum.Fonte.GothamBold
    btnOff.TextSize = 15
    btnOff.Parent = quadro

    status local = Instância.new("TextLabel")
    status.Text = "Status: Desligado"
    status.Tamanho = UDim2.novo(1, -10, 0, 22)
    status.Posição = UDim2.novo(0, 5, 1, -26)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(220.220.220)
    status.Fonte = Enum.Fonte.Gotham
    status.TextSize = 14
    status.Parent = quadro

    -- Ligar
    função local ligar()
        getgenv().InvincibleSettings.Enabled = verdadeiro
        char local = LocalPlayer.Character
        se char então protectCharacter(char) fim
        btnOn.Text = "Invencibilidade: ON"
        btnOn.BackgroundColor3 = Cor3.fromRGB(0, 200, 120)
        status.Text = "Status: Ativo (você não recebe dano)"
    fim

    -- Desligar
    função local desligar()
        getgenv().InvincibleSettings.Enabled = falso
        btnOn.Text = "Ativar Invencibilidade"
        btnOn.BackgroundColor3 = Cor3.fromRGB(0, 170, 255)
        status.Text = "Status: Desligado (você recebe dano)"
    fim

    btnOn.MouseButton1Click:Conectar(ligar)
    btnOff.MouseButton1Click:Conectar(desligar)
fim

-- Console da API:
-- getgenv().InvincibleSettings.Enabled = true -- ligar
-- getgenv().InvincibleSettings.Enabled = false -- desligar

retornar verdadeiro
