-- UNIVERSAL SCRIPT [INF Jump + NoClip] - Работает во всех играх
-- Скрипт автоматически включает бесконечные прыжки и ноклип при загрузке

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Переменные состояния
local infJumpEnabled = true
local noclipEnabled = true
local connections = {}
local noclipConnection = nil

-- Функция для включения INF Jump
local function enableInfJump()
    -- Отключаем старые соединения
    for _, con in pairs(connections) do
        pcall(function() con:Disconnect() end)
    end
    connections = {}
    
    -- Отключаем стандартный прыжок
    local function onJumpRequest()
        if infJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                wait(0.05)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            end
        end
    end
    
    -- Перехват прыжка через UserInputService
    local jumpCon = UserInputService.JumpRequest:Connect(onJumpRequest)
    table.insert(connections, jumpCon)
    
    -- Альтернативный метод через Heartbeat
    local heartbeatCon = RunService.Heartbeat:Connect(function()
        if infJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall and not humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            end
        end
    end)
    table.insert(connections, heartbeatCon)
    
    -- Сброс при смене персонажа
    local charAddedCon = player.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50
            humanoid.UseJumpPower = true
        end
    end)
    table.insert(connections, charAddedCon)
end

-- Функция для включения NoClip
local function enableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and player.Character then
            local character = player.Character
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Переключение INF Jump
local function toggleInfJump()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        enableInfJump()
    else
        for _, con in pairs(connections) do
            pcall(function() con:Disconnect() end)
        end
        connections = {}
    end
    return infJumpEnabled
end

-- Переключение NoClip
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        enableNoclip()
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- Возвращаем коллизию
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    return noclipEnabled
end

-- Создание GUI
local function createGUI()
    -- Удаляем старые GUI
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v.Name == "UniversalHub" then
            v:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UniversalHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Главное окно
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 280, 0, 200)
    window.Position = UDim2.new(0.5, -140, 0.5, -100)
    window.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.Parent = screenGui
    window.Visible = true
    window.Active = true
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 10)
    windowCorner.Parent = window
    
    -- Заголовок
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    title.BorderSizePixel = 0
    title.Parent = window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Text = "⚡ Universal Hub"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.BackgroundTransparency = 1
    titleText.Parent = title
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -32, 0, 2)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 15
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = title
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end)
    
    -- Контент
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -35)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    content.BorderSizePixel = 0
    content.Parent = window
    
    -- Кнопки
    local function createButton(text, yPos, color, toggleFunc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.8, 0, 0, 35)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = true
        btn.Text = text .. ": ON"
        
        btn.MouseButton1Click:Connect(function()
            state = toggleFunc()
            btn.Text = text .. (state and ": ON" or ": OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 140, 70) or Color3.fromRGB(45, 45, 70)
        end)
        
        return btn
    end
    
    createButton("INF Jump", 10, Color3.fromRGB(0, 120, 200), toggleInfJump)
    createButton("NoClip", 55, Color3.fromRGB(200, 120, 0), toggleNoclip)
    
    -- Кнопка открытия/закрытия
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.Text = "⚡"
    toggleBtn.TextSize = 22
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Drag functionality
    local dragging = false
    local dragStart = nil
    local dragOffset = nil
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            dragOffset = window.Position
        end
    end)
    
    title.InputEnded:Connect(function(input)
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
end

-- Автоматический запуск
enableInfJump()
enableNoclip()
createGUI()

-- Переподключение при смене персонажа
player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if infJumpEnabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50
            humanoid.UseJumpPower = true
        end
    end
    if noclipEnabled then
        -- NoClip автоматически переподключится через RunService
    end
end)

-- Защита от отключения
game:GetService("CoreGui").ChildAdded:Connect(function(child)
    if child.Name == "CoreScript" then
        wait(0.5)
        if infJumpEnabled then
            enableInfJump()
        end
        if noclipEnabled then
            enableNoclip()
        end
    end
end)

print("⚡ Universal Script loaded! INF Jump + NoClip enabled permanently.")
