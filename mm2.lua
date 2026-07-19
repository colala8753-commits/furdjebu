local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local config = {
espEnabled = true,
speedEnabled = true,
speedValue = 16,
autoGrab = true,
uiVisible = false,
colors = {
murderer = Color3.fromRGB(255, 0, 0),
sheriff = Color3.fromRGB(0, 100, 255),
default = Color3.fromRGB(255, 255, 255)
},
uiSize = {width = 600, height = 400},
hotkey = Enum.KeyCode.Insert
}

local function bypassAntiCheat()
local connections = {
game:GetService("ScriptContext").Error,
game:GetService("LogService").MessageOut
}
for _, service in pairs(connections) do
for _, v in pairs(getconnections(service)) do
v:Disable()
end
end

end
bypassAntiCheat()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoodMM2"
screenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, config.uiSize.width, 0, config.uiSize.height)
mainFrame.Position = UDim2.new(0.5, -config.uiSize.width/2, 0.5, -config.uiSize.height/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = config.uiVisible
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "MM2 MENU"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
config.uiVisible = false
mainFrame.Visible = false
end)

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,100,0,40)
openBtn.Position = UDim2.new(0,10,0,10)
openBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = screenGui
openBtn.MouseButton1Click:Connect(function()
config.uiVisible = not config.uiVisible
mainFrame.Visible = config.uiVisible
end)

local function updateESP()
for _, player in pairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local role = player:FindFirstChild("Role")
local color = config.colors.default
if role then
local roleName = tostring(role.Value)
if roleName == "Murderer" then
color = config.colors.murderer
elseif roleName == "Sheriff" then
color = config.colors.sheriff
end
end
local esp = player.Character:FindFirstChild("ESP_Good")
if not esp then
esp = Instance.new("BillboardGui")
esp.Name = "ESP_Good"
esp.Size = UDim2.new(0,40,0,40)
esp.StudsOffset = Vector3.new(0,3,0)
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
local label = esp:FindFirstChild("TextLabel")
if label then
label.TextColor3 = color
end
end
end
end
end

RunService.RenderStepped:Connect(function()
if config.espEnabled then
updateESP()
end
end)

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0,200,0,20)
speedSlider.Position = UDim2.new(0,20,0,50)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,80)
speedSlider.Parent = mainFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,200,100)
fill.Parent = speedSlider

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0,100,0,20)
speedLabel.Position = UDim2.new(0,230,0,50)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.TextSize = 14
speedLabel.Parent = mainFrame

local function setSpeed(val)
config.speedValue = math.clamp(val, 16, 250)
fill.Size = UDim2.new((config.speedValue-16)/(250-16), 1, 1, 0)
speedLabel.Text = "Speed: "..tostring(config.speedValue)
if config.speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = config.speedValue
end
end

speedSlider.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
local mousePos = UserInputService:GetMouseLocation()
local x = (mousePos.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X
setSpeed(16 + x * 234)
task.wait()
end
end
end)

local speedCheck = Instance.new("TextButton")
speedCheck.Size = UDim2.new(0,20,0,20)
speedCheck.Position = UDim
