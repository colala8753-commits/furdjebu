-- EXECUTOR SCRIPT (Полная панель + глобальные анимации)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Создаём RemoteEvent для глобальной синхронизации
local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage:FindFirstChild("GlobalAnimEvent")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "GlobalAnimEvent"
	remote.Parent = replicatedStorage
end

-- Серверная часть (запускается один раз через удалённый вызов)
if not game:IsLoaded() then game.Loaded:Wait() end

-- Создаём серверный скрипт для ретрансляции (если его нет)
local serverScript = game:GetService("ServerScriptService"):FindFirstChild("GlobalAnimRelay")
if not serverScript then
	local script = Instance.new("Script")
	script.Name = "GlobalAnimRelay"
	script.Parent = game:GetService("ServerScriptService")
	script.Source = [[
		local remote = game:GetService("ReplicatedStorage"):FindFirstChild("GlobalAnimEvent")
		if remote then
			remote.OnServerEvent:Connect(function(plr, animType)
				for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
					if p ~= plr then
						remote:FireClient(p, plr, animType)
					end
				end
				remote:FireClient(plr, plr, animType)
			end)
		end
	]]
	script.Disabled = false
end

-- Встроенные анимации (создаются кодом)
local function createPoseAnimation(poseData, duration)
	local anim = Instance.new("Animation")
	local keyframes = {}
	for i, data in ipairs(poseData) do
		local kf = {
			Time = data.time / duration,
			Value = data.value
		}
		table.insert(keyframes, kf)
	end
	-- Применяем через аниматор
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
	animator.Parent = humanoid
	local track = animator:LoadAnimation(anim)
	
	-- Имитация движений через CFrame (быстрый костыль для экзекьютора)
	local function play()
		track:Play()
		local start = tick()
		local loop = true
		while loop and track.IsPlaying do
			local t = (tick() - start) % duration
			for i = 1, #poseData - 1 do
				local p1 = poseData[i]
				local p2 = poseData[i+1]
				if t >= p1.time and t < p2.time then
					local frac = (t - p1.time) / (p2.time - p1.time)
					local headCF = CFrame.new(0,0,0) * CFrame.Angles(p1.value[1], p1.value[2], p1.value[3])
					local root = character:FindFirstChild("HumanoidRootPart")
					if root then
						root.CFrame = root.CFrame * CFrame.Angles(0, 0, frac * 0.3)
					end
				end
			end
			task.wait()
		end
	end
	track.Stopped:Connect(function() loop = false end)
	return {Play = play, Stop = function() track:Stop() end}
end

-- Позы: Suck (качание головы) и Sex (движение таза)
local suckPoses = {
	{time=0, value={0, 0, 0}},
	{time=0.2, value={-0.5, 0.3, 0.1}},
	{time=0.5, value={0.8, -0.2, 0}},
	{time=0.8, value={-0.3, 0.5, 0}},
	{time=1.0, value={0, 0, 0}}
}
local sexPoses = {
	{time=0, value={0, 0, 0}},
	{time=0.3, value={0, 0.5, 0.4}},
	{time=0.6, value={0, -0.3, 0.6}},
	{time=0.9, value={0.2, 0.4, -0.2}},
	{time=1.2, value={0, 0, 0}}
}

local suckAnim = createPoseAnimation(suckPoses, 1.2)
local sexAnim = createPoseAnimation(sexPoses, 1.5)

-- Глобальный вызов через Remote
local function playGlobal(animType)
	remote:FireServer(animType)
end

-- Получаем события от сервера (чтобы видеть других)
remote.OnClientEvent:Connect(function(sourcePlayer, animType)
	if sourcePlayer == player then return end
	if animType == "Suck" then suckAnim:Play() else sexAnim:Play() end
end)

-- === GUI ПАНЕЛЬ ===
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "AnimPanel"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.75, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Скругление
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 20)

-- Заголовок
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "💀 ACTIONS"
title.TextColor3 = Color3.fromRGB(255, 150, 150)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextScaled = true

-- Кнопка Suck
local btnSuck = Instance.new("TextButton")
btnSuck.Parent = mainFrame
btnSuck.Size = UDim2.new(0, 110, 0, 55)
btnSuck.Position = UDim2.new(0, 10, 0, 45)
btnSuck.BackgroundColor3 = Color3.fromRGB(200, 60, 120)
btnSuck.Text = "🍆 SUCK"
btnSuck.TextColor3 = Color3.new(1,1,1)
btnSuck.Font = Enum.Font.GothamBold
btnSuck.TextSize = 20
btnSuck.AutoButtonColor = false
btnSuck.BorderSizePixel = 0
local c1 = Instance.new("UICorner"); c1.Parent = btnSuck; c1.CornerRadius = UDim.new(0, 14)

-- Кнопка Sex
local btnSex = Instance.new("TextButton")
btnSex.Parent = mainFrame
btnSex.Size = UDim2.new(0, 110, 0, 55)
btnSex.Position = UDim2.new(0, 140, 0, 45)
btnSex.BackgroundColor3 = Color3.fromRGB(220, 40, 80)
btnSex.Text = "💦 SEX"
btnSex.TextColor3 = Color3.new(1,1,1)
btnSex.Font = Enum.Font.GothamBold
btnSex.TextSize = 20
btnSex.AutoButtonColor = false
btnSex.BorderSizePixel = 0
local c2 = Instance.new("UICorner"); c2.Parent = btnSex; c2.CornerRadius = UDim.new(0, 14)

-- Кнопка Stop
local btnStop = Instance.new("TextButton")
btnStop.Parent = mainFrame
btnStop.Size = UDim2.new(0, 80, 0, 30)
btnStop.Position = UDim2.new(0, 90, 0, 115)
btnStop.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
btnStop.Text = "⏹ STOP"
btnStop.TextColor3 = Color3.new(1,1,1)
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 16
btnStop.AutoButtonColor = false
btnStop.BorderSizePixel = 0
local c3 = Instance.new("UICorner"); c3.Parent = btnStop; c3.CornerRadius = UDim.new(0, 10)

-- Действия кнопок
btnSuck.MouseButton1Click:Connect(function()
	suckAnim:Play()
	sexAnim:Stop()
	playGlobal("Suck")
end)

btnSex.MouseButton1Click:Connect(function()
	sexAnim:Play()
	suckAnim:Stop()
	playGlobal("Sex")
end)

btnStop.MouseButton1Click:Connect(function()
	suckAnim:Stop()
	sexAnim:Stop()
end)

-- Для телефона: увеличиваем тач-зону (всё большое)
-- Автоповтор при респавне
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = character:WaitForChild("Humanoid")
	-- пересоздаём анимации (можно оставить как есть)
end)

print("✅ Панель загружена! Используй кнопки. Видно всем.")
