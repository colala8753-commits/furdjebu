-- MM2 ULTIMATE HUB [Windows 10 Style]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Переменные
local ESPEnabled = false
local SpeedEnabled = false
local CurrentSpeed = 16
local AutoGrabEnabled = false
local GodModeEnabled = false
local NoClipEnabled = false
local FlyEnabled = false
local isUIOpen = false
local godModeConnections = {}
local flySpeed = 50

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Функция создания кнопки на панели задач
local function CreateTaskbarButton()
    local button = Instance.new("ImageButton")
    button.Name = "TaskbarButton"
    button.Size = UDim2.new(0, 45, 0, 45)
    button.Position = UDim2.new(0, 15, 0, 15)
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Image = "rbxassetid://6031091079"
    button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        isUIOpen = not isUIOpen
        MainFrame.Visible = isUIOpen
        if isUIOpen then
            MainFrame:TweenPosition(UDim2.new(0.5, -300, 0.5, -250), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end)
    
    return button
end

-- Создание главного окна в стиле Windows 10
local function CreateMainUI()
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 600, 0, 500)
    frame.Position = UDim2.new(0.5, -300, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = ScreenGui
    frame.ClipsDescendants = true
    
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.4
    shadow.BorderSizePixel = 0
    shadow.Parent = frame
    
    -- Заголовок окна
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 20, 0, 20)
    titleIcon.Position = UDim2.new(0, 10, 0.5, -10)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = "rbxassetid://6031091079"
    titleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0, 35, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "MM2 Utility Hub"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.SegoeUI
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Кнопки управления окном
    local function CreateWindowButton(x, color, text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 45, 1, 0)
        btn.Position = UDim2.new(1, -45 - x, 0, 0)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.Font = Enum.Font.SegoeUI
        btn.Parent = titleBar
        return btn
    end
    
    local closeBtn = CreateWindowButton(0, Color3.fromRGB(232, 17, 35), "✕")
    closeBtn.MouseButton1Click:Connect(function()
        isUIOpen = false
        frame.Visible = false
    end)
    
    local maxBtn = CreateWindowButton(45, Color3.fromRGB(0, 120, 215), "⬜")
    maxBtn.MouseButton1Click:Connect(function()
        frame.Size = frame.Size == UDim2.new(0, 600, 0, 500) and UDim2.new(0.8, 0, 0.8, 0) or UDim2.new(0, 600, 0, 500)
        frame.Position = frame.Size == UDim2.new(0.8, 0, 0.8, 0) and UDim2.new(0.1, 0, 0.1, 0) or UDim2.new(0.5, -300, 0.5, -250)
    end)
    
    local minBtn = CreateWindowButton(90, Color3.fromRGB(0, 120, 215), "─")
    minBtn.MouseButton1Click:Connect(function()
        frame:TweenSize(UDim2.new(0, 600, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        frame.Visible = false
        isUIOpen = false
    end)
    
    -- Табы
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = frame
    
    local tabs = {}
    local currentTab = "Main"
    
    local function CreateTabButton(name, x)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.Position = UDim2.new(0, x, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextSize = 14
        btn.Font = Enum.Font.SegoeUI
        btn.Parent = tabBar
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 3)
        line.Position = UDim2.new(0, 0, 1, -3)
        line.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        line.BackgroundTransparency = name == "Main" and 0 or 1
        line.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            currentTab = name
            for _, v in pairs(tabs) do
                v.Visible = false
            end
            for _, v in pairs(tabBar:GetChildren()) do
                if v:IsA("TextButton") and v:FindFirstChild("Line") then
                    v.Line.BackgroundTransparency = 1
                end
            end
            line.BackgroundTransparency = 0
            tabs[name].Visible = true
        end)
        
        return btn
    end
    
    CreateTabButton("Main", 10)
    CreateTabButton("ESP", 95)
    CreateTabButton("Teleport", 180)
    CreateTabButton("Settings", 265)
    
    -- Контент
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -75)
    contentFrame.Position = UDim2.new(0, 0, 0, 75)
    contentFrame.BackgroundColor3 = Color3.fromRGB(248, 248, 250)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = frame
    
    -- MAIN TAB
    local mainTab = Instance.new("Frame")
    mainTab.Size = UDim2.new(1, -20, 1, -20)
    mainTab.Position = UDim2.new(0, 10, 0, 10)
    mainTab.BackgroundTransparency = 1
    mainTab.Parent = contentFrame
    tabs["Main"] = mainTab
    
    local function CreateSwitch(labelText, yPos, defaultState)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 40)
        container.Position = UDim2.new(0, 0, 0, yPos)
        container.BackgroundTransparency = 1
        container.Parent = mainTab
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(0, 0, 0)
        label.TextSize = 14
        label.Font = Enum.Font.SegoeUI
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 60, 0, 30)
        switch.Position = UDim2.new(0.85, 0, 0.5, -15)
        switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(160, 160, 160)
        switch.BorderSizePixel = 0
        switch.Text = defaultState and "ON" or "OFF"
        switch.TextColor3 = Color3.fromRGB(255, 255, 255)
        switch.TextSize = 12
        switch.Font = Enum.Font.SegoeUI
        switch.Parent = container
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = switch
        
        local state = defaultState
        return switch, function()
            state = not state
            switch.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(160, 160, 160)
            switch.Text = state and "ON" or "OFF"
            return state
        end
    end
    
    local speedSwitch, toggleSpeed = CreateSwitch("Speed Boost", 10, false)
    local godSwitch, toggleGod = CreateSwitch("God Mode (2 Lives)", 55, false)
    local noclipSwitch, toggleNoclip = CreateSwitch("No Clip", 100, false)
    
    -- Ползунок скорости
    local speedContainer = Instance.new("Frame")
    speedContainer.Size = UDim2.new(1, 0, 0, 40)
    speedContainer.Position = UDim2.new(0, 0, 0, 145)
    speedContainer.BackgroundTransparency = 1
    speedContainer.Parent = mainTab
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.15, 0, 1, 0)
    speedLabel.Position = UDim2.new(0, 10, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.TextSize = 13
    speedLabel.Font = Enum.Font.SegoeUI
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedContainer
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(0.5, 0, 0.3, 0)
    sliderTrack.Position = UDim2.new(0.2, 0, 0.35, 0)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = speedContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((CurrentSpeed - 16) / 234, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 20, 0, 20)
    sliderBtn.Position = UDim2.new((CurrentSpeed - 16) / 234, -10, 0.5, -10)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.BorderSizePixel = 2
    sliderBtn.BorderColor3 = Color3.fromRGB(0, 120, 215)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderTrack
    
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
            sliderBtn.Position = UDim2.new(relativePos, -10, 0.5, -10)
            speedLabel.Text = "Speed: " .. tostring(CurrentSpeed)
            if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
            end
        end
    end)
    
    -- ESP TAB
    local espTab = Instance.new("Frame")
    espTab.Size = UDim2.new(1, -20, 1, -20)
    espTab.Position = UDim2.new(0, 10, 0, 10)
    espTab.BackgroundTransparency = 1
    espTab.Visible = false
    espTab.Parent = contentFrame
    tabs["ESP"] = espTab
    
    local espSwitch, toggleESP = CreateSwitch("ESP (Role Highlight)", 10, false)
    local espBoxSwitch, toggleESPBox = CreateSwitch("Show ESP Box", 55, false)
    
    -- TELEPORT TAB
    local teleTab = Instance.new("Frame")
    teleTab.Size = UDim2.new(1, -20, 1, -20)
    teleTab.Position = UDim2.new(0, 10, 0, 10)
    teleTab.BackgroundTransparency = 1
    teleTab.Visible = false
    teleTab.Parent = contentFrame
    tabs["Teleport"] = teleTab
    
    local function CreateTeleportButton(text, yPos, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.4, 0, 0, 40)
        btn.Position = UDim2.new(0.3, 0, 0, yPos)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.SegoeUI
        btn.Parent = teleTab
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn
        
        return btn
    end
    
    CreateTeleportButton("TP to Spawn", 10, Color3.fromRGB(0, 120, 215)).MouseButton1Click:Connect(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
        if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    CreateTeleportButton("TP to Gun", 60, Color3.fromRGB(200, 100, 0)).MouseButton1Click:Connect(function()
        local gun = workspace:FindFirstChild("Gun") or workspace:FindFirstChild("Pistol")
        if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    local autoGrabSwitch, toggleAutoGrab = CreateSwitch("Auto Grab Gun", 110, false)
    
    -- SETTINGS TAB
    local settingsTab = Instance.new("Frame")
    settingsTab.Size = UDim2.new(1, -20, 1, -20)
    settingsTab.Position = UDim2.new(0, 10, 0, 10)
    settingsTab.BackgroundTransparency = 1
    settingsTab.Visible = false
    settingsTab.Parent = contentFrame
    tabs["Settings"] = settingsTab
    
    local flySwitch, toggleFly = CreateSwitch("Fly Mode", 10, false)
    local flySpeedSlider = Instance.new("Frame")
    flySpeedSlider.Size = UDim2.new(1, 0, 0, 40)
    flySpeedSlider.Position = UDim2.new(0, 0, 0, 55)
    flySpeedSlider.BackgroundTransparency = 1
    flySpeedSlider.Parent = settingsTab
    
    local flyLabel = Instance.new("TextLabel")
    flyLabel.Size = UDim2.new(0.2, 0, 1, 0)
    flyLabel.Position = UDim2.new(0, 10, 0, 0)
    flyLabel.BackgroundTransparency = 1
    flyLabel.Text = "Fly Speed: 50"
    flyLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    flyLabel.TextSize = 13
    flyLabel.Font = Enum.Font.SegoeUI
    flyLabel.TextXAlignment = Enum.TextXAlignment.Left
    flyLabel.Parent = flySpeedSlider
    
    local flyTrack = Instance.new("Frame")
    flyTrack.Size = UDim2.new(0.5, 0, 0.3, 0)
    flyTrack.Position = UDim2.new(0.25, 0, 0.35, 0)
    flyTrack.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    flyTrack.BorderSizePixel = 0
    flyTrack.Parent = flySpeedSlider
    
    local flyFill = Instance.new("Frame")
    flyFill.Size = UDim2.new((flySpeed - 10) / 190, 0, 1, 0)
    flyFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    flyFill.BorderSizePixel = 0
    flyFill.Parent = flyTrack
    
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 20, 0, 20)
    flyBtn.Position = UDim2.new((flySpeed - 10) / 190, -10, 0.5, -10)
    flyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.BorderSizePixel = 2
    flyBtn.BorderColor3 = Color3.fromRGB(0, 120, 215)
    flyBtn.Text = ""
    flyBtn.Parent = flyTrack
    
    local flyDrag = false
    flyBtn.MouseButton1Down:Connect(function() flyDrag = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then flyDrag = false end
    end)
    RunService.RenderStepped:Connect(function()
        if flyDrag then
            local mousePos = Mouse.X
            local sliderPos = flyTrack.AbsolutePosition.X
            local sliderSize = flyTrack.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            flySpeed = math.floor(10 + relativePos * 190)
            flySpeed = math.clamp(flySpeed, 10, 200)
            flyFill.Size = UDim2.new(relativePos, 0, 1, 0)
            flyBtn.Position = UDim2.new(relativePos, -10, 0.5, -10)
            flyLabel.Text = "Fly Speed: " .. tostring(flySpeed)
        end
    end)
    
    -- Логика переключателей
    speedSwitch.MouseButton1Click:Connect(function()
        SpeedEnabled = toggleSpeed()
        if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
        elseif not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    godSwitch.MouseButton1Click:Connect(function()
        GodModeEnabled = toggleGod()
        if GodModeEnabled then
            EnableGodMode()
        else
            DisableGodMode()
        end
    end)
    
    noclipSwitch.MouseButton1Click:Connect(function()
        NoClipEnabled = toggleNoclip()
    end)
    
    espSwitch.MouseButton1Click:Connect(function()
        ESPEnabled = toggleESP()
    end)
    
    autoGrabSwitch.MouseButton1Click:Connect(function()
        AutoGrabEnabled = toggleAutoGrab()
        if AutoGrabEnabled then
            StartAutoGrab()
        end
    end)
    
    flySwitch.MouseButton1Click:Connect(function()
        FlyEnabled = toggleFly()
        if FlyEnabled then
            EnableFly()
        else
            DisableFly()
        end
    end)
    
    return frame
end

-- ESP
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
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(3, 5, 2)
            box.Adornee = root
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Color3 = roleColor
            box.Transparency = 0.3
            box.Parent = root
            game:GetService("Debris"):AddItem(box, 0.1)
        end
    end
end

-- Auto Grab
local function StartAutoGrab()
    spawn(function()
        while AutoGrabEnabled do
            local gun = workspace:FindFirstChild("Gun") or workspace:FindFirstChild("Pistol")
            if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                if (root.Position - gun.Position).Magnitude < 60 then
                    root.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
                    wait(0.1)
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

-- God Mode
local function EnableGodMode()
    DisableGodMode()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000
            humanoid.Health = 1000
        end
    end
    local con = LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 1000
            humanoid.Health = 1000
        end
    end)
    table.insert(godModeConnections, con)
end

local function DisableGodMode()
    for _, con in ipairs(godModeConnections) do
        con:Disconnect()
    end
    godModeConnections = {}
end

-- Fly
local function EnableFly()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = char:FindFirstChild("HumanoidRootPart")
    bodyVelocity.Name = "FlyVelocity"
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.CFrame = char.HumanoidRootPart.CFrame
    bodyGyro.Parent = char:FindFirstChild("HumanoidRootPart")
    bodyGyro.Name = "FlyGyro"
    
    local flyCon = RunService.RenderStepped:Connect(function()
        if not FlyEnabled or not LocalPlayer.Character then
            DisableFly()
            return
        end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local velocity = root:FindFirstChild("FlyVelocity")
        local gyro = root:FindFirstChild("FlyGyro")
        if velocity and gyro then
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            velocity.Velocity = moveDir.Unit * flySpeed
            gyro.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector)
        end
    end)
    table.insert(godModeConnections, flyCon)
end

local function DisableFly()
    for _, v in pairs(godModeConnections) do
        v:Disconnect()
    end
    godModeConnections = {}
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root:FindFirstChild("FlyVelocity")
            if vel then vel:Destroy() end
            local gyro = root:FindFirstChild("FlyGyro")
            if gyro then gyro:Destroy() end
        end
    end
end

-- Noclip
local noclipCon
RunService.Stepped:Connect(function()
    if NoClipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Блокировка проверок
local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and tostring(self):find("AntiCheat") then
        return nil
    end
    return oldNamecall(self, ...)
end)

-- Инициализация
CreateTaskbarButton()
MainFrame = CreateMainUI()

RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    if SpeedEnabled and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CurrentSpeed
    end
    if GodModeEnabled and char:FindFirstChild("Humanoid") then
        char.Humanoid.MaxHealth = 1000
        char.Humanoid.Health = 1000
    end
    if FlyEnabled then
        EnableFly()
    end
end)

print("MM2 Windows 10 Hub Loaded!")
