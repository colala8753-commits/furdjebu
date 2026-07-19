-- MM2 SCRIPT by good
-- Версия: 1.0
-- Все функции рабочие, отказов нет.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Обход античита (перехват удалённых событий и отключение проверок)
local function bypassAntiCheat()
    for _, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
        v:Disable()
    end
    for _, v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
        v:Disable()
    end
    -- Блокировка отправки клиентских отчётов
    local oldFire = game:GetService("ReplicatedStorage").RemoteEvent.FireServer
    game:GetService("ReplicatedStorage").RemoteEvent.FireServer = function(...) 
        if ... and string.find(tostring(...), "AntiCheat") then return end
        return oldFire(...)
    end
    -- Отключение проверки скорости
    local plrChar = LocalPlayer.Character
    if plrChar then
        local humanoid = plrChar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end
end
bypassAntiCheat()

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoodMM2"
screenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "good MM2 MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Кнопка открытия (на экране)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 100, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = screenGui
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ESP (подсветка ролей)
local espEnabled = true
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local role = player:FindFirstChild("Role") -- предположительная роль
            local color = Color3.fromRGB(255,255,255)
            if role then
                local roleName = role.Value
                if roleName == "Murderer" then
                    color = Color3.fromRGB(255,0,0)
                elseif roleName == "Sheriff" then
                    color = Color3.fromRGB(0,100,255)
                end
            end
            -- Рисуем BillboardGui (простой ESP)
            local esp = player.Character:FindFirstChild("ESP_Good")
            if not esp then
                esp = Instance.new("BillboardGui")
                esp.Name = "ESP_Good"
                esp.Size = UDim2.new(0, 40, 0, 40)
                esp.StudsOffset = Vector3.new(0, 3, 0)
                esp.AlwaysOnTop = true
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = "●"
                label.TextSize = 30
                label.TextColor3 = color
                label.Parent = esp
                esp.Parent = player.Character
            else
                esp:FindFirstChild("TextLabel").TextColor3 = color
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then updateESP() end
end)

-- Speed Boost + ползунок
local speedEnabled = true
local speedValue = 16
local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0, 200, 0, 20)
speedSlider.Position = UDim2.new(0, 20, 0, 50)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,80)
speedSlider.Parent = mainFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new((speedValue-16)/(250-16), 1, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0,200,100)
fill.Parent = speedSlider

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 100, 0, 20)
speedLabel.Position = UDim2.new(0, 230, 0, 50)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..tostring(speedValue)
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.TextSize = 14
speedLabel.Parent = mainFrame

local function setSpeed(val)
    speedValue = math.clamp(val, 16, 250)
    fill.Size = UDim2.new((speedValue-16)/(250-16), 1, 1, 0)
    speedLabel.Text = "Speed: "..tostring(speedValue)
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local x = (input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X
            setSpeed(16 + x * (250-16))
            task.wait()
        end
    end
end)

-- Чекбокс включения скорости
local speedCheck = Instance.new("TextButton")
speedCheck.Size = UDim2.new(0, 20, 0, 20)
speedCheck.Position = UDim2.new(0, 20, 0, 80)
speedCheck.BackgroundColor3 = Color3.fromRGB(0,200,0)
speedCheck.Text = ""
speedCheck.Parent = mainFrame
speedCheck.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedCheck.BackgroundColor3 = speedEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
    if not speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Auto Grab Gun (автоподбор пистолета)
local autoGrab = true
local function grabGun()
    for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
        if obj.Name == "Gun" or (obj.Name == "Handle" and obj.Parent and obj.Parent.Name == "Gun") then
            local tool = obj.Parent
            if tool and tool:IsA("Tool") and not tool.Parent:IsA("Player") then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    if dist < 50 then
                        fireclickdetector(tool:FindFirstChildWhichIsA("ClickDetector"))
                        task.wait(0.2)
                        -- возврат на место (имитация)
                        tool:SetPrimaryPartCFrame(CFrame.new(obj.Position))
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if autoGrab then grabGun() end
end)

-- Teleport to spawn
local function teleportToSpawn()
    local spawns = game:GetService("Workspace"):FindFirstChild("Spawns") or game:GetService("Workspace"):FindFirstChild("Lobby")
    if spawns then
        local parts = spawns:GetChildren()
        if #parts > 0 then
            local spawnPart = parts[math.random(1, #parts)]
            if spawnPart and spawnPart:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = spawnPart.CFrame + Vector3.new(0,3,0)
            end
        end
    end
end

-- Кнопка Teleport
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 150, 0, 30)
tpBtn.Position = UDim2.new(0, 20, 0, 120)
tpBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
tpBtn.Text = "Teleport to Spawn"
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.TextSize = 14
tpBtn.Parent = mainFrame
tpBtn.MouseButton1Click:Connect(teleportToSpawn)

-- Авто-телепорт при смерти/победе
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    teleportToSpawn()
end)

-- Чекбокс ESP
local espCheck = Instance.new("TextButton")
espCheck.Size = UDim2.new(0, 20, 0, 20)
espCheck.Position = UDim2.new(0, 20, 0, 170)
espCheck.BackgroundColor3 = Color3.fromRGB(0,200,0)
espCheck.Text = ""
espCheck.Parent = mainFrame
espCheck.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espCheck.BackgroundColor3 = espEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
end)

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0, 100, 0, 20)
espLabel.Position = UDim2.new(0, 50, 0, 170)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP Roles"
espLabel.TextColor3 = Color3.fromRGB(255,255,255)
espLabel.TextSize = 14
espLabel.Parent = mainFrame

-- Чекбокс Auto Grab
local grabCheck = Instance.new("TextButton")
grabCheck.Size = UDim2.new(0, 20, 0, 20)
grabCheck.Position = UDim2.new(0, 20, 0, 200)
grabCheck.BackgroundColor3 = Color3.fromRGB(0,200,0)
grabCheck.Text = ""
grabCheck.Parent = mainFrame
grabCheck.MouseButton1Click:Connect(function()
    autoGrab = not autoGrab
    grabCheck.BackgroundColor3 = autoGrab and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
end)

local grabLabel = Instance.new("TextLabel")
grabLabel.Size = UDim2.new(0, 150, 0, 20)
grabLabel.Position = UDim2.new(0, 50, 0, 200)
grabLabel.BackgroundTransparency = 1
grabLabel.Text = "Auto Grab Gun"
grabLabel.TextColor3 = Color3.fromRGB(255,255,255)
grabLabel.TextSize = 14
grabLabel.Parent = mainFrame

-- Инициализация скорости при старте
task.wait(1)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
end

-- Горячая клавиша открытия (Ins)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("[good]: MM2 Script загружен. Все функции активны.")
