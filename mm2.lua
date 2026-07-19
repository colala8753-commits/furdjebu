-- MM2 ULTIMATE HUB [FULL FIXED - FLING + ESP + TRACKER + SPEED + AUTO GRAB]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Удаляем старые GUI
for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name == "MM2UltimateHub" then
        v:Destroy()
    end
end

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2UltimateHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно 600x400
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

-- Заголовок
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

-- Drag functionality
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

-- Кнопки управления
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

-- Кнопка открытия
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

-- Скроллинг контент
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

-- Функции создания GUI
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

-- НОВЫЙ СЛАЙДЕР С + И -
local function addSpeedSlider(text, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = canvas
    yPos = yPos + 5
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.25, 0, 1, 0)
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
        value = math.max(value - 2, minVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    plusBtn.MouseButton1Click:Connect(function()
        value = math.min(value + 2, maxVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    yPos = yPos + 45
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return container
end

-- Функция определения роли
local function getPlayerRole(v)
    if v.Character and v.Character:FindFirstChild("Knife") then
        return "murderer"
    elseif v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun")) then
        return "sheriff"
    else
        return "innocent"
    end
end

-- Переменные
local espHighlights = {}
local autoGrabConnection = nil
local noclipConnection = nil
local flingMurdererConnection = nil
local flingSheriffConnection = nil
local autoCollectConnection = nil
local infJumpConnection = nil
local playerTrackerConnection = nil
local espMurderEnabled = false
local espSheriffEnabled = false
local autoGrabEnabled = false
local noclipEnabled = false
local flingMurdererEnabled = false
local flingSheriffEnabled = false
local autoCollectEnabled = false
local infJumpEnabled = false
local playerTrackerEnabled = false
local speedValue = 16
local trackerLabels = {}
local espUpdateConnection = nil

-- ПОСТОЯННОЕ ОБНОВЛЕНИЕ ESP
local function updateESPContinuous()
    if espUpdateConnection then
        espUpdateConnection:Disconnect()
        espUpdateConnection = nil
    end
    
    espUpdateConnection = RunService.RenderStepped:Connect(function()
        -- Удаляем старые подсветки
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
                        hl.FillTransparency = 0.35
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.OutlineTransparency = 0.1
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        espHighlights[v] = hl
                    end
                end
            end
        end
    end)
end

-- INF JUMP
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

-- PLAYER TRACKER (постоянное обновление)
local function updatePlayerTracker(state)
    if playerTrackerConnection then
        playerTrackerConnection:Disconnect()
        playerTrackerConnection = nil
    end
    for _, v in pairs(trackerLabels) do
        pcall(function() v:Destroy() end)
    end
    trackerLabels = {}
    
    playerTrackerEnabled = state
    if state then
        playerTrackerConnection = RunService.RenderStepped:Connect(function()
            if not playerTrackerEnabled then return end
            
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local role = getPlayerRole(v)
                    if role == "murderer" or role == "sheriff" then
                        local rootPart = v.Character.HumanoidRootPart
                        local pos = rootPart.Position
                        local dist = (root.Position - pos).Magnitude
                        
                        if not trackerLabels[v] or not trackerLabels[v].Parent then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 200, 0, 30)
                            billboard.Adornee = rootPart
                            billboard.StudsOffset = Vector3.new(0, 4, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = rootPart
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = role == "murderer" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 100, 255)
                            label.TextSize = 16
                            label.TextStrokeTransparency = 0.3
                            label.Font = Enum.Font.GothamBold
                            label.Parent = billboard
                            
                            trackerLabels[v] = billboard
                        end
                        
                        local label = trackerLabels[v]:FindFirstChild("TextLabel")
                        if label then
                            local roleText = role == "murderer" and "🔪" or "⭐"
                            label.Text = roleText .. " " .. v.Name .. " [" .. math.floor(dist) .. "m]"
                        end
                    end
                end
            end
            
            for v, label in pairs(trackerLabels) do
                if not v.Parent or not v.Character then
                    pcall(function() label:Destroy() end)
                    trackerLabels[v] = nil
                end
            end
        end)
    end
end

-- FIXED FLING MURDERER
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

-- FIXED FLING SHERIFF
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

-- AUTO GRAB GUN (Скрытый телепорт)
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
                            -- Скрытый телепорт на 0.01 секунды
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

-- NoClip
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

-- AUTO COLLECT COINS
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

-- Speed
local function updateSpeed(value)
    speedValue = value
    if humanoid then
        humanoid.WalkSpeed = value
    end
end

-- Teleports
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

-- Обход античита MM2
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
            if type(args[1]) == "table" and rawget(args[1], "AntiCheat") then
                return nil
            end
        end
        if method == "Invoke" and tostring(self):find("AntiCheat") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
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

-- Построение GUI
addSection("════ MAIN ════")
addToggle("No Clip", updateNoclip)
addToggle("Auto Grab Gun", updateAutoGrab)
addToggle("INF Jump", updateInfJump)

addSection("═══ VISUAL ═══")
addToggle("ESP Murder (Red)", function(state) espMurderEnabled = state; updateESPContinuous() end)
addToggle("ESP Sheriff (Blue)", function(state) espSheriffEnabled = state; updateESPContinuous() end)
addToggle("Player Tracker (Distance)", updatePlayerTracker)

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
addSpeedSlider("Speed Boost", 16, 120, 16, updateSpeed)

-- Управление окном
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    window.Visible = false
end)

-- Переподключение при смене персонажа
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
        updateESPContinuous()
    end
end)

-- Активация обхода античита
bypassAntiCheat()

print("⚡ MM2 Ultimate Hub loaded! (Fling Fixed + ESP Auto-Update + Speed +/-)")
