-- Deobfuscated FurdjeHub v1.0.0
-- Полная версия

local FurdjeHub = {
    Flags = {
        AutoFarm = false,
        AutoClick = false,
        SpeedHack = false,
        Fly = false,
        NoClip = false,
        ESP = false,
        Aimbot = false,
        Teleport = false
    },
    Settings = {
        WindowTitle = "Furdje Hub",
        WindowSubTitle = "v1.0.0",
        Key = "FURDJE2025",
        SaveKey = "FurdjeHub_Settings",
        SpeedValue = 50,
        JumpPower = 50,
        WalkSpeed = 16
    },
    Libraries = {},
    Functions = {}
}

-- Функция для сохранения настроек
function FurdjeFunctions.SaveSettings()
    local data = {}
    for k, v in pairs(FurdjeHub.Flags) do
        data[k] = v
    end
    data.SpeedValue = FurdjeHub.Settings.SpeedValue
    data.JumpPower = FurdjeHub.Settings.JumpPower
    data.WalkSpeed = FurdjeHub.Settings.WalkSpeed
    setclipboard(game:GetService("HttpService"):JSONEncode(data))
end

-- Функция загрузки настроек
function FurdjeFunctions.LoadSettings()
    local clipboard = getclipboard()
    if clipboard ~= "" then
        local data = game:GetService("HttpService"):JSONDecode(clipboard)
        for k, v in pairs(data) do
            if FurdjeHub.Flags[k] ~= nil then
                FurdjeHub.Flags[k] = v
            end
        end
        FurdjeHub.Settings.SpeedValue = data.SpeedValue or 50
        FurdjeHub.Settings.JumpPower = data.JumpPower or 50
        FurdjeHub.Settings.WalkSpeed = data.WalkSpeed or 16
    end
end

-- AutoFarm
function FurdjeFunctions.AutoFarm()
    while FurdjeHub.Flags.AutoFarm do
        local players = game:GetService("Players")
        local localPlayer = players.LocalPlayer
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= character then
                    local target = v.Humanoid
                    if target.Health > 0 then
                        humanoid:MoveTo(target.Parent.HumanoidRootPart.Position)
                        wait(0.2)
                        -- attack
                        local tool = localPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if tool then
                            tool.Parent = character
                            tool:Activate()
                            wait(0.1)
                            tool.Parent = localPlayer.Backpack
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end

-- AutoClick
function FurdjeFunctions.AutoClick()
    while FurdjeHub.Flags.AutoClick do
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        mouse.Button1Down:Fire()
        wait(0.05)
        mouse.Button1Up:Fire()
        wait(0.1)
    end
end

-- SpeedHack
function FurdjeFunctions.SpeedHack()
    while FurdjeHub.Flags.SpeedHack do
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            humanoid.WalkSpeed = FurdjeHub.Settings.WalkSpeed + FurdjeHub.Settings.SpeedValue
            humanoid.JumpPower = FurdjeHub.Settings.JumpPower
        end
        wait(0.5)
    end
end

-- Fly
function FurdjeFunctions.Fly()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local flySpeed = 50
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e4, 9e4, 9e4)
    bodyGyro.CFrame = root.CFrame
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    bodyGyro.Parent = root
    bodyVelocity.Parent = root

    local mouse = player:GetMouse()
    mouse.KeyDown:Connect(function(key)
        if key == "e" then
            FurdjeHub.Flags.Fly = not FurdjeHub.Flags.Fly
        end
    end)

    while FurdjeHub.Flags.Fly do
        local move = Vector3.new()
        if mouse then
            local direction = mouse.Hit.lookVector
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                move = move + direction
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                move = move - direction
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                move = move - direction:Cross(Vector3.new(0, 1, 0))
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                move = move + direction:Cross(Vector3.new(0, 1, 0))
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0, 1, 0)
            end
        end
        bodyVelocity.Velocity = move * flySpeed
        bodyGyro.CFrame = CFrame.new(root.Position, root.Position + move)
        wait()
    end
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
end

-- NoClip
function FurdjeFunctions.NoClip()
    while FurdjeHub.Flags.NoClip do
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end

-- ESP (Wallhack)
function FurdjeFunctions.ESP()
    while FurdjeHub.Flags.ESP do
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(4, 6, 2)
                    box.Color3 = Color3.new(1, 0, 0)
                    box.Transparency = 0.5
                    box.ZIndex = 10
                    box.AlwaysOnTop = true
                    box.Parent = root
                    wait(0.5)
                    box:Destroy()
                end
            end
        end
        wait(0.1)
    end
end

-- Teleport to player
function FurdjeFunctions.TeleportToPlayer(targetName)
    local players = game:GetService("Players")
    local target = players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local localPlayer = players.LocalPlayer
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

-- Aimbot
function FurdjeFunctions.Aimbot()
    while FurdjeHub.Flags.Aimbot do
        local players = game:GetService("Players")
        local localPlayer = players.LocalPlayer
        local mouse = localPlayer:GetMouse()
        local closest = nil
        local closestDist = math.huge
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = root
                    end
                end
            end
        end
        if closest then
            mouse.Move:Fire(closest.Position)
        end
        wait(0.1)
    end
end

-- Создание GUI
function FurdjeFunctions.CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FurdjeHub"
    screenGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    title.Text = FurdjeHub.Settings.WindowTitle
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, -30)
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    local yOffset = 10
    local function AddToggle(text, flag, defaultValue)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 30)
        toggleFrame.Position = UDim2.new(0, 10, 0, yOffset)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = tabFrame

        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.TextScaled = true
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 1, 0)
        toggleBtn.Position = UDim2.new(1, -50, 0, 0)
        toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleBtn.Text = defaultValue and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextScaled = true
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Parent = toggleFrame

        FurdjeHub.Flags[flag] = defaultValue

        toggleBtn.MouseButton1Click:Connect(function()
            FurdjeHub.Flags[flag] = not FurdjeHub.Flags[flag]
            toggleBtn.BackgroundColor3 = FurdjeHub.Flags[flag] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            toggleBtn.Text = FurdjeHub.Flags[flag] and "ON" or "OFF"
        end)

        yOffset = yOffset + 35
    end

    local function AddSlider(text, flag, min, max, default)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        sliderFrame.Position = UDim2.new(0, 10, 0, yOffset)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = tabFrame

        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text .. ": " .. tostring(default)
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.TextScaled = true
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Parent = sliderFrame

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 20)
        slider.Position = UDim2.new(0, 0, 0, 25)
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        slider.Parent = sliderFrame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        fill.Parent = slider

        FurdjeHub.Settings[flag] = default

        local dragging = false
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local sliderPos = slider.AbsolutePosition.X
                local sliderWidth = slider.AbsoluteSize.X
                local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                local value = math.floor(min + percent * (max - min))
                fill.Size = UDim2.new(percent, 0, 1, 0)
                FurdjeHub.Settings[flag] = value
                sliderLabel.Text = text .. ": " .. tostring(value)
            end
        end)

        yOffset = yOffset + 60
    end

    local function AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabFrame
        btn.MouseButton1Click:Connect(callback)
        yOffset = yOffset + 35
    end

    -- Добавляем элементы UI
    AddToggle("Auto Farm", "AutoFarm", false)
    AddToggle("Auto Click", "AutoClick", false)
    AddToggle("Speed Hack", "SpeedHack", false)
    AddToggle("Fly (E to toggle)", "Fly", false)
    AddToggle("NoClip", "NoClip", false)
    AddToggle("ESP", "ESP", false)
    AddToggle("Aimbot", "Aimbot", false)

    AddSlider("Speed Value", "SpeedValue", 10, 200, 50)
    AddSlider("Jump Power", "JumpPower", 10, 200, 50)
    AddSlider("Walk Speed", "WalkSpeed", 10, 50, 16)

    AddButton("Save Settings", function()
        FurdjeFunctions.SaveSettings()
    end)

    AddButton("Load Settings", function()
        FurdjeFunctions.LoadSettings()
        -- Обновляем UI после загрузки
        for _, child in pairs(tabFrame:GetChildren()) do
            child:Destroy()
        end
        yOffset = 10
        -- Пересоздаём UI (упрощённо, но в реальном коде лучше обновлять значения)
        -- Для простоты используем перезапуск GUI
        screenGui:Destroy()
        FurdjeFunctions.CreateUI()
    end)

    AddButton("Teleport to Player", function()
        local playerName = game:GetService("Players").LocalPlayer:GetMouse().Target.Parent.Name
        if playerName then
            FurdjeFunctions.TeleportToPlayer(playerName)
        end
    end)
end

-- Инициализация
function FurdjeFunctions.Init()
    -- Проверка на уже существующее GUI
    if game:GetService("CoreGui"):FindFirstChild("FurdjeHub") then
        game:GetService("CoreGui"):FindFirstChild("FurdjeHub"):Destroy()
    end

    FurdjeFunctions.CreateUI()

    -- Запуск потоков
    spawn(FurdjeFunctions.AutoFarm)
    spawn(FurdjeFunctions.AutoClick)
    spawn(FurdjeFunctions.SpeedHack)
    spawn(FurdjeFunctions.Fly)
    spawn(FurdjeFunctions.NoClip)
    spawn(FurdjeFunctions.ESP)
    spawn(FurdjeFunctions.Aimbot)

    print("FurdjeHub v1.0.0 loaded successfully!")
end

-- Запуск
FurdjeFunctions.Init()            mouse.Button1Up:Fire()
            task.wait(0.1)
        end
    end)

    spawn(function()
        while Flags.SpeedHack do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                hum.WalkSpeed = Settings.WalkSpeed + Settings.SpeedValue
                hum.JumpPower = Settings.JumpPower
            end
            task.wait(0.5)
        end
    end)

    local flyBV, flyBG, flyLoop
    local function toggleManualFly(state)
        Flags.Fly = state
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Flags.Fly then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(8999999488, 8999999488, 8999999488)
            flyBV.Parent = hrp
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(8999999488, 8999999488, 8999999488)
            flyBG.P = 90000
            flyBG.Parent = hrp
            if hum then hum.PlatformStand = true end
            flyLoop = RunService.RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                if not hum or not hrp then return end
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude == 0 then
                    local kbDir = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then kbDir = kbDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then kbDir = kbDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then kbDir = kbDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then kbDir = kbDir + cam.CFrame.RightVector end
                    if kbDir.Magnitude > 0 then moveDir = kbDir.Unit end
                end
                if moveDir.Magnitude > 0 then
                    flyBV.Velocity = moveDir * Settings.FlySpeed
                else
                    flyBV.Velocity = Vector3.new(0,0,0)
                end
                flyBG.CFrame = cam.CFrame
            end)
        else
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            if flyLoop then flyLoop:Disconnect() end
            if hum then hum.PlatformStand = false end
        end
    end

    spawn(function()
        while Flags.NoClip do
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            task.wait(0.1)
        end
    end)

    spawn(function()
        while Flags.ESP do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = Vector3.new(4, 6, 2)
                        box.Color3 = Color3.new(1, 0, 0)
                        box.Transparency = 0.5
                        box.ZIndex = 10
                        box.AlwaysOnTop = true
                        box.Parent = root
                        task.wait(0.5)
                        box:Destroy()
                    end
                end
            end
            task.wait(0.1)
        end
    end)

    spawn(function()
        while Flags.Aimbot do
            local mouse = LocalPlayer:GetMouse()
            local closest = nil
            local closestDist = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = root
                        end
                    end
                end
            end
            if closest then
                mouse.Move:Fire(closest.Position)
            end
            task.wait(0.1)
        end
    end)

    -- ===== GUI первого скрипта (без выбора языка) =====
    local UI_SCALE = 0.8
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FurdjeHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Тень
    local ShadowFrame = Instance.new("Frame")
    ShadowFrame.Name = "ShadowFrame"
    ShadowFrame.Parent = ScreenGui
    ShadowFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ShadowFrame.AnchorPoint = Vector2.new(0.5,0.5)
    ShadowFrame.Position = UDim2.new(0.5,4,0.5,6)
    ShadowFrame.Size = UDim2.new(0,646,0,426)
    ShadowFrame.BackgroundTransparency = 0.45
    ShadowFrame.Visible = false
    Instance.new("UICorner",ShadowFrame).CornerRadius = UDim.new(0,16)

    local ShadowScale = Instance.new("UIScale",ShadowFrame)
    ShadowScale.Scale = 0.3

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(11,11,16)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
    MainFrame.Position = UDim2.new(0.5,0,0.5,0)
    MainFrame.Size = UDim2.new(0,640,0,420)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Visible = false
    Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,14)

    -- Фон
    local BgImage = Instance.new("ImageLabel")
    BgImage.Name = "BackgroundImage"
    BgImage.Parent = MainFrame
    BgImage.BackgroundTransparency = 1
    BgImage.Size = UDim2.new(1,0,1,0)
    BgImage.Image = "rbxassetid://121149051147413"
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.ImageTransparency = 0.35
    BgImage.ZIndex = 0
    Instance.new("UICorner",BgImage).CornerRadius = UDim.new(0,14)

    local MainScale = Instance.new("UIScale",MainFrame)
    MainScale.Scale = 0.3

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Rotation = 90
    MainGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,0.5)})
    MainGradient.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(35,35,50)
    MainStroke.Thickness = 1.5

    local isMenuOpen = false
    local isMinimized = false
    local function toggleMenu(forceState)
        if forceState ~= nil then isMenuOpen = forceState else isMenuOpen = not isMenuOpen end
        if isMenuOpen then
            MainFrame.Visible = true
            if not isMinimized then ShadowFrame.Visible = true end
            TweenService:Create(MainScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale = UI_SCALE}):Play()
            TweenService:Create(ShadowScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale = UI_SCALE}):Play()
        else
            local closeTween = TweenService:Create(MainScale,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale = 0.2})
            TweenService:Create(ShadowScale,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale = 0.2}):Play()
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not isMenuOpen then MainFrame.Visible = false; ShadowFrame.Visible = false end
            end)
        end
    end

    -- Кнопка появления
    local ToggleWidget = Instance.new("Frame")
    ToggleWidget.Name = "ToggleWidget"
    ToggleWidget.Parent = ScreenGui
    ToggleWidget.BackgroundColor3 = Color3.fromRGB(15,15,22)
    ToggleWidget.BackgroundTransparency = 0.15
    ToggleWidget.Position = UDim2.new(0.5, -80,0.08,0)
    ToggleWidget.Size = UDim2.new(0,160,0,44)
    ToggleWidget.Visible = false
    Instance.new("UICorner",ToggleWidget).CornerRadius = UDim.new(0,10)

    local ToggleScale = Instance.new("UIScale",ToggleWidget)
    ToggleScale.Scale = 0.85

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Parent = ToggleWidget
    ToggleStroke.Color = Color3.fromRGB(45,45,65)
    ToggleStroke.Thickness = 1.5

    local ToggleLabelText = Instance.new("TextLabel")
    ToggleLabelText.Parent = ToggleWidget
    ToggleLabelText.BackgroundTransparency = 1
    ToggleLabelText.Size = UDim2.new(1,0,1,0)
    ToggleLabelText.Font = Enum.Font.GothamBold
    ToggleLabelText.Text = "FurdjeHub"
    ToggleLabelText.TextColor3 = Color3.fromRGB(255,255,255)
    ToggleLabelText.TextSize = 17

    local accentColor = Color3.fromRGB(0,150,255)
    local ToggleGradient = Instance.new("UIGradient")
    ToggleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,accentColor),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
    ToggleGradient.Parent = ToggleLabelText

    ToggleWidget.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            TweenService:Create(ToggleScale,TweenInfo.new(0.15),{Scale = 0.78}):Play()
        end
    end)
    ToggleWidget.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            TweenService:Create(ToggleScale,TweenInfo.new(0.15),{Scale = 0.85}):Play()
        end
    end)

    local dragToggle, dragInputT, dragStartT, startPosT
    local dragStartTime = 0
    ToggleWidget.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStartT = input.Position
            startPosT = ToggleWidget.Position
            dragStartTime = tick()
        end
    end)
    ToggleWidget.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragInputT = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input == dragInputT) and dragToggle then
            local delta = input.Position - dragStartT
            ToggleWidget.Position = UDim2.new(startPosT.X.Scale,startPosT.X.Offset + delta.X, startPosT.Y.Scale,startPosT.Y.Offset + delta.Y)
        end
    end)
    ToggleWidget.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = false
            if (tick() - dragStartTime) < 0.25 then toggleMenu() end
        end
    end)

    -- Перетаскивание окна
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input == dragInput) and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X, startPos.Y.Scale,startPos.Y.Offset + delta.Y)
            MainFrame.Position = targetPos
            ShadowFrame.Position = UDim2.new(targetPos.X.Scale,targetPos.X.Offset + 4, targetPos.Y.Scale,targetPos.Y.Offset + 6)
        end
    end)
    MainFrame.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)

    -- Кнопки закрытия и сворачивания
    local TopControls = Instance.new("Frame")
    TopControls.Parent = MainFrame
    TopControls.BackgroundTransparency = 1
    TopControls.Position = UDim2.new(1, -75,0,14)
    TopControls.Size = UDim2.new(0,65,0,26)
    TopControls.ZIndex = 20

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopControls
    CloseBtn.BackgroundColor3 = Color3.fromRGB(25,18,22)
    CloseBtn.Position = UDim2.new(1, -26,0,0)
    CloseBtn.Size = UDim2.new(0,26,0,26)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(250,80,80)
    CloseBtn.TextSize = 18
    Instance.new("UICorner",CloseBtn).CornerRadius = UDim.new(0,6)
    CloseBtn.MouseButton1Click:Connect(function()
        toggleMenu(false)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = TopControls
    MinBtn.BackgroundColor3 = Color3.fromRGB(18,18,26)
    MinBtn.Position = UDim2.new(1, -58,0,0)
    MinBtn.Size = UDim2.new(0,26,0,26)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(160,160,180)
    MinBtn.TextSize = 18
    Instance.new("UICorner",MinBtn).CornerRadius = UDim.new(0,6)
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{Size = UDim2.new(0,640,0,52)}):Play()
            TweenService:Create(ShadowFrame,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{Size = UDim2.new(0,646,0,58)}):Play()
            MinBtn.Text = "+"
        else
            TweenService:Create(MainFrame,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{Size = UDim2.new(0,640,0,420)}):Play()
            TweenService:Create(ShadowFrame,TweenInfo.new(0.35,Enum.EasingStyle.Quart),{Size = UDim2.new(0,646,0,426)}):Play()
            MinBtn.Text = "-"
        end
    end)

    -- Левая панель (вкладки) - убраны, т.к. в KitagawaHub одна вкладка
    -- Вместо этого используем ContentArea на всю ширину

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = false
    ContentArea.Position = UDim2.new(0, 15, 0, 55)
    ContentArea.Size = UDim2.new(1, -30, 1, -70)

    -- Одна страница со всеми элементами
    local MainPage = Instance.new("ScrollingFrame")
    MainPage.Parent = ContentArea
    MainPage.BackgroundTransparency = 1
    MainPage.Size = UDim2.new(1,0,1,0)
    MainPage.ScrollBarThickness = 4
    MainPage.CanvasSize = UDim2.new(0,0,0,0)

    local yOffset = 10

    -- Функции для создания элементов
    local function AddToggle(text, flag, default)
        local frame = Instance.new("Frame")
        frame.Parent = MainPage
        frame.BackgroundColor3 = Color3.fromRGB(20,20,28)
        frame.BackgroundTransparency = 0.15
        frame.Size = UDim2.new(1, -10, 0, 36)
        frame.Position = UDim2.new(0, 5, 0, yOffset)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Position = UDim2.new(1, -55, 0.5, -14)
        btn.Size = UDim2.new(0, 50, 0, 28)
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        Flags[flag] = default

        btn.MouseButton1Click:Connect(function()
            Flags[flag] = not Flags[flag]
            btn.BackgroundColor3 = Flags[flag] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            btn.Text = Flags[flag] and "ON" or "OFF"
        end)

        yOffset = yOffset + 42
    end

    local function AddSlider(text, flag, min, max, default)
        local frame = Instance.new("Frame")
        frame.Parent = MainPage
        frame.BackgroundColor3 = Color3.fromRGB(20,20,28)
        frame.BackgroundTransparency = 0.15
        frame.Size = UDim2.new(1, -10, 0, 54)
        frame.Position = UDim2.new(0, 5, 0, yOffset)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Font = Enum.Font.GothamSemibold
        label.Text = text .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(200,200,220)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left

        local slider = Instance.new("TextButton")
        slider.Parent = frame
        slider.BackgroundColor3 = Color3.fromRGB(40,40,55)
        slider.Position = UDim2.new(0, 10, 0, 30)
        slider.Size = UDim2.new(1, -20, 0, 14)
        slider.Text = ""
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 8)

        local fill = Instance.new("Frame")
        fill.Parent = slider
        fill.BackgroundColor3 = accentColor
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)

        Settings[flag] = default

        local draggingSlider = false
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = true
            end
        end)
        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local sliderPos = slider.AbsolutePosition.X
                local sliderWidth = slider.AbsoluteSize.X
                local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                local value = math.floor(min + percent * (max - min))
                fill.Size = UDim2.new(percent, 0, 1, 0)
                Settings[flag] = value
                label.Text = text .. ": " .. tostring(value)
            end
        end)

        yOffset = yOffset + 60
    end

    local function AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = MainPage
        btn.BackgroundColor3 = Color3.fromRGB(30,30,45)
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.Position = UDim2.new(0, 5, 0, yOffset)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
        yOffset = yOffset + 42
    end

    -- Добавляем элементы
    AddToggle("Auto Farm", "AutoFarm", false)
    AddToggle("Auto Click", "AutoClick", false)
    AddToggle("Speed Hack", "SpeedHack", false)
    AddToggle("Fly (E to toggle)", "Fly", false)
    AddToggle("NoClip", "NoClip", false)
    AddToggle("ESP", "ESP", false)
    AddToggle("Aimbot", "Aimbot", false)

    AddSlider("Speed Value", "SpeedValue", 10, 200, 50)
    AddSlider("Jump Power", "JumpPower", 10, 200, 50)
    AddSlider("Walk Speed", "WalkSpeed", 10, 50, 16)

    AddButton("Save Settings", SaveSettings)
    AddButton("Load Settings", function()
        LoadSettings()
        -- Обновить UI можно перезапуском
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Terfiscript1/KitagawaHub/refs/heads/main/kitagawahub"))()
    end)
    AddButton("Teleport to Player", function()
        local playerName = LocalPlayer:GetMouse().Target and LocalPlayer:GetMouse().Target.Parent and LocalPlayer:GetMouse().Target.Parent.Name
        if playerName then
            TeleportToPlayer(playerName)
        end
    end)

    -- Обновляем CanvasSize
    MainPage.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)

    -- Показываем GUI
    task.wait(0.5)
    ToggleWidget.Visible = true
    toggleMenu(true)
end
