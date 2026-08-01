-- FurdjeHub - Speed Escape GUI + Deobfuscated Functions
local FurdjeHub = {
    Flags = {
        AutoFarm = false, AutoClick = false, SpeedHack = false,
        Fly = false, NoClip = false, ESP = false, Aimbot = false,
        InfJump = false, Noclip = false
    },
    Settings = {
        SpeedValue = 50, JumpPower = 50, WalkSpeed = 16,
        FlySpeed = 50, CurrentWorld = "1 World", CurrentDistance = nil,
        AutoFarmSpeed = 110
    }
}

-- Services
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local VirtualUser=game:GetService("VirtualUser")
local CoreGui=game:GetService("CoreGui")
local LocalPlayer=Players.LocalPlayer
local Mouse=LocalPlayer:GetMouse()
local lang="EN"

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============ FUNCTIONS (from your code) ============
function FurdjeHub.Functions.SaveSettings()
    local data={}
    for k,v in pairs(FurdjeHub.Flags)do data[k]=v end
    data.SpeedValue=FurdjeHub.Settings.SpeedValue
    data.JumpPower=FurdjeHub.Settings.JumpPower
    data.WalkSpeed=FurdjeHub.Settings.WalkSpeed
    setclipboard(game:GetService("HttpService"):JSONEncode(data))
end

function FurdjeHub.Functions.LoadSettings()
    local cb=getclipboard()
    if cb~=""then
        local data=game:GetService("HttpService"):JSONDecode(cb)
        for k,v in pairs(data)do if FurdjeHub.Flags[k]~=nil then FurdjeHub.Flags[k]=v end end
        FurdjeHub.Settings.SpeedValue=data.SpeedValue or 50
        FurdjeHub.Settings.JumpPower=data.JumpPower or 50
        FurdjeHub.Settings.WalkSpeed=data.WalkSpeed or 16
    end
end

function FurdjeHub.Functions.AutoFarm()
    while FurdjeHub.Flags.AutoFarm do
        local char=LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid")then
            for _,v in pairs(workspace:GetChildren())do
                if v:IsA("Model")and v:FindFirstChild("Humanoid")and v~=char then
                    local t=v.Humanoid
                    if t.Health>0 then
                        char.Humanoid:MoveTo(t.Parent.HumanoidRootPart.Position)
                        wait(0.2)
                        local tool=LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if tool then tool.Parent=char tool:Activate()wait(0.1)tool.Parent=LocalPlayer.Backpack end
                    end
                end
            end
        end
        wait(0.5)
    end
end

function FurdjeHub.Functions.AutoClick()
    while FurdjeHub.Flags.AutoClick do
        Mouse.Button1Down:Fire()wait(0.05)Mouse.Button1Up:Fire()wait(0.1)
    end
end

function FurdjeHub.Functions.SpeedHack()
    while FurdjeHub.Flags.SpeedHack do
        local char=LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid")then
            char.Humanoid.WalkSpeed=FurdjeHub.Settings.WalkSpeed+FurdjeHub.Settings.SpeedValue
            char.Humanoid.JumpPower=FurdjeHub.Settings.JumpPower
        end
        wait(0.5)
    end
end

function FurdjeHub.Functions.Fly()
    local char=LocalPlayer.Character
    if not char then return end
    local hum=char:FindFirstChild("Humanoid")
    local root=char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    local bv=Instance.new("BodyVelocity")bv.MaxForce=Vector3.new(9e9,9e9,9e9)bv.Parent=root
    local bg=Instance.new("BodyGyro")bg.MaxTorque=Vector3.new(9e9,9e9,9e9)bg.P=90000 bg.Parent=root
    hum.PlatformStand=true
    while FurdjeHub.Flags.Fly do
        local cam=workspace.CurrentCamera
        local move=Vector3.new()
        local dir=cam.CFrame.LookVector
        if UserInputService:IsKeyDown(Enum.KeyCode.W)then move+=dir end
        if UserInputService:IsKeyDown(Enum.KeyCode.S)then move-=dir end
        if UserInputService:IsKeyDown(Enum.KeyCode.A)then move-=dir:Cross(Vector3.new(0,1,0))end
        if UserInputService:IsKeyDown(Enum.KeyCode.D)then move+=dir:Cross(Vector3.new(0,1,0))end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)then move+=Vector3.new(0,1,0)end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then move-=Vector3.new(0,1,0)end
        bv.Velocity=move*FurdjeHub.Settings.FlySpeed
        bg.CFrame=cam.CFrame
        wait()
    end
    bv:Destroy()bg:Destroy()hum.PlatformStand=false
end

function FurdjeHub.Functions.NoClip()
    while FurdjeHub.Flags.NoClip do
        local char=LocalPlayer.Character
        if char then for _,v in pairs(char:GetDescendants())do if v:IsA("BasePart")then v.CanCollide=false end end end
        wait(0.1)
    end
end

function FurdjeHub.Functions.ESP()
    while FurdjeHub.Flags.ESP do
        for _,p in pairs(Players:GetPlayers())do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
                local box=Instance.new("BoxHandleAdornment")
                box.Size=Vector3.new(4,6,2)box.Color3=Color3.new(1,0,0)box.Transparency=0.5
                box.AlwaysOnTop=true box.Parent=p.Character.HumanoidRootPart
                wait(0.5)box:Destroy()
            end
        end
        wait(0.1)
    end
end

function FurdjeHub.Functions.TeleportToPlayer(n)
    local t=Players:FindFirstChild(n)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")then
        local c=LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart")then
            c.HumanoidRootPart.CFrame=t.Character.HumanoidRootPart.CFrame+Vector3.new(0,2,0)
        end
    end
end

function FurdjeHub.Functions.Aimbot()
    while FurdjeHub.Flags.Aimbot do
        local closest,cd=nil,math.huge
        for _,p in pairs(Players:GetPlayers())do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
                local root=p.Character.HumanoidRootPart
                local sp,on=workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                if on then
                    local d=(Vector2.new(Mouse.X,Mouse.Y)-Vector2.new(sp.X,sp.Y)).Magnitude
                    if d<cd then cd=d closest=root end
                end
            end
        end
        if closest then workspace.CurrentCamera.CFrame=CFrame.new(workspace.CurrentCamera.CFrame.Position,closest.Position)end
        wait(0.1)
    end
end

-- ============ SPEED ESCAPE GUI ============
local Locales={
    RU={ChooseLang="Выберите язык",WorldLabel="Мир: [ %s ]",AutoFarmTab="Auto Farm",MovementTab="Movement",ThemeTab="Темы",AdminTab="Admin",AutoFarmToggle="Auto Farm",SpeedLabel="Скорость: %d",DistLabel="Дистанция:",SelectDist="Выбрать",NoPoints="Нет точек!",InfJumpToggle="Infinity Jump",FlyToggle="Fly (WASD)",FlySpeedLabel="Скорость полета: %d",NoclipToggle="Ноклип",SaveBtn="Сохранить",LoadBtn="Загрузить",ESP="ESP",Aimbot="Aimbot",SpeedHack="Speed Hack",AutoClick="Auto Click",Themes={"Синий","Фиолетовый","Лайм","Роза","Янтарный","Белый"}},
    EN={ChooseLang="Choose language",WorldLabel="World: [ %s ]",AutoFarmTab="Auto Farm",MovementTab="Movement",ThemeTab="Themes",AdminTab="Admin",AutoFarmToggle="Auto Farm",SpeedLabel="Speed: %d",DistLabel="Distance:",SelectDist="Select",NoPoints="No points!",InfJumpToggle="Infinity Jump",FlyToggle="Fly (WASD)",FlySpeedLabel="Fly Speed: %d",NoclipToggle="Noclip",SaveBtn="Save",LoadBtn="Load",ESP="ESP",Aimbot="Aimbot",SpeedHack="Speed Hack",AutoClick="Auto Click",Themes={"Blue","Purple","Lime","Rose","Amber","White"}}
}
local function L(k)return Locales[lang][k]end
local accentColor=Color3.fromRGB(0,150,255)
local currentWorld="1 World"
local currentDistance=nil
local currentSpeed=110
local autoFarmActive=false
local isMinimized=false
local isMenuOpen=false
local infJumpEnabled=false
local flyEnabled=false
local flySpeed=50
local noclipEnabled=false

local Waypoints={
    ["1 World"]={["+1 wins"]={Vector3.new(2.8,8.5,74.3),Vector3.new(-22.3,10.4,286)},["+3 wins"]={Vector3.new(-2.1,8.5,74.2),Vector3.new(2.7,8.5,295.7),Vector3.new(58,8.5,362),Vector3.new(53,8.5,444.3),Vector3.new(-22.2,9.8,518.4)},["+10 wins"]={Vector3.new(3.1,8.5,74.8),Vector3.new(2.3,8.5,296.5),Vector3.new(55.6,8.5,336.6),Vector3.new(47.5,8.5,454.1),Vector3.new(-1.6,8.5,487.5),Vector3.new(-4.8,8.5,527.7),Vector3.new(-21.6,8.5,528),Vector3.new(-22.6,30.8,624.1),Vector3.new(-21.5,76.8,752.7),Vector3.new(-18.3,78.7,774.5)}},
    ["2 World"]={["+250k wins"]={Vector3.new(-396.8,504.7,-60.1),Vector3.new(-411.7,499.8,171.9),Vector3.new(-414,498.1,189.9)},["+400k wins"]={Vector3.new(-399.4,504.7,-57.6),Vector3.new(-398.1,499.8,209.2),Vector3.new(-417.6,501.4,445.3)}},
    ["3 World"]={["+300m wins"]={Vector3.new(-1433.5,-159.7,-878.9),Vector3.new(-1431,-157.1,-831.9),Vector3.new(-1429.5,-126,-733),Vector3.new(-1430.1,-69.9,-538.4),Vector3.new(-1481.8,-71.7,-515.8)}},
    ["Bbnos World"]={["+25k cash"]={Vector3.new(-129.9,59.1,-236.7),Vector3.new(184.7,59.2,-234)}}
}
local distSortOrder={["+1 wins"]=1,["+3 wins"]=2,["+10 wins"]=3,["+250k wins"]=4,["+400k wins"]=5,["+300m wins"]=15,["+25k cash"]=19}

-- Fly/Speed Escape functions
local function setNoClipState(state)
    if state then
        RunService.Stepped:Connect(function()
            local char=LocalPlayer.Character
            if char then for _,p in pairs(char:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end
        end)
    end
end

local function flyTo(pos)
    local char=LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart")then return false end
    local hrp=char.HumanoidRootPart
    local bv=Instance.new("BodyVelocity")bv.MaxForce=Vector3.new(9e9,9e9,9e9)bv.Parent=hrp
    local reached=false
    while autoFarmActive and not reached do
        if not char or not char:FindFirstChild("HumanoidRootPart")then break end
        if(hrp.Position-pos).Magnitude<=6 then reached=true
        else bv.Velocity=(pos-hrp.Position).Unit*currentSpeed end
        task.wait(0.02)
    end
    bv:Destroy()return reached
end

local function startAutoFarm()
    task.spawn(function()
        while autoFarmActive do
            local data=Waypoints[currentWorld]
            local wps=data and data[currentDistance]
            if wps and #wps>0 then
                setNoClipState(true)
                for i,wp in ipairs(wps)do if not autoFarmActive then break end flyTo(wp)end
            else task.wait(1)end
            task.wait(0.1)
        end
        local char=LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid")then char.Humanoid.WalkSpeed=16 end
    end)
end

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char=LocalPlayer.Character
        if char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping)end end
    end
end)

-- ============ GUI CREATION ============
local UI_SCALE=0.8
local ScreenGui=Instance.new("ScreenGui")ScreenGui.Name="FurdjeHub"ScreenGui.Parent=CoreGui
local ShadowFrame=Instance.new("Frame")ShadowFrame.BackgroundColor3=Color3.fromRGB(0,0,0)ShadowFrame.AnchorPoint=Vector2.new(0.5,0.5)ShadowFrame.Position=UDim2.new(0.5,4,0.5,6)ShadowFrame.Size=UDim2.new(0,646,0,426)ShadowFrame.BackgroundTransparency=0.45 ShadowFrame.Visible=false
Instance.new("UICorner",ShadowFrame).CornerRadius=UDim.new(0,16)
local ShadowScale=Instance.new("UIScale",ShadowFrame)ShadowScale.Scale=0.3

local MainFrame=Instance.new("Frame")MainFrame.BackgroundColor3=Color3.fromRGB(11,11,16)MainFrame.BackgroundTransparency=0.1 MainFrame.AnchorPoint=Vector2.new(0.5,0.5)MainFrame.Position=UDim2.new(0.5,0,0.5,0)MainFrame.Size=UDim2.new(0,640,0,420)MainFrame.Visible=false
Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,14)
local MainScale=Instance.new("UIScale",MainFrame)MainScale.Scale=0.3

local function toggleMenu(fs)
    if fs~=nil then isMenuOpen=fs else isMenuOpen=not isMenuOpen end
    if isMenuOpen then MainFrame.Visible=true
        if not isMinimized then ShadowFrame.Visible=true end
        TweenService:Create(MainScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=UI_SCALE}):Play()
        TweenService:Create(ShadowScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=UI_SCALE}):Play()
    else
        local ct=TweenService:Create(MainScale,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.2})
        TweenService:Create(ShadowScale,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.2}):Play()
        ct:Play()ct.Completed:Connect(function()if not isMenuOpen then MainFrame.Visible=false ShadowFrame.Visible=false end end)
    end
end

-- Toggle Widget
local ToggleWidget=Instance.new("Frame")ToggleWidget.BackgroundColor3=Color3.fromRGB(15,15,22)ToggleWidget.BackgroundTransparency=0.15 ToggleWidget.Position=UDim2.new(0.5,-80,0.08,0)ToggleWidget.Size=UDim2.new(0,160,0,44)ToggleWidget.Visible=false
Instance.new("UICorner",ToggleWidget).CornerRadius=UDim.new(0,10)
local ToggleScale=Instance.new("UIScale",ToggleWidget)ToggleScale.Scale=0.85
local ToggleLabelText=Instance.new("TextLabel")ToggleLabelText.BackgroundTransparency=1 ToggleLabelText.Size=UDim2.new(1,0,1,0)ToggleLabelText.Font=Enum.Font.GothamBold ToggleLabelText.Text="FurdjeHub"ToggleLabelText.TextColor3=Color3.fromRGB(255,255,255)ToggleLabelText.TextSize=17
ToggleWidget.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then toggleMenu()end end)

-- Lang Frame
local LangFrame=Instance.new("Frame")LangFrame.BackgroundColor3=Color3.fromRGB(12,12,18)LangFrame.BackgroundTransparency=0.15 LangFrame.AnchorPoint=Vector2.new(0.5,0.5)LangFrame.Position=UDim2.new(0.5,0,0.5,0)LangFrame.Size=UDim2.new(0,380,0,230)LangFrame.Visible=true
Instance.new("UICorner",LangFrame).CornerRadius=UDim.new(0,14)
local LangScale=Instance.new("UIScale",LangFrame)LangScale.Scale=0.8
local LangTitle=Instance.new("TextLabel")LangTitle.BackgroundTransparency=1 LangTitle.Position=UDim2.new(0,0,0,25)LangTitle.Size=UDim2.new(1,0,0,30)LangTitle.Font=Enum.Font.GothamBold LangTitle.Text="Choose language / Выберите язык"LangTitle.TextColor3=Color3.fromRGB(255,255,255)LangTitle.TextSize=17 LangTitle.Parent=LangFrame

local function buildLangBtn(emoji,text,px,lc)
    local b=Instance.new("TextButton")b.Parent=LangFrame b.BackgroundColor3=Color3.fromRGB(20,20,28)b.BackgroundTransparency=0.15 b.Position=UDim2.new(0,px,0,75)b.Size=UDim2.new(0,110,0,110)b.Text=""
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    local el=Instance.new("TextLabel")el.Parent=b el.BackgroundTransparency=1 el.Size=UDim2.new(1,0,1,0)el.Font=Enum.Font.Gotham el.Text=emoji el.TextSize=55
    local tl=Instance.new("TextLabel")tl.Parent=b tl.BackgroundTransparency=1 tl.Position=UDim2.new(0,0,1,10)tl.Size=UDim2.new(1,0,0,20)tl.Font=Enum.Font.GothamSemibold tl.Text=text tl.TextColor3=Color3.fromRGB(200,200,220)tl.TextSize=15
    b.MouseButton1Click:Connect(function()lang=lc LangFrame.Visible=false ToggleWidget.Visible=true toggleMenu(true)applyLanguage()end)
end
buildLangBtn("RU","Русский",65,"RU")buildLangBtn("EN","English",205,"EN")

-- Draggable
local dr,di,ds,sp
MainFrame.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true ds=i.Position sp=MainFrame.Position end end)
MainFrame.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement then di=i end end)
UserInputService.InputChanged:Connect(function(i)if i==di and dr then local d=i.Position-ds MainFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)ShadowFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X+4,sp.Y.Scale,sp.Y.Offset+d.Y+6)end end)
MainFrame.InputEnded:Connect(function()dr=false end)

-- Close/Min
local TopControls=Instance.new("Frame")TopControls.BackgroundTransparency=1 TopControls.Position=UDim2.new(1,-75,0,14)TopControls.Size=UDim2.new(0,65,0,26)TopControls.Parent=MainFrame
local CloseBtn=Instance.new("TextButton")CloseBtn.BackgroundColor3=Color3.fromRGB(25,18,22)CloseBtn.Position=UDim2.new(1,-26,0,0)CloseBtn.Size=UDim2.new(0,26,0,26)CloseBtn.Font=Enum.Font.GothamBold CloseBtn.Text="X"CloseBtn.TextColor3=Color3.fromRGB(250,80,80)CloseBtn.TextSize=18 CloseBtn.Parent=TopControls
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,6)
CloseBtn.MouseButton1Click:Connect(function()ScreenGui:Destroy()end)
local MinBtn=Instance.new("TextButton")MinBtn.BackgroundColor3=Color3.fromRGB(18,18,26)MinBtn.Position=UDim2.new(1,-58,0,0)MinBtn.Size=UDim2.new(0,26,0,26)MinBtn.Font=Enum.Font.GothamBold MinBtn.Text="-"MinBtn.TextColor3=Color3.fromRGB(160,160,180)MinBtn.TextSize=18 MinBtn.Parent=TopControls
Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,6)
MinBtn.MouseButton1Click:Connect(function()isMinimized=not isMinimized
    if isMinimized then MainFrame.Size=UDim2.new(0,640,0,52)ShadowFrame.Size=UDim2.new(0,646,0,58)MinBtn.Text="+"
    else MainFrame.Size=UDim2.new(0,640,0,420)ShadowFrame.Size=UDim2.new(0,646,0,426)MinBtn.Text="-"end
end)

-- Sidebar
local Sidebar=Instance.new("Frame")Sidebar.BackgroundColor3=Color3.fromRGB(15,15,22)Sidebar.BackgroundTransparency=0.1 Sidebar.Size=UDim2.new(0,170,1,0)Sidebar.Parent=MainFrame
Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0,14)
local Title=Instance.new("TextLabel")Title.BackgroundTransparency=1 Title.Position=UDim2.new(0,0,0,16)Title.Size=UDim2.new(1,0,0,26)Title.Font=Enum.Font.GothamBold Title.Text="FurdjeHub"Title.TextColor3=Color3.fromRGB(255,255,255)Title.TextSize=20 Title.Parent=Sidebar
local TabContainer=Instance.new("Frame")TabContainer.BackgroundTransparency=1 TabContainer.Position=UDim2.new(0,12,0,72)TabContainer.Size=UDim2.new(1,-24,1,-85)TabContainer.Parent=Sidebar
local TabListLayout=Instance.new("UIListLayout")TabListLayout.SortOrder=Enum.SortOrder.LayoutOrder TabListLayout.Padding=UDim.new(0,10)TabListLayout.Parent=TabContainer
local ContentArea=Instance.new("Frame")ContentArea.BackgroundTransparency=1 ContentArea.Position=UDim2.new(0,185,0,15)ContentArea.Size=UDim2.new(1,-200,1,-30)ContentArea.Parent=MainFrame

-- Pages
local AutoFarmPage=Instance.new("Frame")AutoFarmPage.BackgroundTransparency=1 AutoFarmPage.Size=UDim2.new(1,0,1,0)AutoFarmPage.Visible=true AutoFarmPage.Parent=ContentArea
local MovementPage=Instance.new("Frame")MovementPage.BackgroundTransparency=1 MovementPage.Size=UDim2.new(1,0,1,0)MovementPage.Visible=false MovementPage.Parent=ContentArea
local ThemePage=Instance.new("Frame")ThemePage.BackgroundTransparency=1 ThemePage.Size=UDim2.new(1,0,1,0)ThemePage.Visible=false ThemePage.Parent=ContentArea
local SettingsPage=Instance.new("Frame")SettingsPage.BackgroundTransparency=1 SettingsPage.Size=UDim2.new(1,0,1,0)SettingsPage.Visible=false SettingsPage.Parent=ContentArea

-- Tab Buttons
local tabButtons={}
local function createTabButton(text,page)
    local btn=Instance.new("TextButton")btn.BackgroundColor3=Color3.fromRGB(20,20,28)btn.BackgroundTransparency=0.15 btn.Size=UDim2.new(1,0,0,40)btn.Font=Enum.Font.GothamSemibold btn.Text=text btn.TextColor3=Color3.fromRGB(150,150,170)btn.TextSize=14 btn.Parent=TabContainer
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    btn.MouseButton1Click:Connect(function()
        for _,b in ipairs(tabButtons)do TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(20,20,28),TextColor3=Color3.fromRGB(150,150,170)}):Play()end
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=accentColor,TextColor3=Color3.fromRGB(255,255,255)}):Play()
        AutoFarmPage.Visible=page==AutoFarmPage MovementPage.Visible=page==MovementPage ThemePage.Visible=page==ThemePage SettingsPage.Visible=page==SettingsPage
    end)
    table.insert(tabButtons,btn)return btn
end
local afTab=createTabButton("AutoFarm",AutoFarmPage)
local mvTab=createTabButton("Movement",MovementPage)
local thTab=createTabButton("Theme",ThemePage)
local stTab=createTabButton("Settings",SettingsPage)
afTab.BackgroundColor3=accentColor afTab.TextColor3=Color3.fromRGB(255,255,255)

-- AutoFarm Page
local LeftPanel=Instance.new("Frame")LeftPanel.BackgroundTransparency=1 LeftPanel.Size=UDim2.new(0.96,0,1,0)LeftPanel.Parent=AutoFarmPage
local WorldLabel=Instance.new("TextLabel")WorldLabel.BackgroundTransparency=1 WorldLabel.Size=UDim2.new(1,0,0,20)WorldLabel.Font=Enum.Font.GothamSemibold WorldLabel.TextColor3=Color3.fromRGB(200,200,220)WorldLabel.TextSize=14 WorldLabel.Parent=LeftPanel
local WorldsFrame=Instance.new("Frame")WorldsFrame.BackgroundColor3=Color3.fromRGB(16,16,23)WorldsFrame.BackgroundTransparency=0.15 WorldsFrame.Position=UDim2.new(0,0,0,26)WorldsFrame.Size=UDim2.new(1,0,0,44)WorldsFrame.Parent=LeftPanel
Instance.new("UICorner",WorldsFrame).CornerRadius=UDim.new(0,10)

local worldButtons={}
local function createWorldBtn(text,px,wd,idx)
    local btn=Instance.new("TextButton")btn.BackgroundTransparency=1 btn.Position=UDim2.new(px,3,0,3)btn.Size=UDim2.new(wd,-6,1,-6)btn.Font=Enum.Font.GothamBold btn.Text=text btn.TextSize=14 btn.Parent=WorldsFrame
    btn.TextColor3=idx==1 and Color3.fromRGB(255,255,255)or Color3.fromRGB(140,140,160)
    if idx==1 then btn.BackgroundTransparency=0.15 btn.BackgroundColor3=Color3.fromRGB(30,30,42)Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)end
    btn.MouseButton1Click:Connect(function()
        currentWorld=text WorldLabel.Text=string.format(L("WorldLabel"),text)
        for _,b in ipairs(worldButtons)do b.BackgroundTransparency=1 b.TextColor3=Color3.fromRGB(140,140,160)end
        btn.BackgroundTransparency=0.15 btn.BackgroundColor3=Color3.fromRGB(30,30,42)btn.TextColor3=Color3.fromRGB(255,255,255)
        buildDistOpts()
    end)
    table.insert(worldButtons,btn)
end
createWorldBtn("1 World",0,0.25,1)createWorldBtn("2 World",0.25,0.25,2)createWorldBtn("3 World",0.5,0.25,3)createWorldBtn("Bbnos",0.75,0.25,4)

-- Toggle AutoFarm
local ToggleFrame=Instance.new("Frame")ToggleFrame.BackgroundColor3=Color3.fromRGB(16,16,23)ToggleFrame.BackgroundTransparency=0.15 ToggleFrame.Position=UDim2.new(0,0,0,82)ToggleFrame.Size=UDim2.new(1,0,0,56)ToggleFrame.Parent=LeftPanel
Instance.new("UICorner",ToggleFrame).CornerRadius=UDim.new(0,10)
local ToggleLabel=Instance.new("TextLabel")ToggleLabel.BackgroundTransparency=1 ToggleLabel.Position=UDim2.new(0,16,0,0)ToggleLabel.Size=UDim2.new(0.7,0,1,0)ToggleLabel.Font=Enum.Font.GothamBold ToggleLabel.TextColor3=Color3.fromRGB(255,255,255)ToggleLabel.TextSize=15 ToggleLabel.Parent=ToggleFrame
local SwitchBG=Instance.new("TextButton")SwitchBG.BackgroundColor3=Color3.fromRGB(40,40,55)SwitchBG.Position=UDim2.new(1,-65,0.5,-14)SwitchBG.Size=UDim2.new(0,50,0,28)SwitchBG.Text=""SwitchBG.Parent=ToggleFrame
Instance.new("UICorner",SwitchBG).CornerRadius=UDim.new(0,14)
local SwitchDot=Instance.new("Frame")SwitchDot.BackgroundColor3=Color3.fromRGB(255,255,255)SwitchDot.Position=UDim2.new(0,3,0.5,-11)SwitchDot.Size=UDim2.new(0,22,0,22)SwitchDot.Parent=SwitchBG
Instance.new("UICorner",SwitchDot).CornerRadius=UDim.new(0,11)
SwitchBG.MouseButton1Click:Connect(function()
    if not currentDistance then return end
    autoFarmActive=not autoFarmActive
    if autoFarmActive then
        TweenService:Create(SwitchBG,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(34,197,94)}):Play()
        TweenService:Create(SwitchDot,TweenInfo.new(0.2),{Position=UDim2.new(0,25,0.5,-11)}):Play()
        startAutoFarm()
    else
        TweenService:Create(SwitchBG,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(40,40,55)}):Play()
        TweenService:Create(SwitchDot,TweenInfo.new(0.2),{Position=UDim2.new(0,3,0.5,-11)}):Play()
    end
end)

-- Speed Slider
local SliderFrame=Instance.new("Frame")SliderFrame.BackgroundColor3=Color3.fromRGB(16,16,23)SliderFrame.BackgroundTransparency=0.15 SliderFrame.Position=UDim2.new(0,0,0,150)SliderFrame.Size=UDim2.new(1,0,0,68)SliderFrame.Parent=LeftPanel
Instance.new("UICorner",SliderFrame).CornerRadius=UDim.new(0,10)
local SliderLabel=Instance.new("TextLabel")SliderLabel.BackgroundTransparency=1 SliderLabel.Position=UDim2.new(0,16,0,8)SliderLabel.Size=UDim2.new(1,-32,0,20)SliderLabel.Font=Enum.Font.GothamSemibold SliderLabel.TextColor3=Color3.fromRGB(200,200,220)SliderLabel.TextSize=13 SliderLabel.Parent=SliderFrame
local SliderTrack=Instance.new("TextButton")SliderTrack.BackgroundColor3=Color3.fromRGB(32,32,45)SliderTrack.Position=UDim2.new(0,16,0,36)SliderTrack.Size=UDim2.new(1,-32,0,16)SliderTrack.Text=""SliderTrack.Parent=SliderFrame
Instance.new("UICorner",SliderTrack).CornerRadius=UDim.new(0,8)
local SliderFill=Instance.new("Frame")SliderFill.BackgroundColor3=accentColor SliderFill.Size=UDim2.new(1,0,1,0)SliderFill.Parent=SliderTrack
Instance.new("UICorner",SliderFill).CornerRadius=UDim.new(0,8)
local dragSlider=false
local function updateSpeed(i)
    local f=math.clamp((i.Position.X-SliderTrack.AbsolutePosition.X)/SliderTrack.AbsoluteSize.X,0,1)
    currentSpeed=math.floor(f*300)SliderLabel.Text=string.format(L("SpeedLabel"),currentSpeed)
    SliderFill.Size=UDim2.new(f,0,1,0)
end
SliderTrack.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dragSlider=true updateSpeed(i)end end)
UserInputService.InputChanged:Connect(function(i)if dragSlider and i.UserInputType==Enum.UserInputType.MouseMovement then updateSpeed(i)end end)
UserInputService.InputEnded:Connect(function()dragSlider=false end)

-- Distance Dropdown
local DropdownList=Instance.new("ScrollingFrame")
local DropdownBtn=Instance.new("TextButton")
DropdownBtn.BackgroundColor3=Color3.fromRGB(16,16,23)DropdownBtn.BackgroundTransparency=0.15 DropdownBtn.Position=UDim2.new(0,0,0,230)DropdownBtn.Size=UDim2.new(1,0,0,46)DropdownBtn.Font=Enum.Font.GothamBold DropdownBtn.TextColor3=Color3.fromRGB(255,255,255)DropdownBtn.TextSize=14 DropdownBtn.Parent=LeftPanel
Instance.new("UICorner",DropdownBtn).CornerRadius=UDim.new(0,10)
DropdownList.BackgroundColor3=Color3.fromRGB(14,14,20)DropdownList.Position=UDim2.new(0,0,0,282)DropdownList.Size=UDim2.new(1,0,0,100)DropdownList.Visible=false DropdownList.Parent=LeftPanel
DropdownList.AutomaticCanvasSize=Enum.AutomaticSize.Y DropdownList.ScrollBarThickness=4
Instance.new("UICorner",DropdownList).CornerRadius=UDim.new(0,10)
local dLayout=Instance.new("UIListLayout")dLayout.Padding=UDim.new(0,4)dLayout.Parent=DropdownList
DropdownBtn.MouseButton1Click:Connect(function()DropdownList.Visible=not DropdownList.Visible end)

function buildDistOpts()
    for _,c in ipairs(DropdownList:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end
    local opts={}
    if Waypoints[currentWorld]then for d,_ in pairs(Waypoints[currentWorld])do table.insert(opts,d)end
        table.sort(opts,function(a,b)return(distSortOrder[a]or 99)<(distSortOrder[b]or 99)end)end
    if #opts==0 then DropdownBtn.Text="   "..L("NoPoints").." v"currentDistance=nil return end
    for _,opt in ipairs(opts)do
        local btn=Instance.new("TextButton")btn.BackgroundColor3=Color3.fromRGB(22,22,30)btn.Size=UDim2.new(1,0,0,34)btn.Font=Enum.Font.GothamSemibold btn.Text=opt btn.TextColor3=Color3.fromRGB(200,200,220)btn.TextSize=14 btn.Parent=DropdownList
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
        btn.MouseButton1Click:Connect(function()currentDistance=opt DropdownBtn.Text="   "..opt.." v"DropdownList.Visible=false end)
    end
    currentDistance=opts[1]DropdownBtn.Text="   "..currentDistance.." v"
end

-- Movement Page
local MovePanel=Instance.new("ScrollingFrame")MovePanel.BackgroundTransparency=1 MovePanel.Size=UDim2.new(1,0,1,0)MovePanel.ScrollBarThickness=0 MovePanel.CanvasSize=UDim2.new(0,0,0,400)MovePanel.Parent=MovementPage

local function createToggle(parent,y,name,flag)
    local f=Instance.new("Frame")f.BackgroundColor3=Color3.fromRGB(16,16,23)f.BackgroundTransparency=0.15 f.Position=UDim2.new(0,0,0,y)f.Size=UDim2.new(0.96,0,0,56)f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local l=Instance.new("TextLabel")l.BackgroundTransparency=1 l.Position=UDim2.new(0,16,0,0)l.Size=UDim2.new(0.7,0,1,0)l.Font=Enum.Font.GothamBold l.TextColor3=Color3.fromRGB(255,255,255)l.TextSize=15 l.Text=name l.Parent=f
    local sb=Instance.new("TextButton")sb.BackgroundColor3=Color3.fromRGB(40,40,55)sb.Position=UDim2.new(1,-65,0.5,-14)sb.Size=UDim2.new(0,50,0,28)sb.Text=""sb.Parent=f
    Instance.new("UICorner",sb).CornerRadius=UDim.new(0,14)
    local sd=Instance.new("Frame")sd.BackgroundColor3=Color3.fromRGB(255,255,255)sd.Position=UDim2.new(0,3,0.5,-11)sd.Size=UDim2.new(0,22,0,22)sd.Parent=sb
    Instance.new("UICorner",sd).CornerRadius=UDim.new(0,11)
    sb.MouseButton1Click:Connect(function()
        FurdjeHub.Flags[flag]=not FurdjeHub.Flags[flag]
        if FurdjeHub.Flags[flag]then
            TweenService:Create(sb,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(34,197,94)}):Play()
            TweenService:Create(sd,TweenInfo.new(0.2),{Position=UDim2.new(0,25,0.5,-11)}):Play()
        else
            TweenService:Create(sb,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(40,40,55)}):Play()
            TweenService:Create(sd,TweenInfo.new(0.2),{Position=UDim2.new(0,3,0.5,-11)}):Play()
        end
    end)
    return f
end

createToggle(MovePanel,10,"Infinity Jump","InfJump")
createToggle(MovePanel,78,"Fly (WASD)","Fly")
createToggle(MovePanel,146,"Noclip","NoClip")
createToggle(MovePanel,214,"ESP","ESP")
createToggle(MovePanel,282,"Aimbot","Aimbot")

-- Settings Page
local SetPanel=Instance.new("ScrollingFrame")SetPanel.BackgroundTransparency=1 SetPanel.Size=UDim2.new(1,0,1,0)SetPanel.ScrollBarThickness=0 SetPanel.CanvasSize=UDim2.new(0,0,0,300)SetPanel.Parent=SettingsPage

createToggle(SetPanel,10,"Speed Hack","SpeedHack")
createToggle(SetPanel,78,"Auto Click","AutoClick")

local function createSlider(parent,y,name,flag,min,max,def)
    local f=Instance.new("Frame")f.BackgroundColor3=Color3.fromRGB(16,16,23)f.BackgroundTransparency=0.15 f.Position=UDim2.new(0,0,0,y)f.Size=UDim2.new(0.96,0,0,68)f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local l=Instance.new("TextLabel")l.BackgroundTransparency=1 l.Position=UDim2.new(0,16,0,8)l.Size=UDim2.new(1,-32,0,20)l.Font=Enum.Font.GothamSemibold l.TextColor3=Color3.fromRGB(200,200,220)l.TextSize=13 l.Text=name..": "..def l.Parent=f
    local t=Instance.new("TextButton")t.BackgroundColor3=Color3.fromRGB(32,32,45)t.Position=UDim2.new(0,16,0,36)t.Size=UDim2.new(1,-32,0,16)t.Text=""t.Parent=f
    Instance.new("UICorner",t).CornerRadius=UDim.new(0,8)
    local fl=Instance.new("Frame")fl.BackgroundColor3=accentColor fl.Size=UDim2.new((def-min)/(max-min),0,1,0)fl.Parent=t
    Instance.new("UICorner",fl).CornerRadius=UDim.new(0,8)
    FurdjeHub.Settings[flag]=def
    local dg=false
    t.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=true end end)
    UserInputService.InputChanged:Connect(function(i)if dg and i.UserInputType==Enum.UserInputType.MouseMovement then
        local f2=math.clamp((i.Position.X-t.AbsolutePosition.X)/t.AbsoluteSize.X,0,1)
        local v=math.floor(min+f2*(max-min))
        fl.Size=UDim2.new(f2,0,1,0)FurdjeHub.Settings[flag]=v l.Text=name..": "..v
    end end)
    UserInputService.InputEnded:Connect(function()dg=false end)
end

createSlider(SetPanel,146,"Speed Value","SpeedValue",10,200,50)
createSlider(SetPanel,220,"Jump Power","JumpPower",10,200,50)
createSlider(SetPanel,294,"Walk Speed","WalkSpeed",10,50,16)

local function createButton(parent,y,text,cb)
    local b=Instance.new("TextButton")b.BackgroundColor3=Color3.fromRGB(16,16,23)b.BackgroundTransparency=0.15 b.Position=UDim2.new(0,0,0,y)b.Size=UDim2.new(0.96,0,0,46)b.Font=Enum.Font.GothamBold b.Text=text b.TextColor3=Color3.fromRGB(255,255,255)b.TextSize=15 b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    b.MouseButton1Click:Connect(cb)
end

createButton(SetPanel,360,"Save Settings",function()FurdjeHub.Functions.SaveSettings()end)
createButton(SetPanel,412,"Load Settings",function()FurdjeHub.Functions.LoadSettings()end)

-- Theme Page
local ThemeScroll=Instance.new("ScrollingFrame")ThemeScroll.BackgroundTransparency=1 ThemeScroll.Size=UDim2.new(1,0,1,0)ThemeScroll.Parent=ThemePage
local ThemeList=Instance.new("UIListLayout")ThemeList.Padding=UDim.new(0,10)ThemeList.Parent=ThemeScroll
local themes={Color3.fromRGB(0,150,255),Color3.fromRGB(168,85,247),Color3.fromRGB(34,197,94),Color3.fromRGB(236,72,153),Color3.fromRGB(245,158,11),Color3.fromRGB(220,220,230)}
for i,c in ipairs(themes)do
    local b=Instance.new("TextButton")b.BackgroundColor3=Color3.fromRGB(16,16,23)b.Size=UDim2.new(1,-10,0,52)b.Text=""b.Parent=ThemeScroll
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local cr=Instance.new("Frame")cr.Size=UDim2.new(0,26,0,26)cr.Position=UDim2.new(0,16,0.5,-13)cr.BackgroundColor3=c cr.Parent=b
    Instance.new("UICorner",cr).CornerRadius=UDim.new(1,0)
    b.MouseButton1Click:Connect(function()accentColor=c end)
end

-- Apply Language
function applyLanguage()
    LangTitle.Text=L("ChooseLang")
    WorldLabel.Text=string.format(L("WorldLabel"),currentWorld)
    afTab.Text=L("AutoFarmTab")mvTab.Text=L("MovementTab")thTab.Text=L("ThemeTab")stTab.Text=L("AdminTab")
    ToggleLabel.Text=L("AutoFarmToggle")SliderLabel.Text=string.format(L("SpeedLabel"),currentSpeed)
    DropdownBtn.Text="   "..(currentDistance or L("SelectDist")).." v"
end

-- Init
buildDistOpts()applyLanguage()LangFrame.Visible=true toggleMenu(true)

-- Start all function loops
spawn(function()FurdjeHub.Functions.AutoFarm()end)
spawn(function()FurdjeHub.Functions.AutoClick()end)
spawn(function()FurdjeHub.Functions.SpeedHack()end)
spawn(function()FurdjeHub.Functions.Fly()end)
spawn(function()FurdjeHub.Functions.NoClip()end)
spawn(function()FurdjeHub.Functions.ESP()end)
spawn(function()FurdjeHub.Functions.Aimbot()end)

print("FurdjeHub loaded!")        local delta = input.Position - dragStart
        window.Position = UDim2.new(dragOffset.X.Scale, dragOffset.X.Offset + delta.X, dragOffset.Y.Scale, dragOffset.Y.Offset + delta.Y)
    end
end)

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

local function addSliderWithButtons(text, minVal, maxVal, defaultVal, callback, step)
    step = step or 1
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = canvas
    yPos = yPos + 5
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
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
        value = math.max(value - step, minVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    plusBtn.MouseButton1Click:Connect(function()
        value = math.min(value + step, maxVal)
        valueDisplay.Text = tostring(value)
        label.Text = text .. ": " .. value
        callback(value)
    end)
    
    yPos = yPos + 45
    canvas.Size = UDim2.new(1, 0, 0, yPos)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
    return container
end

-- ===== ФУНКЦИЯ ОПРЕДЕЛЕНИЯ РОЛИ =====
local function getPlayerRole(v)
    if v:FindFirstChild("murder") then
        return "murderer"
    elseif v:FindFirstChild("sheriff") then
        return "sheriff"
    end
    
    if v.Character and v.Character:FindFirstChild("Knife") then
        return "murderer"
    end
    if v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun")) then
        return "sheriff"
    end
    
    return "innocent"
end

-- ===== WALLHACK =====
local function updateWallhack(state)
    wallhackEnabled = state
    
    for _, v in pairs(wallhackBillboards) do
        pcall(function() v:Destroy() end)
    end
    wallhackBillboards = {}
    
    for _, con in pairs(wallhackConnections) do
        pcall(function() con:Disconnect() end)
    end
    wallhackConnections = {}
    
    if state then
        wallhackConnections = {}
        
        local function createWallhackForPlayer(v)
            if v == player then return end
            if not v.Character or not v.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = v.Character.HumanoidRootPart
            local role = getPlayerRole(v)
            local color = Color3.fromRGB(255, 255, 255)
            local roleText = "Innocent"
            
            if role == "murderer" then
                color = Color3.fromRGB(255, 0, 0)
                roleText = "🔪 Murderer"
            elseif role == "sheriff" then
                color = Color3.fromRGB(0, 100, 255)
                roleText = "⭐ Sheriff"
            end
            
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.Adornee = rootPart
            billboard.StudsOffset = Vector3.new(0, 4, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = rootPart
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = v.Name
            nameLabel.TextColor3 = color
            nameLabel.TextSize = 16
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
            
            local roleLabel = Instance.new("TextLabel")
            roleLabel.Size = UDim2.new(1, 0, 0.5, 0)
            roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
            roleLabel.BackgroundTransparency = 1
            roleLabel.Text = roleText
            roleLabel.TextColor3 = color
            roleLabel.TextSize = 14
            roleLabel.TextStrokeTransparency = 0
            roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            roleLabel.Font = Enum.Font.Gotham
            roleLabel.Parent = billboard
            
            table.insert(wallhackBillboards, billboard)
            
            local hl = Instance.new("Highlight")
            hl.Parent = v.Character
            hl.Adornee = v.Character
            hl.FillColor = color
            hl.FillTransparency = 0.7
            hl.OutlineColor = color
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            table.insert(wallhackBillboards, hl)
        end
        
        for _, v in pairs(game.Players:GetPlayers()) do
            createWallhackForPlayer(v)
        end
        
        local playerAddedCon = game.Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function()
                wait(0.5)
                if wallhackEnabled then
                    createWallhackForPlayer(v)
                end
            end)
        end)
        table.insert(wallhackConnections, playerAddedCon)
        
        local roleCheckCon = RunService.RenderStepped:Connect(function()
            if wallhackEnabled then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local role = getPlayerRole(v)
                        local color = Color3.fromRGB(255, 255, 255)
                        local roleText = "Innocent"
                        
                        if role == "murderer" then
                            color = Color3.fromRGB(255, 0, 0)
                            roleText = "🔪 Murderer"
                        elseif role == "sheriff" then
                            color = Color3.fromRGB(0, 100, 255)
                            roleText = "⭐ Sheriff"
                        end
                        
                        for _, billboard in pairs(wallhackBillboards) do
                            if billboard:IsA("BillboardGui") and billboard.Adornee and billboard.Adornee.Parent == v.Character then
                                local nameLabel = billboard:FindFirstChild("TextLabel")
                                local roleLabel = billboard:FindFirstChild("TextLabel")
                                if nameLabel then
                                    nameLabel.TextColor3 = color
                                end
                                if roleLabel then
                                    roleLabel.Text = roleText
                                    roleLabel.TextColor3 = color
                                end
                            end
                            if billboard:IsA("Highlight") and billboard.Parent == v.Character then
                                billboard.FillColor = color
                                billboard.OutlineColor = color
                            end
                        end
                    end
                end
            end
        end)
        table.insert(wallhackConnections, roleCheckCon)
    else
        for _, v in pairs(wallhackBillboards) do
            pcall(function() v:Destroy() end)
        end
        wallhackBillboards = {}
    end
end

-- ===== AUTO SHOOT =====
local function createShootButton()
    if shootButton then
        shootButton:Destroy()
        shootButton = nil
    end
    
    shootButton = Instance.new("TextButton")
    shootButton.Size = UDim2.new(0, 80, 0, 80)
    shootButton.Position = UDim2.new(0.8, -40, 0.6, -40)
    shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    shootButton.Text = "🔫\nAUTO\nSHOOT"
    shootButton.TextSize = 12
    shootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shootButton.BorderSizePixel = 3
    shootButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    shootButton.Parent = screenGui
    shootButton.Visible = false
    shootButton.ZIndex = 999
    shootButton.Selectable = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = shootButton
    
    shootButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            shootButtonDragging = true
            shootButtonDragStart = input.Position
            shootButtonDragOffset = shootButton.Position
        end
    end)
    
    shootButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            shootButtonDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if shootButtonDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - shootButtonDragStart
            shootButton.Position = UDim2.new(shootButtonDragOffset.X.Scale, shootButtonDragOffset.X.Offset + delta.X, 
                                             shootButtonDragOffset.Y.Scale, shootButtonDragOffset.Y.Offset + delta.Y)
        end
    end)
    
    shootButton.MouseButton1Click:Connect(function()
        if not autoShootEnabled then return end
        
        local hasGun = false
        if character and character:FindFirstChild("Gun") then
            hasGun = true
        end
        if not hasGun and character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("gun") then
                    hasGun = true
                    break
                end
            end
        end
        
        if not hasGun then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                    if v.Parent.Name:lower():find("gun") then
                        local dist = (root.Position - v.Position).Magnitude
                        if dist < 200 then
                            local oldPos = root.CFrame
                            root.CFrame = v.CFrame * CFrame.new(0, 1, 0)
                            wait(0.05)
                            pcall(function()
                                local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                if mm2 and mm2:FindFirstChild("Knife") then
                                    mm2.Knife:FireServer(v.Parent)
                                end
                            end)
                            root.CFrame = oldPos
                            wait(0.2)
                            break
                        end
                    end
                end
            end
        end
        
        local target = nil
        local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if getPlayerRole(v) == "murderer" then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = v
                    end
                end
            end
        end
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local oldCFrame = Camera.CFrame
            
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            
            local success = false
            local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            
            if mm2 then
                local remoteNames = {"Gun", "Shoot", "Fire", "GunRemote", "ShootRemote"}
                for _, name in ipairs(remoteNames) do
                    local remote = mm2:FindFirstChild(name)
                    if remote then
                        pcall(function()
                            remote:FireServer(target.Character.HumanoidRootPart)
                            success = true
                        end)
                        if success then break end
                    end
                end
                
                if not success then
                    pcall(function()
                        for _, remote in pairs(mm2:GetChildren()) do
                            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                                pcall(function()
                                    remote:FireServer(target.Character)
                                    success = true
                                end)
                                if success then break end
                            end
                        end
                    end)
                end
            end
            
            Camera.CFrame = oldCFrame
            
            if success then
                shootButton.BackgroundColor3 = Color3.fromRGB(0, 255, 50)
                wait(0.1)
                shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            else
                shootButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                wait(0.1)
                shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            end
        else
            shootButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            wait(0.1)
            shootButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        end
    end)
end

local function updateAutoShoot(state)
    autoShootEnabled = state
    if state then
        if not shootButton then
            createShootButton()
        end
        shootButton.Visible = true
    else
        if shootButton then
            shootButton.Visible = false
        end
    end
end

-- ===== ESP =====
local function updateESPContinuous()
    if espUpdateConnection then
        espUpdateConnection:Disconnect()
        espUpdateConnection = nil
    end
    
    espUpdateConnection = RunService.RenderStepped:Connect(function()
        for _, hl in pairs(espHighlights) do
            pcall(function() hl:Destroy() end)
        end
        espHighlights = {}
        
        if espMurderEnabled or espSheriffEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = v.Character.HumanoidRootPart
                    local dist = (root.Position - rootPart.Position).Magnitude
                    
                    if dist <= espDistance then
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
                            hl.FillTransparency = 0.8
                            hl.OutlineColor = color
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            espHighlights[v] = hl
                        end
                    end
                end
            end
        end
    end)
end

-- ===== GOD MODE =====
local function updateGodMode(state)
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    godModeEnabled = state
    if state then
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.MaxHealth = 1000
            character.Humanoid.Health = 1000
        end
        godModeConnection = player.CharacterAdded:Connect(function(char)
            wait(0.5)
            local h = char:FindFirstChild("Humanoid")
            if h then
                h.MaxHealth = 1000
                h.Health = 1000
            end
        end)
    else
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.MaxHealth = 100
            character.Humanoid.Health = 100
        end
    end
end

-- ===== ANTI STUN =====
local function updateAntiStun(state)
    if antiStunConnection then
        antiStunConnection:Disconnect()
        antiStunConnection = nil
    end
    antiStunEnabled = state
    if state then
        antiStunConnection = RunService.Heartbeat:Connect(function()
            if antiStunEnabled and character then
                local h = character:FindFirstChild("Humanoid")
                if h and h:GetState() == Enum.HumanoidStateType.Stunned then
                    h:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end
end

-- ===== NO FOG =====
local function updateNoFog(state)
    if noFogConnection then
        noFogConnection:Disconnect()
        noFogConnection = nil
    end
    noFogEnabled = state
    if state then
        noFogConnection = RunService.RenderStepped:Connect(function()
            if noFogEnabled and workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = nil
            end
        end)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Atmosphere") or v:IsA("Fog") then
                v.Enabled = false
            end
        end
        workspace.CurrentCamera.FieldOfView = 120
    else
        workspace.CurrentCamera.FieldOfView = 70
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Atmosphere") or v:IsA("Fog") then
                v.Enabled = true
            end
        end
    end
end

-- ===== INVISIBILITY =====
local function updateInvisibility(state)
    invisibilityEnabled = state
    
    if state then
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    table.insert(invisibleParts, part)
                end
            end
        end
        if root then
            root.CanCollide = false
        end
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end
        if humanoid then
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
    else
        for _, part in ipairs(invisibleParts) do
            pcall(function()
                if part and part.Parent then
                    part.Transparency = 0
                    part.CastShadow = true
                end
            end)
        end
        invisibleParts = {}
        if root then
            root.CanCollide = true
        end
        if humanoid then
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end
    end
end

-- ===== AUTO KNIFE =====
local function updateAutoKnife(state)
    if autoKnifeConnection then
        autoKnifeConnection:Disconnect()
        autoKnifeConnection = nil
    end
    autoKnifeEnabled = state
    if state then
        autoKnifeConnection = RunService.Heartbeat:Connect(function()
            if autoKnifeEnabled and character then
                local knife = character:FindFirstChild("Knife")
                if knife then
                    local target = nil
                    local dist = math.huge
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist and d < 20 then
                                dist = d
                                target = v
                            end
                        end
                    end
                    if target then
                        pcall(function()
                            local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                            if mm2 and mm2:FindFirstChild("Knife") then
                                mm2.Knife:FireServer(target.Character.HumanoidRootPart)
                            end
                        end)
                    end
                end
            end
        end)
    end
end

-- ===== INSTANT RESPAWN =====
local function updateInstantRespawn(state)
    if instantRespawnConnection then
        instantRespawnConnection:Disconnect()
        instantRespawnConnection = nil
    end
    instantRespawnEnabled = state
    if state then
        instantRespawnConnection = RunService.Heartbeat:Connect(function()
            if instantRespawnEnabled then
                if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
                    for _, v in pairs(player.PlayerGui:GetDescendants()) do
                        if v:IsA("TextButton") and (v.Name:lower():find("respawn") or v.Text:lower():find("respawn")) then
                            pcall(function() v:Click() end)
                            break
                        end
                    end
                    pcall(function()
                        local mm2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if mm2 and mm2:FindFirstChild("Respawn") then
                            mm2.Respawn:FireServer()
                        end
                    end)
                end
            end
        end)
    end
end

-- ===== ANTI AFK =====
local function updateAntiAfk(state)
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    antiAfkEnabled = state
    if state then
        antiAfkStartCFrame = root.CFrame
        local step = 0
        
        antiAfkConnection = RunService.Heartbeat:Connect(function()
            if antiAfkEnabled and character and root then
                step = step + 1
                local offset = Vector3.new(0, 0, 0)
                
                if step % 10 == 0 then
                    offset = Vector3.new(0.5, 0, 0)
                elseif step % 10 == 5 then
                    offset = Vector3.new(-0.5, 0, 0)
                end
                
                root.CFrame = antiAfkStartCFrame + offset
                
                if step % 20 == 0 and humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait(0.05)
                end
                
                if step % 15 == 0 then
                    root.CFrame = antiAfkStartCFrame
                end
            end
        end)
    else
        if antiAfkStartCFrame and root then
            root.CFrame = antiAfkStartCFrame
        end
        antiAfkStartCFrame = nil
    end
end

-- ===== MEGA FLING ВНИЗ (ИСПРАВЛЕН) =====
local flingMurdererEnabled = false
local flingSheriffEnabled = false
local flingMurdererConnection = nil
local flingSheriffConnection = nil
local flingTargets = {}

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
                            -- Телепортируемся к цели
                            root.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(360), 0)
                            -- ВЫКИДЫВАЕМ ВНИЗ С БЕШЕНОЙ СКОРОСТЬЮ
                            hrp.Velocity = Vector3.new(math.random(-2000, 2000), -5000, math.random(-2000, 2000))
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, -50, 0)
                            hrp.RotVelocity = Vector3.new(math.random(-2000, 2000), math.random(-2000, 2000), math.random(-2000, 2000))
                            for _, part in pairs(v.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                            flingTargets[v] = os.time()
                        end
                    end
                end
            end
        end)
    else
        flingTargets = {}
    end
end

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
                            root.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(360), 0)
                            -- ВЫКИДЫВАЕМ ВНИЗ С БЕШЕНОЙ СКОРОСТЬЮ
                            hrp.Velocity = Vector3.new(math.random(-2000, 2000), -5000, math.random(-2000, 2000))
                            hrp.CFrame = hrp.CFrame * CFrame.new(0, -50, 0)
                            hrp.RotVelocity = Vector3.new(math.random(-2000, 2000), math.random(-2000, 2000), math.random(-2000, 2000))
                            for _, part in pairs(v.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                            flingTargets[v] = os.time()
                        end
                    end
                end
            end
        end)
    else
        flingTargets = {}
    end
end

-- ===== AUTO COLLECT =====
local autoCollectEnabled = false
local autoCollectConnection = nil

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
                        if dist < 150 then
                            local oldPos = root.CFrame
                            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                            wait(0.05)
                            root.CFrame = oldPos
                            break
                        end
                    end
                end
            end
        end)
    end
end

-- Остальные функции
local noclipEnabled = false
local autoGrabEnabled = false
local infJumpEnabled = false
local antiFlingEnabled = false
local noclipConnection = nil
local autoGrabConnection = nil
local infJumpConnection = nil
local antiFlingConnection = nil
local speedValue = 16
local lastPosition = nil

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

local function updateAntiFling(state)
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
    antiFlingEnabled = state
    if state then
        lastPosition = root.Position
        antiFlingConnection = RunService.Heartbeat:Connect(function()
            if antiFlingEnabled and root and character then
                local currentPos = root.Position
                
                if currentPos.Y < -50 then
                    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
                    if spawn then
                        root.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
                    else
                        root.CFrame = CFrame.new(0, 50, 0)
                    end
                    return
                end
                
                if lastPosition then
                    local distance = (currentPos - lastPosition).Magnitude
                    if distance > 50 and distance < 500 then
                        root.CFrame = CFrame.new(lastPosition)
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
                
                lastPosition = currentPos
            end
        end)
    else
        lastPosition = nil
    end
end

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

local function updateSpeed(value)
    speedValue = value
    if humanoid then
        humanoid.WalkSpeed = value
    end
end

local function teleportToMurderer()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if getPlayerRole(v) == "murderer" then
                root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                return
            end
        end
    end
    showNotification("🔪 Убийца не найден!", Color3.fromRGB(200, 150, 40))
end

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

local function teleportToSheriff()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "sheriff" then
            root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            return
        end
    end
    showNotification("⭐ Шериф не найден!", Color3.fromRGB(200, 150, 40))
end

local function showNotification(text, color)
    color = color or Color3.fromRGB(0, 150, 70)
    local notif = Instance.new("ScreenGui")
    notif.Name = "Notification"
    notif.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 60)
    frame.Position = UDim2.new(0.5, -200, 0.5, -30)
    frame.BackgroundColor3 = color
    frame.Parent = notif
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    task.wait(2)
    notif:Destroy()
end

addSection("════ MAIN ════")
addToggle("No Clip", updateNoclip)
addToggle("Auto Grab Gun", updateAutoGrab)
addToggle("INF Jump", updateInfJump)

addSection("═══ COMBAT ═══")
addToggle("Auto Shoot (Button)", updateAutoShoot)
addToggle("Auto Knife", updateAutoKnife)

addSection("═══ STEALTH ═══")
addToggle("Invisibility (Not Visible)", updateInvisibility)

addSection("═══ PROTECTION ═══")
addToggle("Anti Fling / Anti Fall", updateAntiFling)
addToggle("Instant Respawn", updateInstantRespawn)
addToggle("God Mode", updateGodMode)
addToggle("Anti Stun", updateAntiStun)

addSection("═══ VISUAL ═══")
addToggle("Wallhack (Players Through Walls)", updateWallhack)
addToggle("ESP Murder (Red Outline)", function(state) espMurderEnabled = state; updateESPContinuous() end)
addToggle("ESP Sheriff (Blue Outline)", function(state) espSheriffEnabled = state; updateESPContinuous() end)
addToggle("No Fog / Zoom", updateNoFog)

addSection("═══ FLING ═══")
addToggle("MEGA FLING Murderer (DOWN)", updateFlingMurderer)
addToggle("MEGA FLING Sheriff (DOWN)", updateFlingSheriff)

addSection("═══ AUTO COLLECT ═══")
addToggle("Auto Collect Coins", updateAutoCollect)

addSection("═══ TELEPORT ═══")
addButton("To Lobby", Color3.fromRGB(40, 60, 90), teleportToSpawn)
addButton("To Murderer", Color3.fromRGB(90, 40, 40), teleportToMurderer)
addButton("To Sheriff", Color3.fromRGB(40, 40, 90), teleportToSheriff)

addSection("═══ EXTRA ═══")
addSliderWithButtons("Speed Boost", 16, 120, 16, updateSpeed, 2)
addToggle("Anti AFK (Slow)", updateAntiAfk)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    window.Visible = false
end)

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
        wait(0.5)
        updateESPContinuous()
    end
end)

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
        end
        return oldNamecall(self, ...)
    end)
end
bypassAntiCheat()

print("⚡ MM2 Ultimate Hub loaded (MEGA FLING DOWN)!")
