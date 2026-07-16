-- furdjehub - Universal Hub (Delta Ready)
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "furdjehub | Universal"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

local function createButton(name, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, y, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- MM2 Script
local function loadMM2()
    screenGui:Destroy()
    loadstring([[
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local root = character:WaitForChild("HumanoidRootPart")
        local mm2 = game:GetService("ReplicatedStorage").Remotes

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "furdjehub_MM2"
        screenGui.Parent = player:WaitForChild("PlayerGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 240, 0, 420)
        frame.Position = UDim2.new(0, 10, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        frame.BackgroundTransparency = 0.2
        frame.Parent = screenGui

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "furdjehub | MM2"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1
        title.Parent = frame

        local function getMurderer()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player then
                    if v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife")) then
                        return v
                    end
                end
            end
            return nil
        end

        local shootBtn = Instance.new("TextButton")
        shootBtn.Size = UDim2.new(0.9, 0, 0, 35)
        shootBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
        shootBtn.Text = "🔫 SHOOT MURDERER"
        shootBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        shootBtn.Parent = frame

        shootBtn.MouseButton1Click:Connect(function()
            local murderer = getMurderer()
            if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                local target = murderer.Character.HumanoidRootPart
                local gun = character:FindFirstChildOfClass("Tool")
                if gun and gun.Name == "Gun" then
                    root.CFrame = CFrame.lookAt(root.Position, target.Position)
                    wait(0.05)
                    mm2.Shoot:FireServer(target)
                else
                    local gunItem = player.Backpack:FindFirstChild("Gun")
                    if gunItem then
                        gunItem.Parent = character
                        wait(0.1)
                        root.CFrame = CFrame.lookAt(root.Position, target.Position)
                        wait(0.05)
                        mm2.Shoot:FireServer(target)
                    end
                end
            end
        end)

        local autoShoot = false
        local autoBtn = Instance.new("TextButton")
        autoBtn.Size = UDim2.new(0.9, 0, 0, 35)
        autoBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
        autoBtn.Text = "AUTO-SHOOT: OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoBtn.Parent = frame

        autoBtn.MouseButton1Click:Connect(function()
            autoShoot = not autoShoot
            autoBtn.Text = autoShoot and "AUTO-SHOOT: ON" or "AUTO-SHOOT: OFF"
            autoBtn.BackgroundColor3 = autoShoot and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 50)
        end)

        game:GetService("RunService").Heartbeat:Connect(function()
            if autoShoot then
                local murderer = getMurderer()
                if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    local target = murderer.Character.HumanoidRootPart
                    local gun = character:FindFirstChildOfClass("Tool")
                    if gun and gun.Name == "Gun" then
                        root.CFrame = CFrame.lookAt(root.Position, target.Position)
                        wait(0.02)
                        mm2.Shoot:FireServer(target)
                    else
                        local gunItem = player.Backpack:FindFirstChild("Gun")
                        if gunItem then
                            gunItem.Parent = character
                            wait(0.1)
                        end
                    end
                end
            end
        end)

        game:GetService("RunService").Stepped:Connect(function()
            if character and root then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        game:GetService("UserInputService").JumpRequest:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            wait(0.02)
            root.Velocity = Vector3.new(root.Velocity.X, 60, root.Velocity.Z)
        end)

        local flying = false
        local flySpeed = 70
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F then
                flying = not flying
                humanoid.PlatformStand = flying
            end
        end)

        game:GetService("RunService").Heartbeat:Connect(function()
            if flying and root then
                local move = Vector3.new(0, 0, 0)
                local input = game:GetService("UserInputService")
                local cam = workspace.CurrentCamera
                if input:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * flySpeed end
                if input:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * flySpeed end
                if input:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector * flySpeed end
                if input:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector * flySpeed end
                if input:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, flySpeed, 0) end
                if input:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, flySpeed, 0) end
                root.Velocity = move
            end
        end)

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.Adornee = v.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = 0.3
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end

        game:GetService("RunService").Heartbeat:Connect(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") and not v:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Parent = v
                    hl.Adornee = v
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.FillTransparency = 0.2
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end)

        print("furdjehub MM2 loaded!")
    ]])()
end

-- Buttons
createButton("🔪 Murder Mystery 2", 0.15, loadMM2)
createButton("🚧 Arsenal (soon)", 0.30, function() print("Coming soon") end)
createButton("🔫 Counter Blox (soon)", 0.45, function() print("Coming soon") end)
createButton("💀 BedWars (soon)", 0.60, function() print("Coming soon") end)
createButton("❌ Close", 0.80, function() screenGui:Destroy() end)

print("furdjehub Universal loaded!")
