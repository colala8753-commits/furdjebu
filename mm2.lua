-- CAC SEX PANEL V2 — FULL ANIMATIONS + BIG DOLL + CUNNILINGUS
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
local humanoid = character:FindFirstChildOfClass("Humanoid")

if not humanoid then
    humanoid = Instance.new("Humanoid")
    humanoid.Parent = character
    humanoid.PlatformStand = true
end

-- === ГЛОБАЛЬНЫЙ RemoteEvent ===
local remote = Instance.new("RemoteEvent")
remote.Name = "GlobalAnimEvent_CAC"
remote.Parent = game:GetService("ReplicatedStorage")

local serverScript = game:GetService("ServerScriptService"):FindFirstChild("GlobalAnimRelay_CAC")
if not serverScript then
    serverScript = Instance.new("Script")
    serverScript.Name = "GlobalAnimRelay_CAC"
    serverScript.Parent = game:GetService("ServerScriptService")
    serverScript.Source = [[
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("GlobalAnimEvent_CAC")
        if remote then
            remote.OnServerEvent:Connect(function(plr, animType, dollPos)
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    remote:FireClient(p, plr, animType, dollPos)
                end
            end)
        end
    ]]
    serverScript.Disabled = false
end

-- === СОЗДАНИЕ БОЛЬШОЙ КУКЛЫ (в 2 раза больше) ===
local doll = nil
local function createDoll(position)
    if doll then doll:Destroy() end
    local model = Instance.new("Model")
    model.Name = "Doll_Missionary_Big"
    model.Parent = workspace

    local scale = 2.0 -- Увеличение в 2 раза
    local parts = {
        Head = CFrame.new(0, 1.8 * scale, 0),
        Torso = CFrame.new(0, 1.3 * scale, 0),
        LeftLeg = CFrame.new(-0.3 * scale, 0.7 * scale, 0.1 * scale),
        RightLeg = CFrame.new(0.3 * scale, 0.7 * scale, -0.1 * scale),
        LeftArm = CFrame.new(-0.5 * scale, 1.2 * scale, 0.2 * scale),
        RightArm = CFrame.new(0.5 * scale, 1.2 * scale, -0.2 * scale)
    }
    for name, cf in pairs(parts) do
        local p = Instance.new("Part")
        p.Name = name
        local size = (name == "Head" and Vector3.new(1,1,1)) or 
                     (name == "Torso" and Vector3.new(1.2,0.8,0.6)) or 
                     Vector3.new(0.4,0.8,0.4)
        p.Size = size * scale
        p.Shape = (name == "Head" and Enum.PartType.Ball) or Enum.PartType.Block
        p.BrickColor = BrickColor.new("Bright red")
        p.Material = Enum.Material.SmoothPlastic
        p.CFrame = position * cf
        p.Anchored = true
        p.CanCollide = false
        p.Parent = model
    end

    -- Соединения
    local weld = Instance.new("Weld")
    weld.Parent = model.Head
    weld.Part0 = model.Head
    weld.Part1 = model.Torso
    weld.C0 = CFrame.new(0, -0.8 * scale, 0)

    doll = model
    return model
end

-- === ПРОДУМАННЫЕ АНИМАЦИИ ===

-- 1. Сосание (персонаж на коленях, голова вперёд-назад)
local function animSuck()
    local running = true
    task.spawn(function()
        -- Садимся на колени
        if root then
            root.CFrame = root.CFrame * CFrame.new(0, -1.5, 0.5) * CFrame.Angles(math.rad(30), 0, 0)
        end
        local cycle = 0
        while running do
            if root then
                -- Плавное движение головы вперёд-назад с ускорением
                cycle = cycle + 0.1
                local phase = math.sin(cycle * 1.5)
                local angle = 0.4 + 0.3 * math.sin(cycle * 1.5)
                root.CFrame = root.CFrame * CFrame.Angles(angle, 0, 0)
                -- Небольшой наклон в стороны для реализма
                if math.sin(cycle * 3) > 0.5 then
                    root.CFrame = root.CFrame * CFrame.Angles(0, 0, 0.05)
                end
                task.wait(0.05)
            end
        end
    end)
    return {Stop = function() running = false end}
end

-- 2. Куннилингус (персонаж ложится между ног куклы)
local function animCunnilingus(dollPos)
    local running = true
    task.spawn(function()
        if root and dollPos then
            -- Ложимся на живот между ног куклы
            local targetPos = dollPos * CFrame.new(0, 0.3, 0.8) * CFrame.Angles(math.rad(90), 0, 0)
            root.CFrame = targetPos
        end
        local cycle = 0
        while running do
            if root then
                cycle = cycle + 0.08
                -- Движения языка/головы (вверх-вниз + круговые)
                local upDown = math.sin(cycle * 2) * 0.15
                local leftRight = math.sin(cycle * 1.3) * 0.1
                local rotZ = math.sin(cycle * 1.7) * 0.1
                root.CFrame = root.CFrame * CFrame.Angles(upDown, leftRight, rotZ)
                task.wait(0.04)
            end
        end
    end)
    return {Stop = function() running = false end}
end

-- 3. Секс (движения тазом)
local function animSex()
    local running = true
    task.spawn(function()
        local cycle = 0
        while running do
            if root then
                cycle = cycle + 0.1
                -- Ритмичные движения тазом с разной амплитудой
                local amplitude = 0.2 + 0.1 * math.sin(cycle * 0.5)
                local thrust = math.sin(cycle * 2) * amplitude
                root.CFrame = root.CFrame * CFrame.Angles(0, 0, thrust)
                -- Добавляем небольшие рывки вперёд
                if math.sin(cycle * 4) > 0.8 then
                    root.CFrame = root.CFrame * CFrame.new(0, 0, 0.05)
                end
                task.wait(0.05)
            end
        end
    end)
    return {Stop = function() running = false end}
end

-- === GUI ПАНЕЛЬ (CoreGui) ===
local coreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui
screenGui.Name = "SexPanel_CAC_V2"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 200)
mainFrame.Active = true
mainFrame.Draggable = true
local corner = Instance.new("UICorner"); corner.Parent = mainFrame; corner.CornerRadius = UDim.new(0, 24)

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 60)
title.Text = "🔥 CAC SEX PANEL V2 🔥"
title.TextColor3 = Color3.fromRGB(255, 150, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextScaled = true

local function makeButton(text, color, x, y, w, h)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, w or 180, 0, h or 75)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 26
    btn.TextScaled = true
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 3
    btn.BorderColor3 = Color3.fromRGB(255,255,255)
    local c = Instance.new("UICorner"); c.Parent = btn; c.CornerRadius = UDim.new(0, 18)
    return btn
end

local btnSuck = makeButton("🍆 SUCK", Color3.fromRGB(100, 200, 255), 15, 65, 180, 75)
local btnCunni = makeButton("👅 CUNNI", Color3.fromRGB(255, 150, 100), 215, 65, 180, 75)
local btnSex = makeButton("💦 SEX", Color3.fromRGB(255, 100, 150), 15, 160, 180, 75)
local btnDoll = makeButton("🤖 DOLL", Color3.fromRGB(200, 150, 255), 215, 160, 180, 75)
local btnStop = makeButton("⏹ STOP", Color3.fromRGB(200, 50, 50), 115, 250, 180, 55)

-- === СОСТОЯНИЯ ===
local currentAnim = nil

-- === ЛОГИКА КНОПОК ===
btnSuck.MouseButton1Click:Connect(function()
    if currentAnim then currentAnim:Stop() end
    currentAnim = animSuck()
    remote:FireServer("Suck")
end)

btnCunni.MouseButton1Click:Connect(function()
    if not doll then
        print("❌ Сначала создай куклу (кнопка DOLL)")
        return
    end
    if currentAnim then currentAnim:Stop() end
    local dollPos = doll:GetPrimaryPartCFrame()
    if dollPos then
        currentAnim = animCunnilingus(dollPos)
        remote:FireServer("Cunni", dollPos)
    end
end)

btnSex.MouseButton1Click:Connect(function()
    if currentAnim then currentAnim:Stop() end
    if doll and root then
        local dollPos = doll:GetPrimaryPartCFrame()
        if dollPos then
            root.CFrame = dollPos * CFrame.new(0, 1.5, 0.2)
        end
    end
    currentAnim = animSex()
    remote:FireServer("Sex")
end)

btnDoll.MouseButton1Click:Connect(function()
    if not root then return end
    local pos = root.CFrame
    local dollModel = createDoll(pos)
    dollModel:SetPrimaryPartCFrame(pos * CFrame.Angles(math.rad(90), 0, 0))
    print("✅ Кукла создана (увеличенная)")
end)

btnStop.MouseButton1Click:Connect(function()
    if currentAnim then currentAnim:Stop() end
    if doll then doll:Destroy(); doll = nil end
end)

-- === ПРИЁМ ГЛОБАЛЬНЫХ СОБЫТИЙ ===
remote.OnClientEvent:Connect(function(src, animType, dollPos)
    if src == player then return end
    if currentAnim then currentAnim:Stop() end
    
    if animType == "Suck" then
        currentAnim = animSuck()
    elseif animType == "Cunni" and dollPos then
        local m = createDoll(dollPos)
        m:SetPrimaryPartCFrame(dollPos * CFrame.Angles(math.rad(90), 0, 0))
        currentAnim = animCunnilingus(dollPos)
    elseif animType == "Sex" then
        currentAnim = animSex()
    end
end)

-- === ЗАЩИТА ===
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
    humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = Instance.new("Humanoid")
        humanoid.Parent = character
        humanoid.PlatformStand = true
    end
end)

print("✅ CAC SEX PANEL V2 ACTIVE — BIG DOLL + SUCK + CUNNI + SEX")
