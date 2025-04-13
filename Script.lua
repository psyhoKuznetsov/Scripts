-- Dead Rails GUI V3.0 Mobile | @Snowmanme
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local PlayerGui = player:WaitForChild("PlayerGui")

-- Main ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DeadRailsGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- Floating Toggle Button (Mobile-Optimized)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0.92, -70, 0.05, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "☰"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.BorderSizePixel = 0
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleBtn

-- Main Frame (Compact for Mobile)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 450)
frame.Position = UDim2.new(0.5, -140, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ClipsDescendants = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "Dead Rails V3.0"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Helper Functions
local function createButton(text, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 240, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.Parent = frame
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createTextBox(y, defaultText, callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 240, 0, 35)
	box.Position = UDim2.new(0, 20, 0, y)
	box.Text = defaultText
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.Gotham
	box.TextScaled = true
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0
	box.Parent = frame
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 8)
	boxCorner.Parent = box
	box.FocusLost:Connect(function()
		if callback then
			callback(box.Text)
		end
	end)
	return box
end

local function createLabel(text, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 240, 0, 25)
	label.Position = UDim2.new(0, 20, 0, y)
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(150, 150, 150)
	label.Font = Enum.Font.Gotham
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	return label
end

local function createSection(text, y)
	local section = Instance.new("TextLabel")
	section.Size = UDim2.new(0, 240, 0, 30)
	section.Position = UDim2.new(0, 20, 0, y)
	section.Text = text
	section.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	section.TextColor3 = Color3.fromRGB(255, 255, 255)
	section.Font = Enum.Font.GothamBlack
	section.TextScaled = true
	section.TextXAlignment = Enum.TextXAlignment.Center
	section.Parent = frame
	local sectionCorner = Instance.new("UICorner")
	sectionCorner.CornerRadius = UDim.new(0, 6)
	sectionCorner.Parent = section
	return section
end

-- Toggle Menu Animation
local function toggleMenu()
	local goal = {Visible = not frame.Visible}
	local tweenInfo = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
	tween:Play()
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ESP Functionality
local ESP_ENABLED = false
local ESP_RADIUS = 50
local espConnections = {}
local espLabels = {}

local function createESP(plr)
	if plr == player or not plr.Character then return end
	local char = plr.Character
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = root
	billboard.Size = UDim2.new(0, 80, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = gui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	nameLabel.Text = plr.Name
	nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextScaled = true
	nameLabel.Parent = billboard

	local distLabel = Instance.new("TextLabel")
	distLabel.Size = UDim2.new(1, 0, 0.5, 0)
	distLabel.Position = UDim2.new(0, 0, 0.5, 0)
	distLabel.Text = "0 studs"
	distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	distLabel.BackgroundTransparency = 1
	distLabel.Font = Enum.Font.Gotham
	distLabel.TextScaled = true
	distLabel.Parent = billboard

	espLabels[plr] = {billboard = billboard, distLabel = distLabel}
end

local function updateESP()
	for plr, data in pairs(espLabels) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			data.billboard.Enabled = dist <= ESP_RADIUS
			data.distLabel.Text = string.format("%.1f studs", dist)
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
		espConnections[#espConnections + 1] = Players.PlayerAdded:Connect(createESP)
		espConnections[#espConnections + 1] = RunService.RenderStepped:Connect(updateESP)
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

local function getClosestPlayer()
	local closestPlayer = nil
	local closestDist = AIMBOT_FOV
	local center = Camera.ViewportSize / 2

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local root = plr.Character.HumanoidRootPart
			local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
			if onScreen then
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
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
			local target = getClosestPlayer()
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
			end
		end)
	else
		if aimbotConnection then
			aimbotConnection:Disconnect()
		end
	end
end

-- Speed Functionality
local function setSpeed(speedText)
	local speed = tonumber(speedText)
	if speed and speed >= 16 and speed <= 300 then
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

-- Fly Functionality
local FLY_ENABLED = false
local flyConnection
local flySpeed = 50

local function toggleFly()
	FLY_ENABLED = not FLY_ENABLED
	if FLY_ENABLED then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = player.Character.HumanoidRootPart

		flyConnection = RunService.RenderStepped:Connect(function()
			local cam = Camera.CFrame
			local moveDir = Vector3.new(0, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDir = moveDir + cam.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDir = moveDir - cam.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDir = moveDir - cam.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDir = moveDir + cam.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDir = moveDir + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDir = moveDir - Vector3.new(0, 1, 0)
			end
			bodyVelocity.Velocity = moveDir.Unit * flySpeed
		end)
	else
		if flyConnection then
			flyConnection:Disconnect()
		end
		if player.Character and player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
			player.Character.HumanoidRootPart.BodyVelocity:Destroy()
		end
	end
end

-- Infinite Jump
local INF_JUMP_ENABLED = false
local jumpConnection

local function toggleInfJump()
	INF_JUMP_ENABLED = not INF_JUMP_ENABLED
	if INF_JUMP_ENABLED then
		jumpConnection = UserInputService.JumpRequest:Connect(function()
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if jumpConnection then
			jumpConnection:Disconnect()
		end
	end
end

-- Kill Aura
local KILL_AURA_ENABLED = false
local KILL_AURA_RANGE = 15
local killAuraConnection

local function toggleKillAura()
	KILL_AURA_ENABLED = not KILL_AURA_ENABLED
	if KILL_AURA_ENABLED then
		killAuraConnection = RunService.Heartbeat:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				for _, plr in pairs(Players:GetPlayers()) do
					if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
						if dist <= KILL_AURA_RANGE then
							plr.Character.Humanoid:TakeDamage(10)
						end
					end
				end
			end
		end)
	else
		if killAuraConnection then
			killAuraConnection:Disconnect()
		end
	end
end

-- GUI Layout (Sectioned)
createSection("Combat", 60)

local espRadiusLabel = createLabel("ESP Radius: 50 studs", 100)
createButton("Toggle ESP", 130, function()
	toggleESP()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "ESP (" .. (ESP_ENABLED and "ON" or "OFF") .. ")"
end)

createTextBox(180, "50", function(text)
	local radius = tonumber(text)
	if radius and radius >= 10 and radius <= 200 then
		ESP_RADIUS = radius
		espRadiusLabel.Text = string.format("ESP Radius: %.1f studs", ESP_RADIUS)
	end
end)

createButton("Toggle Aimbot", 225, function()
	toggleAimbot()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "Aimbot (" .. (AIMBOT_ENABLED and "ON" or "OFF") .. ")"
end)

createButton("Toggle Kill Aura", 270, function()
	toggleKillAura()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "Kill Aura (" .. (KILL_AURA_ENABLED and "ON" or "OFF") .. ")"
end)

createSection("Movement", 320)

createButton("Set Speed", 350, function()
	setSpeed(speedBox.Text)
end)

local speedBox = createTextBox(400, "50", function(text)
	setSpeed(text)
end)

createButton("Toggle No-Clip", 450, function()
	toggleNoClip()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "No-Clip (" .. (NOCLIP_ENABLED and "ON" or "OFF") .. ")"
end)

createButton("Toggle Fly", 500, function()
	toggleFly()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "Fly (" .. (FLY_ENABLED and "ON" or "OFF") .. ")"
end)

createButton("Toggle Inf Jump", 550, function()
	toggleInfJump()
	local btn = frame:GetChildren()[#frame:GetChildren()]
	btn.Text = "Inf Jump (" .. (INF_JUMP_ENABLED and "ON" or "OFF") .. ")"
end)

-- Dragging for Mobile
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Initialize
setSpeed("50")
