-- Dead Rails GUI Mobile Edition | @Snowmanme
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local PlayerGui = player:WaitForChild("PlayerGui")

-- Определение типа устройства
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_DESKTOP = UserInputService.MouseEnabled

-- Main ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DeadRailsGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

-- Floating Toggle Button (больше для мобильных устройств)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, IS_MOBILE and 80 or 60, 0, IS_MOBILE and 80 or 60)
toggleBtn.Position = UDim2.new(1, IS_MOBILE and -90 or -70, 0, IS_MOBILE and 20 or 10)
toggleBtn.AnchorPoint = Vector2.new(1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "☰"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true
toggleBtn.BorderSizePixel = 0
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.ZIndex = 10
toggleBtn.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, IS_MOBILE and 40 or 30)
toggleCorner.Parent = toggleBtn

-- Main Frame (больше для мобильных устройств)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, IS_MOBILE and 350 or 400, 0, IS_MOBILE and 550 or 500)
frame.Position = UDim2.new(0.5, IS_MOBILE and -175 or -200, 0.5, IS_MOBILE and -275 or -250)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ClipsDescendants = true
frame.ZIndex = 2
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, IS_MOBILE and 60 or 50)
title.Text = "Dead Rails GUI Mobile"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = frame

-- Close Button (больше для мобильных устройств)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, IS_MOBILE and 50 or 40, 0, IS_MOBILE and 50 or 40)
closeBtn.Position = UDim2.new(1, IS_MOBILE and -60 or -50, 0, IS_MOBILE and 5 or 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextScaled = true
closeBtn.ZIndex = 3
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Helper Function: Create Buttons (больше для мобильных устройств)
local function createButton(text, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, IS_MOBILE and 310 or 360, 0, IS_MOBILE and 60 or 50)
	btn.Position = UDim2.new(0.5, IS_MOBILE and -155 or -180, 0, y)
	btn.AnchorPoint = Vector2.new(0.5, 0)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.ZIndex = 3
	btn.Parent = frame
	
	-- Увеличиваем область нажатия для мобильных устройств
	if IS_MOBILE then
		btn.TextSize = 18
	end
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 10)
	btnCorner.Parent = btn
	
	-- Обработка нажатия с учетом мобильных устройств
	local function handleClick()
		if callback then
			callback()
		end
	end
	
	if IS_MOBILE then
		btn.TouchTap:Connect(handleClick)
	else
		btn.MouseButton1Click:Connect(handleClick)
	end
	
	return btn
end

-- Helper Function: Create TextBox (больше для мобильных устройств)
local function createTextBox(y, defaultText, callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, IS_MOBILE and 310 or 360, 0, IS_MOBILE and 50 or 40)
	box.Position = UDim2.new(0.5, IS_MOBILE and -155 or -180, 0, y)
	box.AnchorPoint = Vector2.new(0.5, 0)
	box.Text = defaultText
	box.PlaceholderText = defaultText
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.SourceSans
	box.TextSize = IS_MOBILE and 16 or 14
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0
	box.ZIndex = 3
	box.Parent = frame
	
	-- Улучшаем ввод для мобильных устройств
	if IS_MOBILE then
		box.TextWrapped = true
	end
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 8)
	boxCorner.Parent = box
	
	box.FocusLost:Connect(function(enterPressed)
		if callback then
			callback(box.Text)
		end
	end)
	
	return box
end

-- Helper Function: Create Label (больше для мобильных устройств)
local function createLabel(text, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, IS_MOBILE and 310 or 360, 0, IS_MOBILE and 40 or 30)
	label.Position = UDim2.new(0.5, IS_MOBILE and -155 or -180, 0, y)
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.SourceSans
	label.TextSize = IS_MOBILE and 16 or 14
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.ZIndex = 3
	label.Parent = frame
	return label
end

-- Toggle Menu Animation
local function toggleMenu()
	frame.Visible = not frame.Visible
	if frame.Visible then
		frame:TweenPosition(
			UDim2.new(0.5, IS_MOBILE and -175 or -200, 0.5, IS_MOBILE and -275 or -250),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.3,
			true
		)
	end
end

-- Обработка нажатий с учетом мобильных устройств
if IS_MOBILE then
	toggleBtn.TouchTap:Connect(toggleMenu)
	closeBtn.TouchTap:Connect(toggleMenu)
else
	toggleBtn.MouseButton1Click:Connect(toggleMenu)
	closeBtn.MouseButton1Click:Connect(toggleMenu)
end

-- ESP Functionality
local ESP_ENABLED = false
local ESP_RADIUS = 100
local espConnections = {}
local espLabels = {}

local function createESP(player)
	if player == game.Players.LocalPlayer or not player.Character then return end
	local char = player.Character
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = root
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	billboard.Parent = gui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 25)
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextScaled = true
	nameLabel.Parent = billboard

	local distLabel = Instance.new("TextLabel")
	distLabel.Size = UDim2.new(1, 0, 0, 25)
	distLabel.Position = UDim2.new(0, 0, 0, 25)
	distLabel.Text = "Distance: Calculating..."
	distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	distLabel.BackgroundTransparency = 1
	distLabel.Font = Enum.Font.SourceSans
	distLabel.TextScaled = true
	distLabel.Parent = billboard

	espLabels[player] = {billboard = billboard, distLabel = distLabel}
end

local function updateESP()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	
	for plr, data in pairs(espLabels) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist <= ESP_RADIUS then
				data.billboard.Enabled = true
				data.distLabel.Text = string.format("Distance: %.1f studs", dist)
				
				-- Изменение цвета в зависимости от расстояния
				if dist < ESP_RADIUS * 0.3 then
					data.distLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный для близких
				elseif dist < ESP_RADIUS * 0.7 then
					data.distLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый для средних
				else
					data.distLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый для далеких
				end
			else
				data.billboard.Enabled = false
			end
		else
			data.billboard.Enabled = false
		end
	end
end

local function toggleESP()
	ESP_ENABLED = not ESP_ENABLED
	if ESP_ENABLED then
		for _, plr in pairs(Players:GetPlayers()) do
			createESP(plr)
		end
		table.insert(espConnections, Players.PlayerAdded:Connect(createESP))
		table.insert(espConnections, RunService.RenderStepped:Connect(updateESP))
	else
		for _, conn in pairs(espConnections) do
			conn:Disconnect()
		end
		espConnections = {}
		for _, data in pairs(espLabels) do
			data.billboard:Destroy()
		end
		espLabels = {}
	end
end

-- Aimbot Functionality
local AIMBOT_ENABLED = false
local AIMBOT_FOV = 100
local aimbotConnection
local aimbotTarget = nil

local function getClosestPlayer()
	local closestPlayer = nil
	local closestDist = AIMBOT_FOV
	local mousePos = UserInputService:GetMouseLocation()

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local root = plr.Character.HumanoidRootPart
			local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
			if onScreen then
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestPlayer = plr
				end
			end
		end
	end
	return closestPlayer
end

local function toggleAimbot()
	AIMBOT_ENABLED = not AIMBOT_ENABLED
	if AIMBOT_ENABLED then
		aimbotConnection = RunService.RenderStepped:Connect(function()
			aimbotTarget = getClosestPlayer()
			if aimbotTarget and aimbotTarget.Character and aimbotTarget.Character:FindFirstChild("HumanoidRootPart") then
				local targetPos = aimbotTarget.Character.HumanoidRootPart.Position
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
			end
		end)
	else
		if aimbotConnection then
			aimbotConnection:Disconnect()
		end
		aimbotTarget = nil
	end
end

-- Speed Functionality
local function setSpeed(speedText)
	local speed = tonumber(speedText)
	if speed and speed >= 1 and speed <= 500 then
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = speed
		end
	end
end

-- No-Clip Functionality
local NOCLIP_ENABLED = false
local noclipConnection

local function toggleNoClip()
	NOCLIP_ENABLED = not NOCLIP_ENABLED
	if NOCLIP_ENABLED then
		noclipConnection = RunService.Stepped:Connect(function()
			if player.Character then
				for _, part in pairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end

-- Fly Functionality (улучшенная версия для мобильных устройств)
local FLY_ENABLED = false
local flyConnection
local flySpeed = 50

local function toggleFly()
	FLY_ENABLED = not FLY_ENABLED
	
	if FLY_ENABLED then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = player.Character:FindFirstChild("HumanoidRootPart")
		
		local function updateFly()
			if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
				if flyConnection then flyConnection:Disconnect() end
				return 
			end
			
			local root = player.Character.HumanoidRootPart
			local cam = workspace.CurrentCamera.CFrame
			
			local vel = Vector3.new(0, 0, 0)
			
			if IS_MOBILE then
				-- Управление для мобильных устройств
				local touchInputs = UserInputService:GetTouchInputs()
				for _, touch in pairs(touchInputs) do
					if touch.Position.X < gui.AbsoluteSize.X / 2 then
						-- Левая часть экрана - движение вперед/назад/вбок
						if touch.Position.Y < gui.AbsoluteSize.Y / 3 then
							vel = vel + cam.LookVector * flySpeed -- Вперед
						elseif touch.Position.Y > gui.AbsoluteSize.Y * 2/3 then
							vel = vel - cam.LookVector * flySpeed -- Назад
						else
							vel = vel + cam.RightVector * flySpeed -- Вправо
						end
					else
						-- Правая часть экрана - подъем/спуск
						if touch.Position.Y < gui.AbsoluteSize.Y / 2 then
							vel = vel + Vector3.new(0, flySpeed, 0) -- Вверх
						else
							vel = vel - Vector3.new(0, flySpeed, 0) -- Вниз
						end
					end
				end
			else
				-- Управление для ПК
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					vel = vel + cam.LookVector * flySpeed
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					vel = vel - cam.LookVector * flySpeed
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					vel = vel - cam.RightVector * flySpeed
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					vel = vel + cam.RightVector * flySpeed
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					vel = vel + Vector3.new(0, flySpeed, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					vel = vel - Vector3.new(0, flySpeed, 0)
				end
			end
			
			bodyVelocity.Velocity = vel
		end
		
		flyConnection = RunService.Heartbeat:Connect(updateFly)
	else
		if flyConnection then
			flyConnection:Disconnect()
		end
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local bodyVelocity = player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
			if bodyVelocity then
				bodyVelocity:Destroy()
			end
		end
	end
end

-- GUI Elements
local espRadiusLabel = createLabel("ESP Radius: 100 studs", 70)
local espBtn = createButton("Toggle ESP (OFF)", 120, function()
	toggleESP()
	espBtn.Text = "Toggle ESP (" .. (ESP_ENABLED and "ON" or "OFF") .. ")"
end)

local espRadiusBox = createTextBox(190, "100", function(text)
	local radius = tonumber(text)
	if radius and radius >= 10 and radius <= 1000 then
		ESP_RADIUS = radius
		espRadiusLabel.Text = string.format("ESP Radius: %.0f studs", ESP_RADIUS)
	end
end)

local aimbotBtn = createButton("Toggle Aimbot (OFF)", 260, function()
	toggleAimbot()
	aimbotBtn.Text = "Toggle Aimbot (" .. (AIMBOT_ENABLED and "ON" or "OFF") .. ")"
end)

local speedBtn = createButton("Set Speed", 330, function()
	setSpeed(speedBox.Text)
end)

local speedBox = createTextBox(400, "16", function(text)
	setSpeed(text)
end)

local noclipBtn = createButton("Toggle No-Clip (OFF)", 470, function()
	toggleNoClip()
	noclipBtn.Text = "Toggle No-Clip (" .. (NOCLIP_ENABLED and "ON" or "OFF") .. ")"
end)

local flyBtn = createButton("Toggle Fly (OFF)", 540, function()
	toggleFly()
	flyBtn.Text = "Toggle Fly (" .. (FLY_ENABLED and "ON" or "OFF") .. ")"
end)

-- Smooth Dragging for Frame (улучшено для мобильных устройств)
local dragging, dragInput, dragStart, startPos

local function beginDrag(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		-- Поднимаем фрейм наверх при перетаскивании
		frame.ZIndex = 10
		title.ZIndex = 11
		closeBtn.ZIndex = 11
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				
				-- Возвращаем нормальный ZIndex после перетаскивания
				frame.ZIndex = 2
				title.ZIndex = 3
				closeBtn.ZIndex = 3
			end
		end)
	end
end

local function updateDrag(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X, 
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
	end
end

-- Обработка ввода для мобильных устройств и ПК
if IS_MOBILE then
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end)
	
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
			updateDrag(input)
		end
	end)
else
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			beginDrag(input)
		end
	end)
	
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
end

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		updateDrag(dragInput)
	end
end)

-- Initialize
setSpeed("16")

-- Автоматическое закрытие GUI при выходе из игры
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
	if child == gui then
		-- Отключаем все функции при закрытии GUI
		if ESP_ENABLED then toggleESP() end
		if AIMBOT_ENABLED then toggleAimbot() end
		if NOCLIP_ENABLED then toggleNoClip() end
		if FLY_ENABLED then toggleFly() end
	end
end)

-- Уведомление о загрузке
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 300, 0, 60)
notification.Position = UDim2.new(0.5, -150, 1, -100)
notification.AnchorPoint = Vector2.new(0.5, 1)
notification.Text = "Dead Rails GUI loaded!"
notification.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Font = Enum.Font.SourceSansBold
notification.TextSize = 20
notification.TextScaled = true
notification.Visible = true
notification.Parent = gui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notification

delay(3, function()
	notification:TweenPosition(
		UDim2.new(0.5, -150, 1, 70),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quad,
		0.5,
		true,
		function()
			notification:Destroy()
		end
	)
end)
