-- furdjehub - Murder Mystery 2 (Windows 10 Style)
-- Версия 3.0: кнопка открытия перемещаема, все хуки корректно отключаются

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

-- Хранилище всех подключений для корректного отключения
local connections = {}
local function addConnection(conn) table.insert(connections, conn) return conn end
local function clearConnections()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
end

-- Хранилище для отдельных хуков (чтобы отключать при выключении функций)
local functionHooks = {
    noclip = nil,
    fly = nil,
    autoCollect = nil,
    infiniteJump = nil,
    spin = nil,
    autoShoot = nil,
    fling = nil,
    aimbot = nil,
    gunEsp = nil,
    xray = nil
}

-- Флаги активных функций
local activeFlags = {
    noclip = false,
    fly = false,
    fling = false,
    aimbot = false,
    autoShoot = false,
    espMurder = false,
    espSheriff = false,
    gunEsp = false,
    xray = false,
    autoCollect = false,
    speedBoost = false,
    infiniteJump = false,
    superJump = false,
    spin = false
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
addConnection(screenGui.Destroying) -- для очистки при уничтожении

-- Кнопка открытия (перемещаемая)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Text = "📂"
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui
toggleBtn.Visible = true
toggleBtn.ResetOnSpawn = false

-- Перетаскивание кнопки
local toggleDragging = false
local toggleDragStart, toggleStartPos

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and toggleDragging then
        local delta = input.Position - toggleDragStart
        toggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end
end)

-- Главное окно (фиксированное, 600x400)
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 600, 0, 400)
window.Position = UDim2.new(0.5, -300, 0.5, -200)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
window.BackgroundTransparency = 0
window.BorderSizePixel = 0
window.Parent = screenGui
window.Visible = true

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.Parent = window

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "furdjehub | MM2"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 14
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Кнопки управления
local function createTitleButton(text, x, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, x, 0, 2)
    btn.Text = text
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 60)
    btn.BorderSizePixel = 0
    btn.Parent = titleBar
    return btn
end

local minBtn = createTitleButton("─", -90)
local closeBtn = createTitleButton("✕", -30)

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
end)

-- Содержимое с прокруткой
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
content.BorderSizePixel = 0
content.Parent = window

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 90)
scrollFrame.Parent = content

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

-- Вспомогательные функции построения GUI
local function addSection(text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.Parent = canvas
    local newY = y + 30
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

local function addToggle(text, y, flagKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = canvas
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 70)
        activeFlags[flagKey] = state
        callback(state)
    end)
    local newY = y + 35
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

local function addButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 80)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = canvas
    btn.MouseButton1Click:Connect(callback)
    local newY = y + 35
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

-- Определение роли
local function getPlayerRole(v)
    if v.Character and v.Character:FindFirstChild("Knife") then
        return "murderer"
    elseif v.Backpack:FindFirstChild("Gun") then
        return "sheriff"
    else
        return "innocent"
    end
end

-- Переменные для ESP и X-Ray
local espHighlights = {}
local xrayParts = {}

-- Функции обновления (с отключением старых хуков)
local function updateEspMurder(state)
    -- Очищаем старые подсветки
    for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
    espHighlights = {}
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if getPlayerRole(v) == "murderer" then
                    local hl = Instance.new("Highlight")
                    hl.Parent = v.Character
                    hl.Adornee = v.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.FillTransparency = 0.3
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    espHighlights[v] = hl
                end
            end
        end
    end
end

local function updateEspSheriff(state)
    for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
    espHighlights = {}
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if getPlayerRole(v) == "sheriff" then
                    local hl = Instance.new("Highlight")
                    hl.Parent = v.Character
                    hl.Adornee = v.Character
                    hl.FillColor = Color3.fromRGB(0, 100, 255)
                    hl.FillTransparency = 0.3
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    espHighlights[v] = hl
                end
            end
        end
    end
end

local function updateXRay(state)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                if v.Material ~= Enum.Material.Neon and v.Name ~= "Handle" then
                    xrayParts[v] = v.Transparency
                    v.Transparency = 0.6
                end
            end
        end
    else
        for v, trans in pairs(xrayParts) do
            if v and v.Parent then
                v.Transparency = trans
            end
        end
        xrayParts = {}
    end
end

local function updateNoclip(state)
    if functionHooks.noclip then
        functionHooks.noclip:Disconnect()
        functionHooks.noclip = nil
    end
    if state then
        functionHooks.noclip = addConnection(game:GetService("RunService").Stepped:Connect(function()
            if activeFlags.noclip and character and root then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end))
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

local function updateFly(state)
    if functionHooks.fly then
        functionHooks.fly:Disconnect()
        functionHooks.fly = nil
    end
    if state then
        humanoid.PlatformStand = true
        functionHooks.fly = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.fly and root then
                local move = Vector3.new(0, 0, 0)
                local input = game:GetService("UserInputService")
                local cam = workspace.CurrentCamera
                if input:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * 50 end
                if input:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * 50 end
                if input:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector * 50 end
                if input:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector * 50 end
                if input:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
                if input:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
                root.Velocity = move
            end
        end))
    else
        humanoid.PlatformStand = false
    end
end

-- Телепорты
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
            break
        end
    end
end

local function teleportToSheriff()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "sheriff" then
            root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            break
        end
    end
end

-- Функции, работающие через хуки с отключением
local function updateAutoShoot(state)
    if functionHooks.autoShoot then
        functionHooks.autoShoot:Disconnect()
        functionHooks.autoShoot = nil
    end
    if state then
        functionHooks.autoShoot = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.autoShoot then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Knife") then
                        local target = v.Character.HumanoidRootPart
                        if target then
                            local gun = character:FindFirstChildOfClass("Tool")
                            if gun and gun.Name == "Gun" then
                                root.CFrame = CFrame.lookAt(root.Position, target.Position)
                                wait(0.02)
                                mm2.Shoot:FireServer(target)
                            else
                                local gunItem = player.Backpack:FindFirstChild("Gun")
                                if gunItem then gunItem.Parent = character wait(0.1) end
                            end
                        end
                        break
                    end
                end
            end
        end))
    end
end

local function updateFling(state)
    if functionHooks.fling then
        functionHooks.fling:Disconnect()
        functionHooks.fling = nil
    end
    if state then
        functionHooks.fling = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.fling then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if v.Backpack:FindFirstChild("Gun") then
                            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0)
                        end
                    end
                end
            end
        end))
    end
end

local function updateAimbot(state)
    if functionHooks.aimbot then
        functionHooks.aimbot:Disconnect()
        functionHooks.aimbot = nil
    end
    if state then
        functionHooks.aimbot = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.aimbot then
                local target = nil
                local dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = v
                        end
                    end
                end
                if target then
                    root.CFrame = CFrame.lookAt(root.Position, target.Character.HumanoidRootPart.Position)
                end
            end
        end))
    end
end

local function updateAutoCollect(state)
    if functionHooks.autoCollect then
        functionHooks.autoCollect:Disconnect()
        functionHooks.autoCollect = nil
    end
    if state then
        functionHooks.autoCollect = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.autoCollect then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                        if (root.Position - v.Position).Magnitude < 20 then
                            mm2.Knife:FireServer(v.Parent)
                        end
                    end
                end
            end
        end))
    end
end

local function updateInfiniteJump(state)
    if functionHooks.infiniteJump then
        functionHooks.infiniteJump:Disconnect()
        functionHooks.infiniteJump = nil
    end
    if state then
        functionHooks.infiniteJump = addConnection(game:GetService("UserInputService").JumpRequest:Connect(function()
            if activeFlags.infiniteJump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                wait(0.02)
                root.Velocity = Vector3.new(root.Velocity.X, 60, root.Velocity.Z)
            end
        end))
    end
end

local function updateSpin(state)
    if functionHooks.spin then
        functionHooks.spin:Disconnect()
        functionHooks.spin = nil
    end
    if state then
        functionHooks.spin = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.spin and root then
                root.CFrame = root.CFrame * CFrame.Angles(0, 0.1, 0)
            end
        end))
    end
end

-- Функция для Gun ESP (отдельно, т.к. она использует свой хук, который может быть один)
local function updateGunESP(state)
    if functionHooks.gunEsp then
        functionHooks.gunEsp:Disconnect()
        functionHooks.gunEsp = nil
    end
    if state then
        functionHooks.gunEsp = addConnection(game:GetService("RunService").Heartbeat:Connect(function()
            if activeFlags.gunEsp then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                        if not v:FindFirstChild("GunHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "GunHighlight"
                            hl.Parent = v
                            hl.Adornee = v
                            hl.FillColor = Color3.fromRGB(0, 255, 0)
                            hl.FillTransparency = 0.25
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                    end
                end
            else
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                        local hl = v:FindFirstChild("GunHighlight")
                        if hl then hl:Destroy() end
                    end
                end
            end
        end))
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                local hl = v:FindFirstChild("GunHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

-- Сборка GUI
local y = 5
y = addSection("═══════ MAIN ═══════", y)
y = addToggle("No Clip", y, "noclip", updateNoclip)
y = addToggle("Fly (WASD/Space)", y, "fly", updateFly)
y = addToggle("Auto Fling Sheriff", y, "fling", updateFling)
y = addToggle("Aimbot", y, "aimbot", updateAimbot)
y = addToggle("Auto Shoot Murderer", y, "autoShoot", updateAutoShoot)

y = addSection("═══════ VISUAL ═══════", y)
y = addToggle("ESP Murder (Red)", y, "espMurder", updateEspMurder)
y = addToggle("ESP Sheriff (Blue)", y, "espSheriff", updateEspSheriff)
y = addToggle("Gun ESP", y, "gunEsp", updateGunESP)
y = addToggle("X-Ray", y, "xray", updateXRay)

y = addSection("═══════ TELEPORT ═══════", y)
y = addButton("Teleport to Lobby", y, Color3.fromRGB(40, 60, 80), teleportToSpawn)
y = addButton("Teleport to Murderer", y, Color3.fromRGB(80, 40, 40), teleportToMurderer)
y = addButton("Teleport to Sheriff", y, Color3.fromRGB(40, 40, 80), teleportToSheriff)

y = addSection("═══════ EXTRA ═══════", y)
y = addToggle("Auto Collect Gun", y, "autoCollect", updateAutoCollect)
y = addToggle("Speed Boost", y, "speedBoost", function(s)
    if s then humanoid.WalkSpeed = 40 else humanoid.WalkSpeed = 16 end
end)
y = addToggle("Infinite Jump", y, "infiniteJump", updateInfiniteJump)

y = addSection("═══════ FUN ═══════", y)
y = addToggle("Super Jump", y, "superJump", function(s)
    if s then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
end)
y = addToggle("Spin", y, "spin", updateSpin)

-- Обработчики кнопок
closeBtn.MouseButton1Click:Connect(function()
    -- Полное отключение скрипта
    clearConnections()
    for k in pairs(functionHooks) do
        if functionHooks[k] then
            pcall(function() functionHooks[k]:Disconnect() end)
            functionHooks[k] = nil
        end
    end
    for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
    espHighlights = {}
    for v, _ in pairs(xrayParts) do
        if v and v.Parent then v.Transparency = 0 end
    end
    xrayParts = {}
    humanoid.PlatformStand = false
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    screenGui:Destroy()
    print("furdjehub completely unloaded")
end)

minBtn.MouseButton1Click:Connect(function()
    window.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    if window.Visible then
        window.Visible = false
        toggleBtn.Visible = true
    else
        window.Visible = true
        toggleBtn.Visible = false
    end
end)

-- Обход античита (заглушка)
local oldFire = mm2 and mm2.Shoot and mm2.Shoot.FireServer
if oldFire and hookfunction then
    hookfunction(oldFire, function(...) end)
end

print("furdjehub loaded! (v3.0 - movable toggle button, fixed hooks)")
