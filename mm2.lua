-- MM2 ULTIMATE HUB [good]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ESPEnabled = true
local SpeedEnabled = false
local CurrentSpeed = 16
local AutoGrabEnabled = false
local isUIOpen = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function CreateToggleButton()
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 350)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Text = "☰"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.Parent = ScreenGui
    button.MouseButton1Click:Connect(function()
        isUIOpen = not isUIOpen
        MainFrame.Visible = isUIOpen
    end)
    return button
end

local function CreateMainUI()
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.Position = UDim2.new(0.5, -200, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = ScreenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    title.BorderSizePixel = 0
    title.Text = "MM2 Utility Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        isUIOpen = false
        frame.Visible = false
    end)

    local function CreateTab(name, yOffset)
        local tab = Instance.new("Frame")
        tab.Size = UDim2.new(1, -20, 0, 30)
        tab.Position = UDim2.new(0, 10, 0, yOffset)
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        tab.BorderSizePixel = 0
        tab.Parent = frame
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = tab
        return tab
    end

    local espTab = CreateTab("ESP Settings", 45)
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0.2, 0, 1, -4)
    espToggle.Position = UDim2.new(0.75, 0, 0, 2)
    espToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    espToggle.BorderSizePixel = 0
    espToggle.Text = "ON"
    espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    espToggle.TextSize = 12
    espToggle.Parent = espTab
    espToggle.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        espToggle.Text = ESPEnabled and "ON" or "OFF"
        espToggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    end)

    local speedTab = CreateTab("Speed Boost", 80)
    local speedToggle = Instance.new("TextButton")
    speedToggle.Size = UDim2.new(0.15, 0, 1, -4)
    speedToggle.Position = UDim2.new(0.7, 0, 0, 2)
    speedToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    speedToggle.BorderSizePixel = 0
    speedToggle.Text = "OFF"
    speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedToggle.TextSize = 12
    speedToggle.Parent = speedTab
    speedToggle.MouseButton1Click:Connect(function()
        SpeedEnabled = not SpeedEnabled
        speedToggle.Text = SpeedEnabled and "ON" or "OFF"
        speedToggle.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
        elseif not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)

    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.5, 0, 0, 25)
    speedSlider.Position = UDim2.new(0.15, 0, 0, 115)
    speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedSlider.BorderSizePixel = 0
    speedSlider.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -10, 0.3, 0)
    sliderBar.Position = UDim2.new(0, 5, 0.35, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = speedSlider

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((CurrentSpeed - 16) / 234, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 15, 0, 15)
    sliderButton.Position = UDim2.new((CurrentSpeed - 16) / 234, -7, 0.5, -7)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.2, 0, 1, 0)
    speedLabel.Position = UDim2.new(0.8, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = tostring(CurrentSpeed)
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 12
    speedLabel.Parent = speedSlider

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = Mouse.X
            local sliderPos = speedSlider.AbsolutePosition.X
            local sliderSize = speedSlider.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            CurrentSpeed = math.floor(16 + relativePos * 234)
            CurrentSpeed = math.clamp(CurrentSpeed, 16, 250)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativePos, -7, 0.5, -7)
            speedLabel.Text = tostring(CurrentSpeed)
            if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
            end
        end
    end)

    local grabTab = CreateTab("Auto Grab Gun", 145)
    local grabToggle = Instance.new("TextButton")
    grabToggle.Size = UDim2.new(0.15, 0, 1, -4)
    grabToggle.Position = UDim2.new(0.7, 0, 0, 2)
    grabToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    grabToggle.BorderSizePixel = 0
    grabToggle.Text = "OFF"
    grabToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    grabToggle.TextSize = 12
    grabToggle.Parent = grabTab
    grabToggle.MouseButton1Click:Connect(function()
        AutoGrabEnabled = not AutoGrabEnabled
        grabToggle.Text = AutoGrabEnabled and "ON" or "OFF"
        grabToggle.BackgroundColor3 = AutoGrabEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        if AutoGrabEnabled then
            StartAutoGrab()
        end
    end)

    local teleTab = CreateTab("Teleport", 190)
    local teleButton = Instance.new("TextButton")
    teleButton.Size = UDim2.new(0.4, 0, 1, -4)
    teleButton.Position = UDim2.new(0.3, 0, 0, 2)
    teleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    teleButton.BorderSizePixel = 0
    teleButton.Text = "TP to Spawn"
    teleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleButton.TextSize = 12
    teleButton.Parent = teleTab
    teleButton.MouseButton1Click:Connect(function()
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("Baseplate")
        if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
        end
    end)

    return frame
end

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
            nameTag.Size = UDim2.new(0, 100, 0, 30)
            nameTag.Adornee = root
            nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
            nameTag.Parent = root
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = roleColor
            nameLabel.TextSize = 14
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Parent = nameTag
            game:GetService("Debris"):AddItem(espBox, 0.1)
            game:GetService("Debris"):AddItem(nameTag, 0.1)
        end
    end
end

local function StartAutoGrab()
    spawn(function()
        while AutoGrabEnabled do
            local gun = workspace:FindFirstChild("Gun") or workspace:FindFirstChild("Pistol")
            if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                if (root.Position - gun.Position).Magnitude < 50 then
                    root.CFrame = CFrame.new(gun.Position + Vector3.new(0, 3, 0))
                    wait(0.1)
                    fireproximityprompt(gun)
                    wait(0.5)
                    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
                    if spawn then
                        root.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))
                    end
                end
            end
            wait(1)
        end
    end)
end

CreateToggleButton()
MainFrame = CreateMainUI()

RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    if SpeedEnabled and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CurrentSpeed
    end
end)

local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and tostring(self):find("AntiCheat") then
        return nil
    end
    return oldNamecall(self, ...)
end)
