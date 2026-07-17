-- ADAPTED FOR CATALOG AVATAR CREATOR (CAC)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- В CAC персонаж может быть без Humanoid, используем его части
local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
local humanoid = character:FindFirstChildOfClass("Humanoid")

-- Если нет Humanoid — создаём временный для анимаций (но CFrame-метод работает без него)
if not humanoid then
    humanoid = Instance.new("Humanoid")
    humanoid.Parent = character
    humanoid.PlatformStand = true
end

-- === ГЛОБАЛЬНЫЙ RemoteEvent (с защитой от дублирования) ===
local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage:FindFirstChild("GlobalAnimEvent_CAC")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "GlobalAnimEvent_CAC"
    remote.Parent = replicatedStorage
end

-- Серверный ретранслятор (с проверкой на существование)
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
                    if p ~= plr then
                        remote:FireClient(p, plr, animType, dollPos)
                    end
                end
                -- Показываем и самому себе (для синхронизации)
                remote:FireClient(plr, plr, animType, dollPos)
            end)
        end
    ]]
    -- Принудительно запускаем
    serverScript.Disabled = false
end

-- === СОЗДАНИЕ КУКЛЫ (миссионерская поза) ===
local doll = nil
local function createDoll(position)
    if doll then doll:Destroy() end
    local model = Instance.new("Model")
    model.Name = "Doll_Missionary_CAC"
    model.Parent = workspace

    -- Части тела (адаптировано под CAC)
    local parts = {
        Head = CFrame.new(0, 1.8, 0),
        Torso = CFrame.new(0, 1.3, 0),
        LeftLeg = CFrame.new(-0.3, 0.7, 0.1),
        RightLeg = CFrame.new(0.3, 0.7, -0.1),
        LeftArm = CFrame.new(-0.5, 1.2, 0.2),
        RightArm = CFrame.new(0.5, 1.2, -0.2)
    }
    for name, cf in pairs(parts) do
        local p = Instance.new("Part")
        p.Name = name
        p.Size = (name == "Head" and Vector3.new(1,1,1)) or 
                 (name == "Torso" and Vector3.new(1.2,0.8,0.6)) or 
                 Vector3.new(0.4,0.8,0.4)
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
    weld.C0 = CFrame.new(0, -0.8, 0)

    doll = model
    return model
end

-- === АНИМАЦИИ (CFrame-метод, работает без Humanoid) ===
local function animSuck()
    local running = true
    task.spawn(function()
        while running do
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0.3, 0, 0)
                task.wait(0.1)
                root.CFrame = root.CFrame * CFrame.Angles(-0.3, 0, 0)
                task.wait(0.1)
            end
        end
    end)
    return {Stop = function() running = false end}
end

local function animSex()
    local running = true
    task.spawn(function()
        while running do
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, 0, 0.2)
                task.wait(0.08)
                root.CFrame = root.CFrame * CFrame.Angles(0, 0, -0.2)
                task.wait(0.08)
            end
        end
    end)
    return {Stop = function() running = false end}
end

local function animCunnilingus(dollPos)
    local running = true
    -- Перемещаем игрока к кукле
    if root and dollPos then
        local targetPos = dollPos * CFrame.new(0, 0.5, 0.6)
        root.CFrame = targetPos
    end
    task.spawn(function()
        while running do
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0.2, 0.1, 0)
                task.wait(0.15)
                root.CFrame = root.CFrame * CFrame.Angles(-0.2, -0.1, 0)
                task.wait(0.15)
            end
        end
    end)
    return {Stop = function() running = false end}
end

-- === GUI ПАНЕЛЬ (CoreGui - гарантированная видимость) ===
local coreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = coreGui
screenGui.Name = "SexPanel_CAC"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Фон (чтобы панель выделялась)
local bg = Instance.new("Frame")
bg.Parent = screenGui
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BackgroundTransparency = 0.5
bg.ZIndex = 0

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 380, 0, 280)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 200)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 2

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 5)
title.Text = "🔥 CAC SEX PANEL 🔥"
title.TextColor3 = Color3.fromRGB(255, 100, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextScaled = true
title.ZIndex = 3

-- Функция создания кнопок (увеличенный размер для телефона)
local function makeButton(text, color, x, y, w, h)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, w or 160, 0, h or 70)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    btn.TextScaled = true
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 3
    btn.BorderColor3 = Color3.fromRGB(255,255,255)
    btn.ZIndex = 4
    local c = Instance.new("UICorner")
    c.Parent = btn
    c.CornerRadius = UDim.new(0, 16)
    return btn
end

local btnSuck = makeButton("🍆 SUCK", Color3.fromRGB(100, 200, 255), 10, 60, 160, 70)
local btnDoll = makeButton("🤖 DOLL", Color3.fromRGB(200, 150, 255), 200, 60, 160, 70)
local btnSex = makeButton("💦 SEX", Color3.fromRGB(255, 100, 150), 10, 150, 160, 70)
local btnStop = makeButton("⏹ STOP", Color3.fromRGB(200, 50, 50), 200, 150, 160, 70)

-- === СОСТОЯНИЯ ===
local currentAnim = nil

-- === ЛОГИКА КНОПОК ===
btnSuck.MouseButton1Click:Connect(function()
    if currentAnim then currentAnim:Stop() end
    currentAnim = animSuck()
    remote:FireServer("Suck")
end)

btnDoll.MouseButton1Click:Connect(function()
    if not root then return end
    local pos = root.CFrame
    local dollModel = createDoll(pos)
    -- Кукла лежит на спине
    dollModel:SetPrimaryPartCFrame(pos * CFrame.Angles(math.rad(90), 0, 0))
    if currentAnim then currentAnim:Stop() end
    currentAnim = animCunnilingus(pos)
    remote:FireServer("Doll", pos)
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

btnStop.MouseButton1Click:Connect(function()
    if currentAnim then currentAnim:Stop() end
    if doll then doll:Destroy(); doll = nil end
end)

-- === ПРИЁМ ГЛОБАЛЬНЫХ СОБЫТИЙ ===
remote.OnClientEvent:Connect(function(src, animType, dollPos)
    if src == player then return end
    if animType == "Suck" then
        if currentAnim then currentAnim:Stop() end
        currentAnim = animSuck()
    elseif animType == "Doll" and dollPos then
        local m = createDoll(dollPos)
        m:SetPrimaryPartCFrame(dollPos * CFrame.Angles(math.rad(90), 0, 0))
        if currentAnim then currentAnim:Stop() end
        currentAnim = animCunnilingus(dollPos)
    elseif animType == "Sex" then
        if currentAnim then currentAnim:Stop() end
        currentAnim = animSex()
    end
end)

-- === ЗАЩИТА ОТ СБРОСА GUI ПРИ РЕСПАВНЕ ===
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
    humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = Instance.new("Humanoid")
        humanoid.Parent = character
        humanoid.PlatformStand = true
    end
    -- GUI остаётся, так как он в CoreGui
end)

-- === ПРИНУДИТЕЛЬНОЕ ОБНОВЛЕНИЕ GUI ===
task.wait(0.5)
screenGui.Enabled = false
task.wait(0.1)
screenGui.Enabled = true

print("✅ CAC SEX PANEL ACTIVE — ALL PLAYERS SEE IT!")
