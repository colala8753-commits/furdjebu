--[[
  GOOD DEAD RAILS MOBILE v2.0
  - Встроенная кнопка сворачивания (иконка "−" внутри GUI)
  - Клавиша "_" (работает и на ПК)
  - Управление пальцем: полёт вверх/вниз + движение в стороны
  - Выдача предмета тапом по кнопке или по экрану (двойной тап)
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInput = game:GetService("UserInputService")
local guiEnabled = true
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local moveDirection = Vector3.new(0,0,0)

-- Создаём GUI с учётом мобильных пропорций
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoodMobileGUI"
screenGui.ResetOnSpawn = false
player.PlayerGui:InsertChild(screenGui)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, math.min(350, screenGui.AbsoluteSize.X * 0.9), 0, 480)
frame.Position = UDim2.new(0.5, -frame.Size.X.Offset/2, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Заголовок + кнопка сворачивания (внутри GUI)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GOOD RAILS"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.Parent = titleBar

-- Кнопка сворачивания (внутри GUI, всегда видна)
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 40, 0, 40)
collapseBtn.Position = UDim2.new(1, -45, 0, 0)
collapseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
collapseBtn.Text = "−"
collapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 28
collapseBtn.Parent = titleBar

-- Контейнер для элементов (скролл, если нужно)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -50)
content.Position = UDim2.new(0, 5, 0, 45)
content.BackgroundTransparency = 1
content.Parent = frame

-- === Управление полётом (джойстик для телефона) ===
local joystickBg = Instance.new("Frame")
joystickBg.Size = UDim2.new(0, 120, 0, 120)
joystickBg.Position = UDim2.new(0.5, -60, 0.7, 0)
joystickBg.BackgroundColor3 = Color3.fromRGB(40,40,60)
joystickBg.BackgroundTransparency = 0.6
joystickBg.BorderSizePixel = 2
joystickBg.BorderColor3 = Color3.fromRGB(200,200,255)
joystickBg.Parent = content

local joystickKnob = Instance.new("Frame")
joystickKnob.Size = UDim2.new(0, 50, 0, 50)
joystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickKnob.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
joystickKnob.BorderSizePixel = 0
joystickKnob.Parent = joystickBg

-- Переменные для тач-джойстика
local isTouchingJoystick = false
local joystickCenter = Vector2.new(60, 60)

-- Скорость (ползунок цифровой)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(200,200,200)
speedLabel.TextSize = 16
speedLabel.Parent = content

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 0, 30)
speedBox.Position = UDim2.new(0.25, 0, 0.1, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.TextSize = 18
speedBox.ClearTextOnFocus = false
speedBox.Parent = content

-- Кнопка FLY (вкл/выкл)
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 100, 0, 40)
flyBtn.Position = UDim2.new(0.55, 0, 0.1, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
flyBtn.Text = "FLY OFF"
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 18
flyBtn.Parent = content

-- Кнопка выдачи предмета
local giveBtn = Instance.new("TextButton")
giveBtn.Size = UDim2.new(0, 130, 0, 40)
giveBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
giveBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 20)
giveBtn.Text = "GIVE TOOL"
giveBtn.TextColor3 = Color3.fromRGB(255,255,255)
giveBtn.Font = Enum.Font.GothamBold
giveBtn.TextSize = 18
giveBtn.Parent = content

-- Поле ID предмета
local itemIdBox = Instance.new("TextBox")
itemIdBox.Size = UDim2.new(0, 130, 0, 35)
itemIdBox.Position = UDim2.new(0.55, 0, 0.3, 0)
itemIdBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
itemIdBox.Text = "123456789"
itemIdBox.TextColor3 = Color3.fromRGB(255,255,255)
itemIdBox.TextSize = 16
itemIdBox.Parent = content

-- === Функции ===
local function spawnItemAtMouse(itemId)
    local targetPos = mouse.Hit.Position
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ItemRequest")
    if remote then
        remote:FireServer("Spawn", itemId, targetPos, "Touch")
    else
        local tool = Instance.new("Tool")
        tool.Name = "MobileTool"
        local handle = Instance.new("Part")
        handle.Size = Vector3.new(1,1,1)
        handle.BrickColor = BrickColor.new("Bright orange")
        handle.Parent = tool
        tool.Parent = player.Backpack
        local tag = Instance.new("BoolValue")
        tag.Name = "LegitSpawn"
        tag.Value = true
        tag.Parent = tool
    end
end

local function toggleFly()
    flying = not flying
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if flying then
        flyBtn.Text = "FLY ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        bodyVelocity.Parent = root
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    else
        flyBtn.Text = "FLY OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = nil
    end
end

-- Обновление скорости
speedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(speedBox.Text)
    if val then flySpeed = math.clamp(val, 1, 500) end
end)

-- === Обработка сворачивания (кнопка внутри GUI) ===
collapseBtn.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
end)

-- Клавиша "_" (для ПК)
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Underscore then
        guiEnabled = not guiEnabled
        frame.Visible = guiEnabled
    end
end)

-- Кнопки
flyBtn.MouseButton1Click:Connect(toggleFly)

giveBtn.MouseButton1Click:Connect(function()
    local id = itemIdBox.Text
    if id and id ~= "" then spawnItemAtMouse(id) end
end)

-- === Джойстик для телефона (тач) ===
joystickBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isTouchingJoystick = true
    end
end)

joystickBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isTouchingJoystick = false
        joystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
        moveDirection = Vector3.new(0,0,0)
        if flying and bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        end
    end
end)

userInput.TouchMoved:Connect(function(input, processed)
    if processed then return end
    if not isTouchingJoystick then return end
    local touchPos = input.Position
    local framePos = joystickBg.AbsolutePosition
    local size = joystickBg.AbsoluteSize
    local localPos = touchPos - framePos
    local center = size / 2
    local delta = localPos - center
    local maxDist = math.min(size.X, size.Y) / 2 - 10
    local dist = delta.Magnitude
    if dist > maxDist then
        delta = delta / dist * maxDist
    end
    joystickKnob.Position = UDim2.new(0, center.X + delta.X - 25, 0, center.Y + delta.Y - 25)
    
    -- Преобразуем в направление движения
    local norm = delta / maxDist
    local forward = workspace.CurrentCamera.CFrame.LookVector
    local right = workspace.CurrentCamera.CFrame.RightVector
    moveDirection = (right * norm.X + forward * -norm.Y) * flySpeed * 0.5
    if flying and bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(moveDirection.X, flySpeed, moveDirection.Z)
    end
end)

-- Двойной тап по экрану = выдача предмета (для телефона)
local lastTapTime = 0
userInput.TouchBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        local now = tick()
        if now - lastTapTime < 0.4 then
            local id = itemIdBox.Text
            if id and id ~= "" then
                spawnItemAtMouse(id)
            end
        end
        lastTapTime = now
    end
end)

-- Обход античита (как в первой версии)
local oldFind = game:GetService("ReplicatedStorage").FindFirstChild
game:GetService("ReplicatedStorage").FindFirstChild = function(self, name)
    if name == "AntiCheat" or name == "Detection" then return nil end
    return oldFind(self, name)
end

print("GOOD MOBILE RAILS ACTIVE. Нажмите '−' внутри GUI или клавишу '_' для сворачивания.")
