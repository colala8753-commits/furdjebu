-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoodMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Фон
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "GOOD PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Функция создания переключателя
local function createToggle(parent, yPos, labelText, defaultValue, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Parent = parent

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.2, 0, 0, 25)
    toggleBtn.Position = UDim2.new(0.75, 0, 0, yPos + 2)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = parent

    local state = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    return toggleBtn, label
end

-- Переменные состояний
local speedEnabled = false
local infJumpEnabled = false
local noclipEnabled = false
local espEnabled = false

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Speed (209)
local function setSpeed(state)
    speedEnabled = state
    if state then
        humanoid.WalkSpeed = 209
    else
        humanoid.WalkSpeed = 16
    end
end

-- Inf Jump
local function setInfJump(state)
    infJumpEnabled = state
    if state then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if infJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Noclip
local function setNoclip(state)
    noclipEnabled = state
    if state then
        rootPart.CanCollide = false
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        rootPart.CanCollide = true
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ESP на монстров (Rush и всех, чьё имя содержит "Rush" или "Monster")
local espLines = {}
local function updateESP()
    for _, line in pairs(espLines) do
        line:Destroy()
    end
    espLines = {}
    if not espEnabled then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and obj.Parent:FindFirstChild("Humanoid") then
            local name = obj.Parent.Name or ""
            if string.find(string.lower(name), "rush") or string.find(string.lower(name), "monster") then
                local line = Instance.new("LineHandleAdornment")
                line.Adornee = obj
                line.Length = 5
                line.Thickness = 3
                line.Color3 = Color3.fromRGB(255, 0, 0)
                line.Transparency = 0.3
                line.ZIndex = 10
                line.Parent = obj
                table.insert(espLines, line)
                
                -- Текстовая метка
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.Adornee = obj
                bill.Parent = obj
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = "RUSH"
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 18
                label.Parent = bill
                table.insert(espLines, bill)
            end
        end
    end
end

-- Создание переключателей
local y = 40
createToggle(frame, y, "Speed 209", false, setSpeed)
y = y + 45
createToggle(frame, y, "Inf Jump", false, setInfJump)
y = y + 45
createToggle(frame, y, "Noclip", false, setNoclip)
y = y + 45
local espToggle, _ = createToggle(frame, y, "ESP Rush/Monsters", false, function(state)
    espEnabled = state
    updateESP()
end)

-- Обновление ESP каждые 2 секунды
game:GetService("RunService").Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Обновление Noclip при смене персонажа
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if noclipEnabled then
        setNoclip(true)
    end
    if speedEnabled then
        setSpeed(true)
    end
end)

-- Закрытие по Escape (опционально)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.1, 0, 0, 25)
closeBtn.Position = UDim2.new(0.88, 0, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
