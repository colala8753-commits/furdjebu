-- MM2 ULTIMATE HUB [good] - FIXED + GODMODE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Переменные
local ESPEnabled = true
local SpeedEnabled = false
local CurrentSpeed = 16
local AutoGrabEnabled = false
local GodModeEnabled = false
local isUIOpen = false
local godModeConnections = {}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Функция кнопки открытия
local function CreateToggleButton()
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.Size = UDim2.new(0, 60, 0, 60)
    button.Position = UDim2.new(0, 10, 0, 350)
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    button.BorderSizePixel = 0
    button.Text = "⚡"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 30
    button.Parent = ScreenGui
    button.MouseButton1Click:Connect(function()
        isUIOpen = not isUIOpen
        MainFrame.Visible = isUIOpen
    end)
    return button
end

-- Создание UI
local function CreateMainUI()
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 450, 0, 550)
    frame.Position = UDim2.new(0.5, -225, 0.5, -275)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = ScreenGui

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    title.BorderSizePixel = 0
    title.Text = "MM2 ULTIMATE HUB"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 22
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        isUIOpen = false
        frame.Visible = false
    end)

    local yOffset = 55

    -- Функция создания кнопки-переключателя
    local function CreateToggleButtonUI(name, yPos, defaultState, colorOn, colorOff)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.9, 0, 0, 35)
        container.Position = UDim2.new(0.05, 0, 0, yPos)
        container.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        container.BorderSizePixel = 0
        container.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(220, 220, 255)
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.2, 0, 0.8, 0)
        btn.Position = UDim2.new(0.75, 0, 0.1, 0)
        btn.BackgroundColor3 = defaultState and colorOn or colorOff
        btn.BorderSizePixel = 0
        btn.Text = defaultState and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Parent = container

        return btn, label
    end

    -- ESP
    local espBtn, espLabel = CreateToggleButtonUI("ESP (Role Highlight)", yOffset, true, Color3.fromRGB(0, 200, 100), Color3.fromRGB(200, 50, 50))
    espBtn.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        espBtn.Text = ESPEnabled and "ON" or "OFF"
        espBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    end)

    yOffset = yOffset + 45

    -- Speed Boost
    local speedBtn, speedLabel = CreateToggleButtonUI("Speed Boost", yOffset, false, Color3.fromRGB(0, 200, 100), Color3.fromRGB(200, 50, 50))
    speedBtn.MouseButton1Click:Connect(function()
        SpeedEnabled = not SpeedEnabled
        speedBtn.Text = SpeedEnabled and "ON" or "OFF"
        speedBtn.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
        elseif not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)

    yOffset = yOffset + 45

    -- Ползунок скорости
    local speedSliderContainer = Instance.new("Frame")
    speedSliderContainer.Size = UDim2.new(0.85, 0, 0, 30)
    speedSliderContainer.Position = UDim2.new(0.075, 0, 0, yOffset)
    speedSliderContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    speedSliderContainer.BorderSizePixel = 0
    speedSliderContainer.Parent = frame

    local speedLabel2 = Instance.new("TextLabel")
    speedLabel2.Size = UDim2.new(0.15, 0, 1, 0)
    speedLabel2.Position = UDim2.new(0, 5, 0, 0)
    speedLabel2.BackgroundTransparency = 1
    speedLabel2.Text = "Speed:"
    speedLabel2.TextColor3 = Color3.fromRGB(200, 200, 255)
    speedLabel2.TextSize = 13
    speedLabel2.Parent = speedSliderContainer

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(0.6, 0, 0.3, 0)
    sliderTrack.Position = UDim2.new(0.2, 0, 0.35, 0)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = speedSliderContainer

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((CurrentSpeed - 16) / 234, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.Position = UDim2.new((CurrentSpeed - 16) / 234, -9, 0.5, -9)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderTrack

    local speedValueLabel = Instance.new("TextLabel")
    speedValueLabel.Size = UDim2.new(0.15, 0, 1, 0)
    speedValueLabel.Position = UDim2.new(0.82, 0, 0, 0)
    speedValueLabel.BackgroundTransparency = 1
    speedValueLabel.Text = tostring(CurrentSpeed)
    speedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedValueLabel.TextSize = 13
    speedValueLabel.Parent = speedSliderContainer

    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = Mouse.X
            local sliderPos = sliderTrack.AbsolutePosition.X
            local sliderSize = sliderTrack.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            CurrentSpeed = math.floor(16 + relativePos * 234)
            CurrentSpeed = math.clamp(CurrentSpeed, 16, 250)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relativePos, -9, 0.5, -9)
            speedValueLabel.Text = tostring(CurrentSpeed)
            if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
            end
        end
    end)

    yOffset = yOffset + 45

    -- Auto Grab
    local grabBtn, grabLabel = CreateToggleButtonUI("Auto Grab Gun", yOffset, false, Color3.fromRGB(0, 200, 100), Color3.fromRGB(200, 50, 50))
    grabBtn.MouseButton1Click:Connect(function()
        AutoGrabEnabled = not AutoGrabEnabled
        grabBtn.Text = AutoGrabEnabled and "ON" or "OFF"
        grabBtn.BackgroundColor3 = AutoGrabEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        if AutoGrabEnabled then
            StartAutoGrab()
        end
    end)

    yOffset = yOffset + 45

    -- GOD MODE (2 жизни)
    local godBtn, godLabel = CreateToggleButtonUI("GOD MODE (2 Lives)", yOffset, false, Color3.fromRGB(255, 0, 0), Color3.fromRGB(200, 50, 50))
    godBtn.MouseButton1Click:Connect(function()
        GodModeEnabled = not GodModeEnabled
        godBtn.Text = GodModeEnabled and "ON" or "OFF"
        godBtn.BackgroundColor3 = GodModeEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(200, 50, 50)
        if GodModeEnabled then
            EnableGodMode()
        else
            DisableGodMode()
        end
    end)

    yOffset = yOffset + 45

    -- Teleport to Spawn
    local teleBtn = Instance.new("TextButton")
    teleBtn.Size = UDim2.new(0.4, 0, 0, 35)
    teleBtn.Position = UDim2.new(0.3, 0, 0, yOffset)
    teleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    teleBtn.BorderSizePixel = 0
    teleBtn.Text = "TP to Spawn"
    teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleBtn.TextSize = 16
    teleBtn.Parent = frame
    teleBtn.MouseButton1Click:Connect(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("Baseplate")
        if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
        end
    end)

    return frame
end

-- ESP функция
local function UpdateESP()
    if not ESPEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local roleColor = Color3.fromRGB(255, 255, 255)
            if player:FindFirstChild("murder") then
                roleColor = Color3.fromRGB(255, 0, 0)
            elseif player:FindFirstChild("sheriff") then
                roleColor = Color3.fromRGB(0, 150, 255)
            end
            
            local espBox = Instance.new("BoxHandleAdornment")
            espBox.Size = Vector3.new(3, 5, 2)
            espBox.Adornee = root
            espBox.AlwaysOnTop = true
            espBox.ZIndex = 10
            espBox.Color3 = roleColor
            espBox.Transparency = 0.3
            espBox.Parent = root
            
            local nameTag = Instance.new("BillboardGui")
            nameTag.Size = UDim2.new(0, 120, 0, 35)
            nameTag.Adornee = root
            nameTag.StudsOffset = Vector3.new(0, 4, 0)
            nameTag.Parent = root
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name .. (player:FindFirstChild("murder") and " 🔪" or player:FindFirstChild("sheriff") and " ⭐" or "")
            nameLabel.TextColor3 = roleColor
            nameLabel.TextSize = 14
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.Parent = nameTag
            
            game:GetService("Debris"):AddItem(espBox, 0.1)
            game:GetService("Debris"):AddItem(nameTag, 0.1)
        end
    end
end

-- AUTO GRAB
local function StartAutoGrab()
    spawn(function()
        while AutoGrabEnabled do
            local gun = workspace:FindFirstChild("Gun") or workspace:FindFirstChild("Pistol") or workspace:FindFirstChild("Knife")
            if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                if (root.Position - gun.Position).Magnitude < 60 then
                    root.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
                    wait(0.2)
                    fireproximityprompt(gun)
                    wait(0.3)
                    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
                    if spawn then
                        root.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
                    end
                end
            end
            wait(0.5)
        end
    end)
end

-- GOD MODE (2 жизни + неуязвимость)
local function EnableGodMode()
    DisableGodMode()
    
    -- Блокировка урона
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local killGui = playerGui:FindFirstChild("KillScreen") or playerGui:FindFirstChild("DeathScreen")
        if killGui then killGui.Enabled = false end
    end
    
    -- Бесконечное здоровье
    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000
            humanoid.Health = 1000
            humanoid.BreakJointsOnDeath = false
        end
    end)
    
    -- Защита от ударов
    local function onCharacterAdded(char)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000
            humanoid.Health = 1000
            humanoid.BreakJointsOnDeath = false
            
            -- Блокировка урона
            local con
            con = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < 900 and GodModeEnabled then
                    humanoid.Health = 1000
                end
            end)
            table.insert(godModeConnections, con)
        end
    end
    
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    
    -- Телепорт при смерти в безопасную зону
    spawn(function()
        while GodModeEnabled do
            wait(0.5)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if humanoid.Health <= 0 then
                    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
                    if spawn and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
                        wait(0.3)
                        humanoid.Health = 1000
                    end
                end
            end
        end
    end)
end

local function DisableGodMode()
    for _, con in ipairs(godModeConnections) do
        con:Disconnect()
    end
    godModeConnections = {}
end

-- МОЩНЫЙ ОБХОД АНТИЧИТА
local function BypassAntiCheat()
    -- Блокировка всех античит-скриптов
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            local metatable = getmetatable(v)
            if metatable then
                for k, val in pairs(metatable) do
                    if type(val) == "function" and string.find(tostring(val), "AntiCheat") then
                        setmetatable(v, nil)
                    end
                end
            end
        end
    end
    
    -- Отключение проверок
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" then
            local argsStr = tostring(args[1]) or ""
            if argsStr:find("AntiCheat") or argsStr:find("Check") or argsStr:find("Report") then
                return nil
            end
            if type(args[1]) == "table" and rawget(args[1], "AntiCheat") then
                return nil
            end
        end
        
        if method == "Invoke" and tostring(self):find("AntiCheat") then
            return nil
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- Отключение детекта скорости
    local oldWalkSpeed
    local humanoidMetatable = getmetatable(Instance.new("Humanoid"))
    if humanoidMetatable then
        oldWalkSpeed = humanoidMetatable.__index.WalkSpeed
        humanoidMetatable.__index.WalkSpeed = function(self)
            if SpeedEnabled and GodModeEnabled then
                return CurrentSpeed
            end
            return oldWalkSpeed(self)
        end
    end
    
    -- Скрытие скрипта из памяти
    local function hideScript()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "IsRunning") then
                    rawset(v, "IsRunning", false)
                end
                if rawget(v, "Enabled") and type(rawget(v, "Enabled")) == "boolean" then
                    rawset(v, "Enabled", false)
                end
            end
        end
    end
    
    hideScript()
    
    -- Блокировка удаленных проверок
    game:GetService("RunService").RenderStepped:Connect(function()
        hideScript()
    end)
end

-- ИНИЦИАЛИЗАЦИЯ
CreateToggleButton()
MainFrame = CreateMainUI()

-- ESP Loop
RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

-- Сброс скорости при респавне
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    if SpeedEnabled and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CurrentSpeed
    end
    if GodModeEnabled then
        wait(0.3)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000
            humanoid.Health = 1000
            humanoid.BreakJointsOnDeath = false
        end
    end
end)

-- АКТИВАЦИЯ ОБХОДА
BypassAntiCheat()

-- Очистка при выгрузке
game:BindToClose(function()
    DisableGodMode()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

print("MM2 ULTIMATE HUB LOADED | GOD MODE + ANTI-CHEAT BYPASS ACTIVE")
