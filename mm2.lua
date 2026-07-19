-- MM2 ULTIMATE HUB [FULL + HITBOX + 3 NEW FUNCTIONS]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local mouse = player:GetMouse()

for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name == "MM2UltimateHub" then
        v:Destroy()
    end
end

local silentAimEnabled = false
local invisibilityEnabled = false
local hitboxEnabled = false
local hitboxSize = 1
local shootButton = nil
local shootButtonDragging = false
local shootButtonDragStart = nil
local shootButtonDragOffset = nil
local invisibleParts = {}
local espHighlights = {}
local espUpdateConnection = nil
local espMurderEnabled = false
local espSheriffEnabled = false
local hitboxConnections = {}
local hitboxObjects = {}
local autoKnifeEnabled = false
local autoKnifeConnection = nil
local instantRespawnEnabled = false
local instantRespawnConnection = nil
local antiAfkEnabled = false
local antiAfkConnection = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2UltimateHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 600, 0, 400)
window.Position = UDim2.new(0.5, -300, 0.5, -200)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
window.BackgroundTransparency = 0
window.BorderSizePixel = 0
window.Parent = screenGui
window.Visible = true
window.Active = true
window.Selectable = false

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent = window

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -120, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Text = "⚡ MM2 Ultimate Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local dragging = false
local dragStart = nil
local dragOffset = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        dragOffset = window.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(dragOffset.X.Scale, dragOffset.X.Offset + delta.X, dragOffset.Y.Scale, dragOffset.Y.Offset + delta.Y)
    end
end)

local function createTitleButton(text, x, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 35)
    btn.Position = UDim2.new(1, x, 0, 2)
    btn.Text = text
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 50)
    btn.BorderSizePixel = 0
    btn.Parent = titleBar
    btn.Selectable = false
    return btn
end

local minBtn = createTitleButton("─", -105)
local closeBtn = createTitleButton("✕", -40)

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Text = "⚡"
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui
toggleBtn.Visible = true
toggleBtn.Selectable = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
content.BorderSizePixel = 0
content.Parent = window

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 85)
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = content

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

local yPos = 5
local function addSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 28)
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(160, 160, 220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = canvas
    yPos = yPos + 33
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return lbl
end

local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Parent = canvas
    btn.Selectable = false
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 70)
        callback(state)
    end)
    yPos = yPos + 35
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return btn
end

local function addButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 85)
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Parent = canvas
    btn.Selectable = false
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    yPos = yPos + 35
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return btn
end

local function addSliderWithButtons(text, minVal, maxVal, defaultVal, callback, step)
    step = step or 1
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = canvas
    yPos = yPos + 5
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 30, 0, 30)
    minusBtn.Position = UDim2.new(0.4, 0, 0.5, -15)
    minusBtn.Text = "-"
    minusBtn.TextSize = 18
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    minusBtn.BorderSizePixel = 0
    minusBtn.Parent = container
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 6)
    minusCorner.Parent = minusBtn
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0.1, 0, 1, 0)
    valueDisplay.Position = UDim2.new(0.5, -20, 0, 0)
    valueDisplay.Text = tostring(defaultVal)
    valueDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueDisplay.TextSize = 14
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.Parent = container
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 30, 0, 30)
    plusBtn.Position = UDim2.new(0.7, 0, 0.5, -15)
    plusBtn.Text = "+"
    plusBtn.TextSize = 18
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    plusBtn.BorderSizePixel = 0
    plusBtn.Parent = container
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 6)
    plusCorner.Parent = plusBtn
    
    local value = defaultVal
    
    minusBtn.MouseButton1Click:Connect(function()
        value = math.max(value - step, minVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    plusBtn.MouseButton1Click:Connect(function()
        value = math.min(value + step, maxVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    yPos = yPos + 45
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return container
end

local function getPlayerRole(v)
    if v.Character and v.Character:FindFirstChild("Knife") then
        return "murderer"
    elseif v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun")) then
        return "sheriff"
    else
        return "innocent"
    end
end

local function updateHitboxes(state)
    hitboxEnabled = state
    
    for _, obj in pairs(hitboxObjects) do
        pcall(function() obj:Destroy() end)
    end
    hitboxObjects = {}
    for _, con in pairs(hitboxConnections) do
        pcall(function() con:Disconnect() end)
    end
    hitboxConnections = {}
    
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = v.Character.HumanoidRootPart
                local hitboxPart = Instance.new("Part")
                hitboxPart.Size = Vector3.new(4 * hitboxSize, 6 * hitboxSize, 3 * hitboxSize)
                hitboxPart.Transparency = 1
                hitboxPart.CanCollide = false
                hitboxPart.Anchored = true
                hitboxPart.Parent = v.Character
                
                local weld = Instance.new("Weld")
                weld.Part0 = rootPart
                weld.Part1 = hitboxPart
                weld.C0 = CFrame.new(0, 0, 0)
                weld.Parent = hitboxPart
                
                table.insert(hitboxObjects, hitboxPart)
                
                local con = RunService.Heartbeat:Connect(function()
                    if hitboxPart and rootPart and hitboxPart.Parent then
                        hitboxPart.Position = rootPart.Position
                        hitboxPart.Size = Vector3.new(4 * hitboxSize, 6 * hitboxSize, 3 * hitboxSize)
                    end
                end)
                table.insert(hitboxConnections, con)
            end
        end
        
        local playerAddedCon = game.Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function(char)
                wait(0.5)
                if hitboxEnabled and char and char:FindFirstChild("HumanoidRootPart") then
                    local rootPart = char.HumanoidRootPart
                    local hitboxPart = Instance.new("Part")
                    hitboxPart.Size = Vector3.new(4 * hitboxSize, 6 * hitboxSize, 3 * hitboxSize)
                    hitboxPart.Transparency = 1
                    hitboxPart.CanCollide = false
                    hitboxPart.Anchored = true
                    hitboxPart.Parent = char
                    
                    local weld = Instance.new("Weld")
                    weld.Part0 = rootPart
                    weld.Part1 = hitboxPart
                    weld.C0 = CFrame.new(0, 0, 0)
                    weld.Parent = hitboxPart
                    
                    table.insert(hitboxObjects, hitboxPart)
                end
            end)
        end)
        table.insert(hitboxConnections, playerAddedCon)
    end
end

local function updateHitboxSize(value)
    hitboxSize = value
    if hitboxEnabled then
        for _, part in pairs(hitboxObjects) do
            if part and part.Parent then
                part.Size = Vector3.new(4 * value, 6 * value, 3 * value)
            end
        end
    end
end

local function updateAutoKnife(state)
    if autoKnifeConnection then
        autoKnifeConnection:Disconnect()
        autoKnifeConnection = nil
    end
    autoKnifeEnabled = state
    if state then
        autoKnifeConnection = RunService.Heartbeat:Connect(function()
            if autoKnifeEnabled and character then
                local knife = character:FindFirstChild("Knife")
                if knife then
                    local target = nil
                    local dist = math.huge
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist and d < 15 then
                                dist = d
                                target = v
                            end
                        end
                    end
                    if target then
                        pcall(function()
                            local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                            if mm2 and mm2:FindFirstChild("Knife") then
                                mm2.Knife:FireServer(target.Character.HumanoidRootPart)
                            end
                        end)
                    end
                end
            end
        end)
    end
end

local function updateInstantRespawn(state)
    if instantRespawnConnection then
        instantRespawnConnection:Disconnect()
        instantRespawnConnection = nil
    end
    instantRespawnEnabled = state
    if state then
        instantRespawnConnection = RunService.Heartbeat:Connect(function()
            if instantRespawnEnabled then
                if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
                    for _, v in pairs(player.PlayerGui:GetDescendants()) do
                        if v:IsA("TextButton") and (v.Name:lower():find("respawn") or v.Text:lower():find("respawn")) then
                            pcall(function() v:Click() end)
                            break
                        end
                    end
                    pcall(function()
                        local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if mm2 and mm2:FindFirstChild("Respawn") then
                            mm2.Respawn:FireServer()
                        end
                    end)
                end
            end
        end)
    end
end

local function updateAntiAfk(state)
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    antiAfkEnabled = state
    if state then
        antiAfkConnection = RunService.Heartbeat:Connect(function()
            if antiAfkEnabled and character and humanoid then
                local currentPos = root.Position
                local offset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                root.CFrame = root.CFrame + offset
                wait(0.1)
                root.CFrame = CFrame.new(currentPos)
            end
        end)
    end
end

local function updateInvisibility(state)
    invisibilityEnabled = state
    
    if state then
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    table.insert(invisibleParts, part)
                end
            end
        end
        if root then
            root.CanCollide = false
        end
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end
        if humanoid then
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
    else
        for _, part in ipairs(invisibleParts) do
            pcall(function()
                if part and part.Parent then
                    part.Transparency = 0
                    part.CastShadow = true
                end
            end)
        end
        invisibleParts = {}
        if root then
            root.CanCollide = true
        end
        if humanoid then
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end
    end
end

local function createShootButton()
    if shootButton then
        shootButton:Destroy()
        shootButton = nil
    end
    
    shootButton = Instance.new("TextButton")
    shootButton.Size = UDim2.new(0, 80, 0, 80)
    shootButton.Position = UDim2.new(0.8, -40, 0.6, -40)
    shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    shootButton.Text = "🔫\nSHOOT"
    shootButton.TextSize = 14
    shootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shootButton.BorderSizePixel = 3
    shootButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    shootButton.Parent = screenGui
    shootButton.Visible = false
    shootButton.ZIndex = 999
    shootButton.Selectable = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = shootButton
    
    shootButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            shootButtonDragging = true
            shootButtonDragStart = input.Position
            shootButtonDragOffset = shootButton.Position
        end
    end)
    
    shootButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            shootButtonDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if shootButtonDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - shootButtonDragStart
            shootButton.Position = UDim2.new(shootButtonDragOffset.X.Scale, shootButtonDragOffset.X.Offset + delta.X, 
                                             shootButtonDragOffset.Y.Scale, shootButtonDragOffset.Y.Offset + delta.Y)
        end
    end)
    
    shootButton.MouseButton1Click:Connect(function()
        if not silentAimEnabled then return end
        
        local target = nil
        local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if getPlayerRole(v) == "murderer" then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = v
                    end
                end
            end
        end
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local oldCFrame = Camera.CFrame
            
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            local success = false
            local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            
            if mm2 then
                local remoteNames = {"Gun", "Shoot", "Fire", "GunRemote", "ShootRemote"}
                for _, name in ipairs(remoteNames) do
                    local remote = mm2:FindFirstChild(name)
                    if remote then
                        pcall(function()
                            remote:FireServer(target.Character.HumanoidRootPart)
                            success = true
                        end)
                        if success then break end
                    end
                end
                
                if not success then
                    pcall(function()
                        for _, remote in pairs(mm2:GetChildren()) do
                            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                                pcall(function()
                                    remote:FireServer(target.Character)
                                    success = true
                                end)
                                if success then break end
                            end
                        end
                    end)
                end
            end
            
            Camera.CFrame = oldCFrame
            
            if success then
                shootButton.BackgroundColor3 = Color3.fromRGB(0, 255, 50)
                wait(0.1)
                shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            else
                shootButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                wait(0.1)
                shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            end
        else
            shootButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            wait(0.1)
            shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        end
    end)
end

local function updateSilentAim(state)
    silentAimEnabled = state
    if state then
        if not shootButton then
            createShootButton()
        end
        shootButton.Visible = true
    else
        if shootButton then
            shootButton.Visible = false
        end
    end
end

local function updateESPContinuous()
    if espUpdateConnection then
        espUpdateConnection:Disconnect()
        espUpdateConnection = nil
    end
    
    espUpdateConnection = RunService.RenderStepped:Connect(function()
        for _, hl in pairs(espHighlights) do
            pcall(function() hl:Destroy() end)
        end
        espHighlights = {}
        
        if espMurderEnabled or espSheriffEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local role = getPlayerRole(v)
                    local color = nil
                    
                    if espMurderEnabled and role == "murderer" then
                        color = Color3.fromRGB(255, 0, 0)
                    elseif espSheriffEnabled and role == "sheriff" then
                        color = Color3.fromRGB(0, 100, 255)
                    end
                    
                    if color then
                        local hl = Instance.new("Highlight")
                        hl.Parent = v.Character
                        hl.Adornee = v.Character
                        hl.FillColor = color
                        hl.FillTransparency = 0.3
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.OutlineTransparency = 0.1
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        espHighlights[v] = hl
                        
                        local rootPart = v.Character.HumanoidRootPart
                        if rootPart then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Size = Vector3.new(4, 6, 3)
                            box.Adornee = rootPart
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Color3 = color
                            box.Transparency = 0.5
                            box.Parent = rootPart
                            table.insert(espHighlights, box)
                        end
                    end
                end
            end
        end
    end)
end

local noclipEnabled = false
local autoGrabEnabled = false
local autoCollectEnabled = false
local infJumpEnabled = false
local antiFlingEnabled = false
local flingMurdererEnabled = false
local flingSheriffEnabled = false
local noclipConnection = nil
local autoGrabConnection = nil
local autoCollectConnection = nil
local infJumpConnection = nil
local antiFlingConnection = nil
local flingMurdererConnection = nil
local flingSheriffConnection = nil
local speedValue = 16
local lastPosition = nil

local function updateInfJump(state)
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
    infJumpEnabled = state
    if state then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            if infJumpEnabled and character and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

local function updateNoclip(state)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    noclipEnabled = state
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if noclipEnabled and character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function updateAntiFling(state)
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
    antiFlingEnabled = state
    if state then
        lastPosition = root.Position
        antiFlingConnection = RunService.Heartbeat:Connect(function()
            if antiFlingEnabled and root and character then
                local currentPos = root.Position
                
                if currentPos.Y < -50 then
                    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
                    if spawn then
                        root.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
                    else
                        root.CFrame = CFrame.new(0, 50, 0)
                    end
                    return
                end
                
                if lastPosition then
                    local distance = (currentPos - lastPosition).Magnitude
                    if distance > 50 and distance < 500 then
                        root.CFrame = CFrame.new(lastPosition)
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
                
                lastPosition = currentPos
            end
        end)
    else
        lastPosition = nil
    end
end

local function updateAutoGrab(state)
    if autoGrabConnection then
        autoGrabConnection:Disconnect()
        autoGrabConnection = nil
    end
    autoGrabEnabled = state
    if state then
        autoGrabConnection = RunService.Heartbeat:Connect(function()
            if autoGrabEnabled and root then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                        local dist = (root.Position - v.Position).Magnitude
                        if dist < 200 then
                            local oldPos = root.CFrame
                            root.CFrame = v.CFrame * CFrame.new(0, 1, 0)
                            wait(0.01)
                            pcall(function()
                                local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                if mm2 and mm2:FindFirstChild("Knife") then
                                    mm2.Knife:FireServer(v.Parent)
                                end
                            end)
                            root.CFrame = oldPos
                            break
                        end
                    end
                end
            end
        end)
    end
end

local function updateAutoCollect(state)
    if autoCollectConnection then
        autoCollectConnection:Disconnect()
        autoCollectConnection = nil
    end
    autoCollectEnabled = state
    if state then
        autoCollectConnection = RunService.Heartbeat:Connect(function()
            if autoCollectEnabled and root then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Coin" and v.Parent and v.Parent:IsA("Model") then
                        local dist = (root.Position - v.Position).Magnitude
                        if dist < 200 then
                            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                            wait(0.05)
                            break
                        end
                    end
                end
            end
        end)
    end
end

local function updateFlingMurderer(state)
    if flingMurdererConnection then
        flingMurdererConnection:Disconnect()
        flingMurdererConnection = nil
    end
    flingMurdererEnabled = state
    if state then
        flingMurdererConnection = RunService.Heartbeat:Connect(function()
            if flingMurdererEnabled then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if getPlayerRole(v) == "murderer" then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Velocity = Vector3.new(math.random(-500, 500), 500, math.random(-500, 500))
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
                        end
                    end
                end
            end
        end)
    end
end

local function updateFlingSheriff(state)
    if flingSheriffConnection then
        flingSheriffConnection:Disconnect()
        flingSheriffConnection = nil
    end
    flingSheriffEnabled = state
    if state then
        flingSheriffConnection = RunService.Heartbeat:Connect(function()
            if flingSheriffEnabled then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if getPlayerRole(v) == "sheriff" then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Velocity = Vector3.new(math.random(-500, 500), 500, math.random(-500, 500))
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
                        end
                    end
                end
            end
        end)
    end
end

local function updateSpeed(value)
    speedValue = value
    if humanoid then
        humanoid.WalkSpeed = value
    end
end

local function teleportToSpawn()
    local spawns = workspace:GetDescendants()
    for _, v in ipairs(spawns) do
        if v:IsA("SpawnLocation") then
            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
            return
        end
    end
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn then root.CFrame = spawn.CFrame * CFrame.new(0, 2, 0) end
end

local function teleportToMurderer()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "murderer" then
            root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            return
        end
    end
end

local function teleportToSheriff()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "sheriff" then
            root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            return
        end
    end
end

addSection("════ MAIN ════")
addToggle("No Clip", updateNoclip)
addToggle("Auto Grab Gun", updateAutoGrab)
addToggle("INF Jump", updateInfJump)

addSection("═══ COMBAT ═══")
addToggle("Silent Aim (Shoot Button)", updateSilentAim)
addToggle("Auto Knife", updateAutoKnife)
addSliderWithButtons("Hitbox Size", 0.5, 5, 1, updateHitboxSize, 0.1)
addToggle("Hitbox (Enable)", updateHitboxes)

addSection("═══ STEALTH ═══")
addToggle("Invisibility (Not Visible)", updateInvisibility)

addSection("═══ PROTECTION ═══")
addToggle("Anti Fling / Anti Fall", updateAntiFling)
addToggle("Instant Respawn", updateInstantRespawn)

addSection("═══ VISUAL ═══")
addToggle("ESP Murder (Red)", function(state) espMurderEnabled = state; updateESPContinuous() end)
addToggle("ESP Sheriff (Blue)", function(state) espSheriffEnabled = state; updateESPContinuous() end)

addSection("═══ FLING ═══")
addToggle("Fling Murderer", updateFlingMurderer)
addToggle("Fling Sheriff", updateFlingSheriff)

addSection("═══ AUTO COLLECT ═══")
addToggle("Auto Collect Coins", updateAutoCollect)

addSection("═══ TELEPORT ═══")
addButton("To Lobby", Color3.fromRGB(40, 60, 90), teleportToSpawn)
addButton("To Murderer", Color3.fromRGB(90, 40, 40), teleportToMurderer)
addButton("To Sheriff", Color3.fromRGB(40, 40, 90), teleportToSheriff)

addSection("═══ EXTRA ═══")
addSliderWithButtons("Speed Boost", 16, 120, 16, updateSpeed, 2)
addToggle("Anti AFK", updateAntiAfk)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    window.Visible = false
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if speedValue then
        humanoid.WalkSpeed = speedValue
    end
    if noclipEnabled then
        updateNoclip(true)
    end
    if espMurderEnabled or espSheriffEnabled then
        wait(0.5)
        updateESPContinuous()
    end
end)

local function bypassAntiCheat()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            local args = {...}
            local argsStr = tostring(args[1]) or ""
            if argsStr:find("AntiCheat") or argsStr:find("Check") or argsStr:find("Report") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
end
bypassAntiCheat()

print("⚡ MM2 Ultimate Hub loaded!")
