-- quick note, ronaldo is the goat.
local Lib = {}
local tweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

function Lib:Drag(frame, parent)
	parent = parent or frame
	local dragToggle = nil
	local dragSpeed = 0.25
	local dragStart = nil
	local startPos = nil
	local activeInput = nil  -- Guardamos el dedo que inició el arrastre

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		tweenService:Create(parent, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragToggle = true
			activeInput = input   -- recordamos el objeto que inició
			dragStart = input.Position
			startPos = parent.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
					activeInput = nil
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			-- ratón: se sigue usando el mismo movimiento (no hay problema de multi-toque)
			if dragToggle then
				updateInput(input)
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			-- Solo seguimos si el toque es el mismo que comenzó el arrastre
			if dragToggle and input == activeInput then
				updateInput(input)
			end
		end
	end)
end

function Lib.Window(Title, iconImage)
	Title = Title or "Ui Library"
	local UiLib = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local MainCorner = Instance.new("UICorner")
	local TabFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local TabNavigator = Instance.new("ScrollingFrame")
	local UIPadding = Instance.new("UIPadding")
	local UIListLayout_tabnav = Instance.new("UIListLayout")
	local TopBar = Instance.new("Frame")
	local TopCorner = Instance.new("UICorner")
	local LibraryTitle = Instance.new("TextLabel")
	local Extension = Instance.new("Frame")
	local ExtensionCorner = Instance.new("UICorner")
	local ContentHolder = Instance.new("Folder")

	-- TopBar buttons (only ×)
	local CloseBtn = Instance.new("TextButton")
	local BtnCorner3 = Instance.new("UICorner")

	-- Properties
	UiLib.Name = "UiLib"
	UiLib.Parent = game:GetService("CoreGui")
	UiLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Main.Name = "Main"
	Main.Parent = UiLib
	Main.BackgroundColor3 = Color3.fromRGB(31, 25, 44)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.303370774, 0, 0.291770577, 0)
	Main.Size = UDim2.new(0, 454, 0, 333)
	Main.ZIndex = 2
	MainCorner.CornerRadius = UDim.new(0, 15)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = Main

	TabFrame.Name = "TabFrame"
	TabFrame.Parent = Main
	TabFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrame.BorderSizePixel = 0
	TabFrame.Position = UDim2.new(0.0198237877, 0, 0.153153151, 0)
	TabFrame.Size = UDim2.new(0, 134, 0, 275)
	TabFrame.ZIndex = 4
	UICorner.CornerRadius = UDim.new(0, 7)
	UICorner.Parent = TabFrame

	TabNavigator.Name = "TabNavigator"
	TabNavigator.Parent = TabFrame
	TabNavigator.Active = true
	TabNavigator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabNavigator.BackgroundTransparency = 1.000
	TabNavigator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabNavigator.BorderSizePixel = 0
	TabNavigator.Position = UDim2.new(0.00733371312, 0, 0, 0)
	TabNavigator.Size = UDim2.new(0, 132, 0, 275)
	TabNavigator.ZIndex = 4
	TabNavigator.CanvasSize = UDim2.new(0, 0, 0, 0)
	UIPadding.Parent = TabNavigator
	UIPadding.PaddingTop = UDim.new(0, 12)
	UIListLayout_tabnav.Parent = TabNavigator
	UIListLayout_tabnav.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_tabnav.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_tabnav.Padding = UDim.new(0, 19)

	-- auto-scroll for TabNavigator
	UIListLayout_tabnav:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabNavigator.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_tabnav.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset)
	end)

	Lib:Drag(TopBar, Main)

	function Lib:ToggleUI()
		if UiLib.Enabled then
			local ClickSound = Instance.new("Sound")
			ClickSound.Parent = UiLib
			ClickSound.SoundId = "rbxassetid://552900451"
			ClickSound.Volume = 2
			ClickSound.Pitch = 1.2
			UiLib.Enabled = false
			ClickSound:Play()
			wait(0.5)
			ClickSound:Destroy()
		else
			local ClickSound = Instance.new("Sound")
			ClickSound.Parent = UiLib
			ClickSound.SoundId = "rbxassetid://552900451"
			ClickSound.Volume = 2
			ClickSound.Pitch = 1
			UiLib.Enabled = true
			ClickSound:Play()
			wait(0.5)
			ClickSound:Destroy()
		end
	end

	TopBar.Name = "TopBar"
	TopBar.Parent = Main
	TopBar.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
	TopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(0, 454, 0, 45)
	TopBar.ZIndex = 5
	TopCorner.CornerRadius = UDim.new(0, 15)
	TopCorner.Name = "TopCorner"
	TopCorner.Parent = TopBar

	LibraryTitle.Name = "LibraryTitle"
	LibraryTitle.Parent = TopBar
	LibraryTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LibraryTitle.BackgroundTransparency = 1.000
	LibraryTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LibraryTitle.BorderSizePixel = 0
	LibraryTitle.Position = UDim2.new(0.0194763951, 2, 0.169778883, -4)
	LibraryTitle.Size = UDim2.new(0, 300, 0, 39)
	LibraryTitle.ZIndex = 5
	LibraryTitle.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	LibraryTitle.Text = Title
	LibraryTitle.TextColor3 = Color3.fromRGB(227, 227, 227)
	LibraryTitle.TextScaled = true
	LibraryTitle.TextSize = 37.000
	LibraryTitle.TextWrapped = true
	LibraryTitle.TextXAlignment = Enum.TextXAlignment.Left

	-- Close button ( × ) – minimiza a la bandeja
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopBar
	CloseBtn.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
	CloseBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Position = UDim2.new(1, -30, 0.22, 0)
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.ZIndex = 6
	CloseBtn.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Color3.fromRGB(227, 227, 227)
	CloseBtn.TextSize = 20
	BtnCorner3.CornerRadius = UDim.new(0, 6)
	BtnCorner3.Parent = CloseBtn

	local minimized = false
	local trayIcon = nil
	local originalMainSize = Main.Size

	local function showTrayIcon()
		if trayIcon then trayIcon:Destroy() end
		trayIcon = Instance.new("TextButton")
		trayIcon.Size = UDim2.new(0, 48, 0, 48)
		trayIcon.Position = UDim2.new(1, -60, 0, 30)
		trayIcon.BackgroundColor3 = Color3.fromRGB(31, 25, 44)
		trayIcon.BorderSizePixel = 0
		trayIcon.Text = ""
		trayIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
		trayIcon.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		trayIcon.TextSize = 24
		local corner = Instance.new("UICorner", trayIcon)
		corner.CornerRadius = UDim.new(1, 0)
		trayIcon.Parent = UiLib
		trayIcon.ZIndex = 10

		if iconImage then
			local img = Instance.new("ImageLabel", trayIcon)
			img.BackgroundTransparency = 1
			img.Size = UDim2.new(1, -8, 1, -8)
			img.Position = UDim2.new(0, 4, 0, 4)
			img.Image = iconImage
			img.ScaleType = Enum.ScaleType.Fit
		else
			trayIcon.Text = string.sub(Title, 1, 1):upper()
		end

		trayIcon.MouseButton1Click:Connect(function()
			trayIcon:Destroy()
			trayIcon = nil
			setMinimized(false)
		end)
	end

	local function setMinimized(state)
		if state then
			minimized = true
			Main.Size = UDim2.new(originalMainSize.X.Scale, originalMainSize.X.Offset, 0, TopBar.AbsoluteSize.Y)
			Main.ClipsDescendants = true
			TabFrame.Visible = false
			ContentHolder.Visible = false
			showTrayIcon()
		else
			minimized = false
			Main.Size = originalMainSize
			Main.ClipsDescendants = false
			TabFrame.Visible = true
			ContentHolder.Visible = true
			if trayIcon then
				trayIcon:Destroy()
				trayIcon = nil
			end
		end
	end

	CloseBtn.MouseButton1Click:Connect(function()
		setMinimized(not minimized)
	end)

	Extension.Name = "Extension"
	Extension.Parent = TopBar
	Extension.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
	Extension.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Extension.BorderSizePixel = 0
	Extension.Position = UDim2.new(0.00652175443, -3, 0.994062245, 0)
	Extension.Size = UDim2.new(0, 454, 0, -23)
	Extension.ZIndex = 4
	ExtensionCorner.CornerRadius = UDim.new(0, 7)
	ExtensionCorner.Name = "ExtensionCorner"
	ExtensionCorner.Parent = Extension

	ContentHolder.Name = "ContentHolder"
	ContentHolder.Parent = Main

	local TabSys = {}
	local first = true
	function TabSys.CreateTab(TabTitle)
		TabTitle = TabTitle or "Home"
		local TabContent = Instance.new("ScrollingFrame")
		local TabSwitcher = Instance.new("TextButton")
		local TabCorner = Instance.new("UICorner")
		local ContentPadding = Instance.new("UIPadding")
		local ContentLayout = Instance.new("UIListLayout")

		TabSwitcher.Name = "TabSwitcher"
		TabSwitcher.Parent = TabNavigator
		TabSwitcher.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
		TabSwitcher.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabSwitcher.BorderSizePixel = 0
		TabSwitcher.Size = UDim2.new(0, 114, 0, 25)
		TabSwitcher.ZIndex = 4
		TabSwitcher.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		TabSwitcher.Text = TabTitle
		TabSwitcher.TextColor3 = Color3.fromRGB(227, 227, 227)
		TabSwitcher.TextSize = 24.000
		TabSwitcher.TextWrapped = true
		TabCorner.Name = "TabCorner"
		TabCorner.Parent = TabSwitcher

		TabContent.Name = TabTitle.."'s Content"
		TabContent.Parent = ContentHolder
		TabContent.Active = true
		TabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContent.BackgroundTransparency = 1.000
		TabContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContent.BorderSizePixel = 0
		TabContent.Position = UDim2.new(0.331549704, 0, 0.153153151, 0)
		TabContent.Size = UDim2.new(0, 295, 0, 275)
		TabContent.ZIndex = 4
		TabContent.ClipsDescendants = true
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)

		ContentPadding.Name = "ContentPadding"
		ContentPadding.Parent = TabContent
		ContentPadding.PaddingTop = UDim.new(0, 12)
		ContentLayout.Name = "ContentLayout"
		ContentLayout.Parent = TabContent
		ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0,12)

		-- Auto-resize TabContent canvas
		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + ContentPadding.PaddingTop.Offset)
		end)

		if first then
			first = false
			TabContent.Visible = true
			TabSwitcher.BackgroundTransparency = 0.7
			TabSwitcher.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			TabContent.Visible = false
			TabSwitcher.BackgroundTransparency = 0.89
			TabSwitcher.TextColor3 = Color3.fromRGB(199, 199, 199)
		end

		TabSwitcher.MouseButton1Click:Connect(function()
			for i,v in next, ContentHolder:GetChildren() do
				v.Visible = false
			end
			TabContent.Visible = true
			for i,v in next, TabNavigator:GetChildren() do
				if v:IsA("TextButton") then
					tweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundTransparency = 0.89
					}):Play()
					tweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						TextColor3 = Color3.fromRGB(199, 199, 199)
					}):Play()
				end
			end
			tweenService:Create(TabSwitcher, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
				BackgroundTransparency = 0.7
			}):Play()
			tweenService:Create(TabSwitcher, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
		end)

		local Content = {}
		function Content.CreateButton(BtnTitle, callback)
			BtnTitle = BtnTitle or "Button"
			callback = callback or function() end
			local ButtonFrame = Instance.new("Frame")
			local ButtonTrigger = Instance.new("TextButton")
			local ButtonCorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local TouchImage = Instance.new("ImageLabel")
			local Circle = Instance.new("ImageLabel")

			ButtonFrame.Name = "ButtonFrame"
			ButtonFrame.Parent = TabContent
			ButtonFrame.Active = true
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.ClipsDescendants = true
			ButtonFrame.Size = UDim2.new(0, 237, 0, 32)
			ButtonFrame.ZIndex = 4

			ButtonCorner.Name = "ButtonCorner"
			ButtonCorner.Parent = ButtonFrame

			ButtonTrigger.Name = "ButtonTrigger"
			ButtonTrigger.Parent = ButtonFrame
			ButtonTrigger.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			ButtonTrigger.BackgroundTransparency = 1.000
			ButtonTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ButtonTrigger.BorderSizePixel = 0
			ButtonTrigger.ClipsDescendants = true
			ButtonTrigger.Size = UDim2.new(0, 237, 0, 32)
			ButtonTrigger.ZIndex = 5
			ButtonTrigger.Text = ""
			ButtonTrigger.TextTransparency = 1.000

			TextLabel.Parent = ButtonFrame
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.151898727, 0, 0, 0)
			TextLabel.Size = UDim2.new(0, 193, 0, 32)
			TextLabel.ZIndex = 5
			TextLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			TextLabel.Text = BtnTitle
			TextLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
			TextLabel.TextSize = 26.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			TouchImage.Name = "TouchImage"
			TouchImage.Parent = ButtonFrame
			TouchImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TouchImage.BackgroundTransparency = 1.000
			TouchImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TouchImage.BorderSizePixel = 0
			TouchImage.Position = UDim2.new(0.0590717308, -5, 0.1875, -2)
			TouchImage.Size = UDim2.new(0, 22, 0, 22)
			TouchImage.ZIndex = 5
			TouchImage.Image = "rbxassetid://3926305904"
			TouchImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
			TouchImage.ImageRectOffset = Vector2.new(84, 204)
			TouchImage.ImageRectSize = Vector2.new(36, 36)

			Circle.Name = "Circle"
			Circle.Parent = ButtonFrame
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.BackgroundTransparency = 1.000
			Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Circle.BorderSizePixel = 0
			Circle.Position = UDim2.new(0.472573817, -5, 0.21875, 9)
			Circle.ZIndex = 5
			Circle.Image = "rbxassetid://4560909609"
			Circle.ImageColor3 = Color3.fromRGB(228, 197, 255)

			local sample = Circle
			local ms = game.Players.LocalPlayer:GetMouse()

			ButtonTrigger.MouseButton1Click:Connect(function()
				local ClickSound = Instance.new("Sound")
				ClickSound.Parent = ButtonTrigger
				ClickSound.SoundId = "rbxassetid://552900451"
				ClickSound.Volume = 2
				ClickSound.Pitch = 0.5
				ClickSound:Play()
				callback()
				local c = sample:Clone()
				c.Parent = ButtonFrame
				local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
				c.Position = UDim2.new(0, x, 0, y)
				local len, size = 0.35, nil
				if ButtonFrame.AbsoluteSize.X >= ButtonFrame.AbsoluteSize.Y then
					size = (ButtonFrame.AbsoluteSize.X * 1.5)
				else
					size = (ButtonFrame.AbsoluteSize.Y * 1.5)
				end
				c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
				tweenService:Create(c, TweenInfo.new(len, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
				game.Debris:AddItem(c, len + 0.1)
			end)
		end

		function Content.CreateSlider(SliderTitle, minvalue, maxvalue, callback, defaultVal)
	SliderTitle = SliderTitle or "Slider"
	minvalue = minvalue or 0
	maxvalue = maxvalue or 100
	callback = callback or function() end
	defaultVal = defaultVal or minvalue

	local SliderFrame = Instance.new("Frame")
	local SliderCorner = Instance.new("UICorner")
	local SliderLabel = Instance.new("TextLabel")
	local GraphImage = Instance.new("ImageLabel")
	local SliderTrigger = Instance.new("TextButton")
	local SliderBack = Instance.new("Frame")
	local SliderFill = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UICorner_3 = Instance.new("UICorner")
	local ValueLabel = Instance.new("TextLabel")

	SliderFrame.Name = "SliderFrame"
	SliderFrame.Parent = TabContent
	SliderFrame.Active = true
	SliderFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
	SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SliderFrame.BorderSizePixel = 0
	SliderFrame.ClipsDescendants = true
	SliderFrame.Size = UDim2.new(0, 237, 0, 48)
	SliderFrame.ZIndex = 4

	SliderCorner.Name = "SliderCorner"
	SliderCorner.Parent = SliderFrame

	SliderLabel.Name = "SliderLabel"
	SliderLabel.Parent = SliderFrame
	SliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SliderLabel.BackgroundTransparency = 1.000
	SliderLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SliderLabel.BorderSizePixel = 0
	SliderLabel.Position = UDim2.new(0.185654014, 0, 0, 0)
	SliderLabel.Size = UDim2.new(0, 193, 0, 32)
	SliderLabel.ZIndex = 5
	SliderLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	SliderLabel.Text = SliderTitle
	SliderLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
	SliderLabel.TextSize = 26.000
	SliderLabel.TextWrapped = true
	SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

	GraphImage.Name = "GraphImage"
	GraphImage.Parent = SliderFrame
	GraphImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GraphImage.BackgroundTransparency = 1.000
	GraphImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GraphImage.BorderSizePixel = 0
	GraphImage.Position = UDim2.new(0.0801687762, -5, 0.1875, -2)
	GraphImage.Size = UDim2.new(0, 22, 0, 22)
	GraphImage.ZIndex = 5
	GraphImage.Image = "rbxassetid://3926307971"
	GraphImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
	GraphImage.ImageRectOffset = Vector2.new(404, 164)
	GraphImage.ImageRectSize = Vector2.new(36, 36)

	SliderTrigger.Name = "SliderTrigger"
	SliderTrigger.Parent = SliderFrame
	SliderTrigger.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
	SliderTrigger.BackgroundTransparency = 1.000
	SliderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SliderTrigger.BorderSizePixel = 0
	SliderTrigger.ClipsDescendants = true
	SliderTrigger.Position = UDim2.new(0.0680000037, 0, 0.708000004, 0)
	SliderTrigger.Size = UDim2.new(0, 207, 0, 7)
	SliderTrigger.ZIndex = 5
	SliderTrigger.Text = ""
	SliderTrigger.TextTransparency = 1.000

	SliderBack.Name = "SliderBack"
	SliderBack.Parent = SliderTrigger
	SliderBack.BackgroundColor3 = Color3.fromRGB(53, 40, 65)
	SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SliderBack.BorderSizePixel = 0
	SliderBack.Size = UDim2.new(0, 207, 0, 7)
	SliderBack.ZIndex = 5
	SliderBack.ClipsDescendants = true

	SliderFill.Name = "SliderFill"
	SliderFill.Parent = SliderBack
	SliderFill.BackgroundColor3 = Color3.fromRGB(228, 197, 255)
	SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SliderFill.BorderSizePixel = 0
	SliderFill.Size = UDim2.new(0, 0, 0, 7)
	SliderFill.ZIndex = 5

	UICorner_2.Parent = SliderFill
	UICorner_3.Parent = SliderBack

	ValueLabel.Name = "ValueLabel"
	ValueLabel.Parent = SliderFrame
	ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ValueLabel.BackgroundTransparency = 1.000
	ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ValueLabel.BorderSizePixel = 0
	ValueLabel.Position = UDim2.new(0.628692031, 0, 0.0416666679, -1)
	ValueLabel.Size = UDim2.new(0, 88, 0, 32)
	ValueLabel.ZIndex = 5
	ValueLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	ValueLabel.Text = tostring(defaultVal)
	ValueLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
	ValueLabel.TextSize = 26.000
	ValueLabel.TextWrapped = true
	ValueLabel.TextTransparency = 1.000

	local uis = game:GetService("UserInputService")
	local barAbsoluteSize = SliderBack.AbsoluteSize.X

	local function setValueFromX(absoluteX)
		local relX = math.clamp(absoluteX - SliderBack.AbsolutePosition.X, 0, barAbsoluteSize)
		local percent = relX / barAbsoluteSize
		local val = math.floor(minvalue + (maxvalue - minvalue) * percent)
		SliderFill:TweenSize(UDim2.new(0, relX, 0, 7), "InOut", "Linear", 0.1, true)
		ValueLabel.Text = tostring(val)
		pcall(function() callback(val) end)
		return val
	end

	-- Estado visual inicial por defecto
	local defaultRelX = (defaultVal - minvalue) / (maxvalue - minvalue) * barAbsoluteSize
	SliderFill.Size = UDim2.new(0, defaultRelX, 0, 7)
	ValueLabel.Text = tostring(defaultVal)

	local dragging = false
	local moveConnection, releaseConnection
	local activeInputObject = nil

	local function startDrag()
		dragging = true
		tweenService:Create(ValueLabel, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
			TextTransparency = 0
		}):Play()
	end

	local function stopDrag()
		if not dragging then return end
		dragging = false
		activeInputObject = nil
		tweenService:Create(ValueLabel, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
			TextTransparency = 1
		}):Play()
		if moveConnection then moveConnection:Disconnect() end
		if releaseConnection then releaseConnection:Disconnect() end
	end

	SliderTrigger.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			startDrag()
			activeInputObject = input
			setValueFromX(input.Position.X)

			-- Movimiento (funciona con ratón y con dedos)
			moveConnection = uis.InputChanged:Connect(function(moveInput)
				if not dragging then return end
				-- Solo seguimos si el movimiento pertenece al mismo input (ratón o dedo)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
					-- En tablet, el input.Position puede no estar disponible en el evento InputChanged,
					-- por eso usamos el objeto de UIS para obtener la posición del touch.
					local pos = uis:GetMouseLocation()
					setValueFromX(pos.X)
				end
			end)

			-- Finalización
			releaseConnection = uis.InputEnded:Connect(function(endInput)
				if endInput == activeInputObject then
					stopDrag()
				end
			end)
		end
	end)
end

		function Content.CreateToggle(TogTXT, callback)
			TogTXT = TogTXT or "Toggle"
			callback = callback or function() end
			local toggled = false
			local ToggleFrame = Instance.new("Frame")
			local ButtonCorner = Instance.new("UICorner")
			local ToggleLabel = Instance.new("TextLabel")
			local ToggleDisabled = Instance.new("ImageLabel")
			local Circle = Instance.new("ImageLabel")
			local ToggleTrigger = Instance.new("TextButton")
			local ToggleEnabled = Instance.new("ImageLabel")

			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = TabContent
			ToggleFrame.Active = true
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.ClipsDescendants = true
			ToggleFrame.Size = UDim2.new(0, 237, 0, 32)
			ToggleFrame.ZIndex = 4

			ButtonCorner.Name = "ButtonCorner"
			ButtonCorner.Parent = ToggleFrame

			ToggleLabel.Name = "ToggleLabel"
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleLabel.BackgroundTransparency = 1.000
			ToggleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleLabel.BorderSizePixel = 0
			ToggleLabel.Position = UDim2.new(0.151898727, 0, 0, 0)
			ToggleLabel.Size = UDim2.new(0, 193, 0, 32)
			ToggleLabel.ZIndex = 5
			ToggleLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			ToggleLabel.Text = TogTXT
			ToggleLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
			ToggleLabel.TextSize = 26.000
			ToggleLabel.TextWrapped = true
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

			ToggleDisabled.Name = "ToggleDisabled"
			ToggleDisabled.Parent = ToggleFrame
			ToggleDisabled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleDisabled.BackgroundTransparency = 1.000
			ToggleDisabled.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleDisabled.BorderSizePixel = 0
			ToggleDisabled.Position = UDim2.new(0.0590717308, -5, 0.1875, -1)
			ToggleDisabled.Size = UDim2.new(0, 22, 0, 22)
			ToggleDisabled.ZIndex = 5
			ToggleDisabled.Image = "rbxassetid://3926309567"
			ToggleDisabled.ImageColor3 = Color3.fromRGB(228, 197, 255)
			ToggleDisabled.ImageRectOffset = Vector2.new(628, 420)
			ToggleDisabled.ImageRectSize = Vector2.new(48, 48)

			Circle.Name = "Circle"
			Circle.Parent = ToggleFrame
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.BackgroundTransparency = 1.000
			Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Circle.BorderSizePixel = 0
			Circle.Position = UDim2.new(0.472573817, -5, 0.21875, 9)
			Circle.ZIndex = 5
			Circle.Image = "rbxassetid://4560909609"
			Circle.ImageColor3 = Color3.fromRGB(228, 197, 255)

			ToggleTrigger.Name = "ToggleTrigger"
			ToggleTrigger.Parent = ToggleFrame
			ToggleTrigger.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			ToggleTrigger.BackgroundTransparency = 1.000
			ToggleTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTrigger.BorderSizePixel = 0
			ToggleTrigger.ClipsDescendants = true
			ToggleTrigger.Size = UDim2.new(0, 237, 0, 32)
			ToggleTrigger.ZIndex = 5
			ToggleTrigger.Text = ""
			ToggleTrigger.TextTransparency = 1.000

			ToggleEnabled.Name = "ToggleEnabled"
			ToggleEnabled.Parent = ToggleFrame
			ToggleEnabled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleEnabled.BackgroundTransparency = 1.000
			ToggleEnabled.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleEnabled.BorderSizePixel = 0
			ToggleEnabled.Position = UDim2.new(0.0590717308, -5, 0.1875, -1)
			ToggleEnabled.Size = UDim2.new(0, 22, 0, 22)
			ToggleEnabled.ZIndex = 5
			ToggleEnabled.Image = "rbxassetid://3926309567"
			ToggleEnabled.ImageColor3 = Color3.fromRGB(228, 197, 255)
			ToggleEnabled.ImageRectOffset = Vector2.new(784, 420)
			ToggleEnabled.ImageRectSize = Vector2.new(48, 48)
			ToggleEnabled.ImageTransparency = 1.000

			local img = ToggleEnabled
			local sample = Circle
			local ms = game.Players.LocalPlayer:GetMouse()

			ToggleTrigger.MouseButton1Click:Connect(function()
				toggled = not toggled
				if toggled then
					tweenService:Create(img, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						ImageTransparency = 0
					}):Play()
					local ClickSound = Instance.new("Sound")
					ClickSound.Parent = ToggleFrame
					ClickSound.SoundId = "rbxassetid://552900451"
					ClickSound.Volume = 2
					ClickSound.Pitch = 1
					local c = sample:Clone()
					c.Parent = ToggleFrame
					local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
					c.Position = UDim2.new(0, x, 0, y)
					local len, size = 0.35, nil
					if ToggleFrame.AbsoluteSize.X >= ToggleFrame.AbsoluteSize.Y then
						size = (ToggleFrame.AbsoluteSize.X * 1.5)
					else
						size = (ToggleFrame.AbsoluteSize.Y * 1.5)
					end
					c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
					tweenService:Create(c, TweenInfo.new(len, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
					ClickSound:Play()
					game.Debris:AddItem(c, len + 0.1)
				else
					tweenService:Create(img, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						ImageTransparency = 1
					}):Play()
					local ClickSound = Instance.new("Sound")
					ClickSound.Parent = ToggleFrame
					ClickSound.SoundId = "rbxassetid://552900451"
					ClickSound.Volume = 2
					ClickSound.Pitch = 1.2
					local c = sample:Clone()
					c.Parent = ToggleFrame
					local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
					c.Position = UDim2.new(0, x, 0, y)
					local len, size = 0.35, nil
					if ToggleFrame.AbsoluteSize.X >= ToggleFrame.AbsoluteSize.Y then
						size = (ToggleFrame.AbsoluteSize.X * 1.5)
					else
						size = (ToggleFrame.AbsoluteSize.Y * 1.5)
					end
					c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
					tweenService:Create(c, TweenInfo.new(len, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
					ClickSound:Play()
					game.Debris:AddItem(c, len + 0.1)
				end
				pcall(callback, toggled)
			end)
		end

		function Content.CreateKeybind(KeybindTitle, first, callback)
			KeybindTitle = KeybindTitle or "Keybind"
			local oldKey = first.Name
			callback = callback or function() end
			local KeybindFrame = Instance.new("Frame")
			local KeybindCorner = Instance.new("UICorner")
			local KeybindLabel = Instance.new("TextLabel")
			local KeybindImage = Instance.new("ImageLabel")
			local Input = Instance.new("TextLabel")
			local ToggleTrigger = Instance.new("TextButton")
			local KeybindCorner_2 = Instance.new("UICorner")

			KeybindFrame.Name = "KeybindFrame"
			KeybindFrame.Parent = TabContent
			KeybindFrame.Active = true
			KeybindFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.ClipsDescendants = true
			KeybindFrame.Size = UDim2.new(0, 237, 0, 37)
			KeybindFrame.ZIndex = 4

			KeybindCorner.Name = "KeybindCorner"
			KeybindCorner.Parent = KeybindFrame

			KeybindLabel.Name = "KeybindLabel"
			KeybindLabel.Parent = KeybindFrame
			KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindLabel.BackgroundTransparency = 1.000
			KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindLabel.BorderSizePixel = 0
			KeybindLabel.Position = UDim2.new(0.185654014, 0, 0.0540540516, 0)
			KeybindLabel.Size = UDim2.new(0, 96, 0, 32)
			KeybindLabel.ZIndex = 5
			KeybindLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			KeybindLabel.Text = KeybindTitle
			KeybindLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
			KeybindLabel.TextSize = 26.000
			KeybindLabel.TextWrapped = true
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

			KeybindImage.Name = "KeybindImage"
			KeybindImage.Parent = KeybindFrame
			KeybindImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeybindImage.BackgroundTransparency = 1.000
			KeybindImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeybindImage.BorderSizePixel = 0
			KeybindImage.Position = UDim2.new(0.0590717271, -5, 0.241554052, -2)
			KeybindImage.Size = UDim2.new(0, 22, 0, 22)
			KeybindImage.ZIndex = 5
			KeybindImage.Image = "rbxassetid://3926305904"
			KeybindImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
			KeybindImage.ImageRectOffset = Vector2.new(364, 284)
			KeybindImage.ImageRectSize = Vector2.new(36, 36)

			Input.Name = "Input"
			Input.Parent = KeybindFrame
			Input.BackgroundColor3 = Color3.fromRGB(82, 82, 122)
			Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Input.BorderSizePixel = 0
			Input.ClipsDescendants = true
			Input.Position = UDim2.new(0.816, 0, 0.092, 0)
			Input.Size = UDim2.new(0, 29, 0, 29)
			Input.ZIndex = 5
			Input.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			Input.Text = oldKey
			Input.TextColor3 = Color3.fromRGB(227, 227, 227)
			Input.TextScaled = true
			Input.TextWrapped = true

			KeybindCorner_2.CornerRadius = UDim.new(0, 5)
			KeybindCorner_2.Name = "KeybindCorner_2"
			KeybindCorner_2.Parent = Input

			ToggleTrigger.Name = "ToggleTrigger"
			ToggleTrigger.Parent = KeybindFrame
			ToggleTrigger.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			ToggleTrigger.BackgroundTransparency = 1.000
			ToggleTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTrigger.BorderSizePixel = 0
			ToggleTrigger.ClipsDescendants = true
			ToggleTrigger.Size = UDim2.new(0, 237, 0, 34)
			ToggleTrigger.ZIndex = 5
			ToggleTrigger.Text = ""
			ToggleTrigger.TextTransparency = 1.000
			ToggleTrigger.MouseButton1Click:Connect(function()
				Input.Text = ". . ."
				local a, b = game:GetService('UserInputService').InputBegan:wait();
				if a.KeyCode.Name ~= "Unknown" then
					Input.Text = a.KeyCode.Name
					oldKey = a.KeyCode.Name;
				end
			end)
			game:GetService("UserInputService").InputBegan:connect(function(current, ok)
				if not ok then
					if current.KeyCode.Name == oldKey then
						callback()
					end
				end
			end)
		end

		function Content.CreateTextbox(TextboxTitle, callback)
			TextboxTitle = TextboxTitle or "Textbox"
			callback = callback or function() end
			local TextboxFrame = Instance.new("Frame")
			local TextboxCorner = Instance.new("UICorner")
			local TextboxLabel = Instance.new("TextLabel")
			local PencilImage = Instance.new("ImageLabel")
			local Input = Instance.new("TextBox")
			local KeybindCorner = Instance.new("UICorner")

			TextboxFrame.Name = "TextboxFrame"
			TextboxFrame.Parent = TabContent
			TextboxFrame.Active = true
			TextboxFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			TextboxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextboxFrame.BorderSizePixel = 0
			TextboxFrame.ClipsDescendants = true
			TextboxFrame.Size = UDim2.new(0, 237, 0, 57)
			TextboxFrame.ZIndex = 4

			TextboxCorner.Name = "TextboxCorner"
			TextboxCorner.Parent = TextboxFrame

			TextboxLabel.Name = "TextboxLabel"
			TextboxLabel.Parent = TextboxFrame
			TextboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextboxLabel.BackgroundTransparency = 1.000
			TextboxLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextboxLabel.BorderSizePixel = 0
			TextboxLabel.Position = UDim2.new(0.186, 0, 0.054, -1)
			TextboxLabel.Size = UDim2.new(0, 160, 0, 32)
			TextboxLabel.ZIndex = 5
			TextboxLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			TextboxLabel.Text = TextboxTitle
			TextboxLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
			TextboxLabel.TextSize = 26.000
			TextboxLabel.TextWrapped = true
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

			PencilImage.Name = "PencilImage"
			PencilImage.Parent = TextboxFrame
			PencilImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PencilImage.BackgroundTransparency = 1.000
			PencilImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PencilImage.BorderSizePixel = 0
			PencilImage.Position = UDim2.new(0.059, -5, 0.171, -2)
			PencilImage.Size = UDim2.new(0, 22, 0, 22)
			PencilImage.ZIndex = 5
			PencilImage.Image = "rbxassetid://3926305904"
			PencilImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
			PencilImage.ImageRectOffset = Vector2.new(324, 604)
			PencilImage.ImageRectSize = Vector2.new(36, 36)

			Input.Name = "Input"
			Input.Parent = TextboxFrame
			Input.BackgroundColor3 = Color3.fromRGB(82, 82, 122)
			Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Input.BorderSizePixel = 0
			Input.ClipsDescendants = true
			Input.Position = UDim2.new(0.131, 0, 0.605, 0)
			Input.Size = UDim2.new(0, 173, 0, 18)
			Input.ZIndex = 5
			Input.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			Input.PlaceholderText = "Type Here"
			Input.Text = ""
			Input.TextColor3 = Color3.fromRGB(227, 227, 227)
			Input.TextScaled = true
			Input.TextSize = 23.000
			Input.TextWrapped = true

			KeybindCorner.CornerRadius = UDim.new(0, 5)
			KeybindCorner.Name = "KeybindCorner"
			KeybindCorner.Parent = Input

			Input.FocusLost:Connect(function(EnterPressed)
				if not EnterPressed then return end
				callback(Input.Text)
				wait(0.18)
				Input.Text = ""
			end)
		end

		function Content.CreateDropdown(DropdownTitle, list, callback)
			callback = callback or function() end
			DropdownTitle = DropdownTitle or "Dropdown"
			list = list or {}
			local IsDropped = false
			local DropYSize = 134
			local NormalYSize = 34

			local DropdownFrame = Instance.new("Frame")
			local DropdownCorner = Instance.new("UICorner")
			local DropdownLabel = Instance.new("TextLabel")
			local DropdownImage = Instance.new("ImageLabel")
			local DropdownTrigger = Instance.new("TextButton")
			local DropdownContainer = Instance.new("ScrollingFrame")
			local ContentLayout = Instance.new("UIListLayout")
			local ContentPadding = Instance.new("UIPadding")

			DropdownFrame.Name = "DropdownFrame"
			DropdownFrame.Parent = TabContent
			DropdownFrame.Active = true
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Size = UDim2.new(0, 237, 0, NormalYSize)
			DropdownFrame.ZIndex = 4

			DropdownCorner.Name = "DropdownCorner"
			DropdownCorner.Parent = DropdownFrame

			DropdownLabel.Name = "DropdownLabel"
			DropdownLabel.Parent = DropdownFrame
			DropdownLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownLabel.BackgroundTransparency = 1.000
			DropdownLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownLabel.BorderSizePixel = 0
			DropdownLabel.Position = UDim2.new(0.151, 0, 0.037, 0)
			DropdownLabel.Size = UDim2.new(0, 193, 0, 32)
			DropdownLabel.ZIndex = 5
			DropdownLabel.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			DropdownLabel.Text = DropdownTitle
			DropdownLabel.TextColor3 = Color3.fromRGB(227, 227, 227)
			DropdownLabel.TextSize = 26.000
			DropdownLabel.TextWrapped = true
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

			DropdownImage.Name = "DropdownImage"
			DropdownImage.Parent = DropdownFrame
			DropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownImage.BackgroundTransparency = 1.000
			DropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownImage.BorderSizePixel = 0
			DropdownImage.Position = UDim2.new(0.03, 0, 0.196, -1)
			DropdownImage.Size = UDim2.new(0, 22, 0, 22)
			DropdownImage.ZIndex = 5
			DropdownImage.Image = "rbxassetid://3926305904"
			DropdownImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
			DropdownImage.ImageRectOffset = Vector2.new(644, 364)
			DropdownImage.ImageRectSize = Vector2.new(36, 36)

			DropdownTrigger.Name = "DropdownTrigger"
			DropdownTrigger.Parent = DropdownFrame
			DropdownTrigger.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			DropdownTrigger.BackgroundTransparency = 1.000
			DropdownTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownTrigger.BorderSizePixel = 0
			DropdownTrigger.ClipsDescendants = true
			DropdownTrigger.Size = UDim2.new(0, 237, 0, 32)
			DropdownTrigger.ZIndex = 5
			DropdownTrigger.Text = ""
			DropdownTrigger.TextTransparency = 1.000
			DropdownTrigger.MouseButton1Click:Connect(function()
				if IsDropped == false then
					local ClickSound = Instance.new("Sound")
					ClickSound.Parent = UiLib
					ClickSound.SoundId = "rbxassetid://552900451"
					ClickSound.Volume = 2
					ClickSound.Pitch = 1.2
					DropdownImage.Position = UDim2.new(0.03, 0, 0.05, -1)
					DropdownLabel.Position = UDim2.new(0.151, 0, 0.01, 0)
					DropdownFrame.Size = UDim2.new(0, 237, 0, DropYSize)
					DropdownContainer.Visible = true
					ClickSound:Play()
					IsDropped = true
				else
					local ClickSound = Instance.new("Sound")
					ClickSound.Parent = UiLib
					ClickSound.SoundId = "rbxassetid://552900451"
					ClickSound.Volume = 2
					ClickSound.Pitch = 1
					DropdownImage.Position = UDim2.new(0.03, 0, 0.196, -1)
					DropdownLabel.Position = UDim2.new(0.151, 0, 0.037, 0)
					DropdownFrame.Size = UDim2.new(0, 237, 0, NormalYSize)
					DropdownContainer.Visible = false
					ClickSound:Play()
					IsDropped = false
				end
			end)

			DropdownContainer.Parent = DropdownFrame
			DropdownContainer.Active = true
			DropdownContainer.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			DropdownContainer.BackgroundTransparency = 1
			DropdownContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownContainer.BorderSizePixel = 0
			DropdownContainer.Position = UDim2.new(0.177704751, 0, 0.28498134, 0)
			DropdownContainer.Size = UDim2.new(0, 150, 0, 76)
			DropdownContainer.ZIndex = 5
			DropdownContainer.CanvasSize = UDim2.new(0, 0, 1, 0)
			DropdownContainer.Visible = false

			ContentLayout.Name = "ContentLayout"
			ContentLayout.Parent = DropdownContainer
			ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 8)

			-- Auto-size for dropdown
			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 12)
			end)

			for i,v in next, list do
				local Option = Instance.new("TextButton")
				local UICorner_opt = Instance.new("UICorner")
				Option.Name = "Option"
				Option.Parent = DropdownContainer
				Option.BackgroundColor3 = Color3.fromRGB(90, 86, 127)
				Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Option.BorderSizePixel = 0
				Option.Size = UDim2.new(0, 106, 0, 21)
				Option.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				Option.Text = v
				Option.TextColor3 = Color3.fromRGB(227, 227, 227)
				Option.TextSize = 14.000
				Option.MouseButton1Click:Connect(function()
					local ClickSound = Instance.new("Sound")
					ClickSound.Parent = UiLib
					ClickSound.SoundId = "rbxassetid://552900451"
					ClickSound.Volume = 2
					ClickSound.Pitch = 1
					callback(v)
					ClickSound:Play()
					DropdownImage.Position = UDim2.new(0.03, 0, 0.196, -1)
					DropdownLabel.Position = UDim2.new(0.151, 0, 0.037, 0)
					DropdownFrame.Size = UDim2.new(0, 237, 0, NormalYSize)
					DropdownContainer.Visible = false
					IsDropped = false
					wait(0.5)
					ClickSound:Destroy()
				end)
				UICorner_opt.Parent = Option
			end
			ContentPadding.Name = "ContentPadding"
			ContentPadding.Parent = DropdownContainer
			ContentPadding.PaddingTop = UDim.new(0, 12)
		end

		function Content.CreateLabel(LabelTitle)
			local LabelFrame = Instance.new("Frame")
			local LabelCorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			local ChatImage = Instance.new("ImageLabel")

			LabelFrame.Name = "LabelFrame"
			LabelFrame.Parent = TabContent
			LabelFrame.Active = true
			LabelFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			LabelFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LabelFrame.BorderSizePixel = 0
			LabelFrame.ClipsDescendants = true
			LabelFrame.Size = UDim2.new(0, 237, 0, 32)
			LabelFrame.ZIndex = 4

			LabelCorner.Name = "LabelCorner"
			LabelCorner.Parent = LabelFrame

			LabelText.Name = "LabelText"
			LabelText.Parent = LabelFrame
			LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.BackgroundTransparency = 1.000
			LabelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LabelText.BorderSizePixel = 0
			LabelText.Position = UDim2.new(0.038, 0, 0, 0)
			LabelText.Size = UDim2.new(0, 220, 0, 32)
			LabelText.ZIndex = 5
			LabelText.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			LabelText.Text = LabelTitle
			LabelText.TextColor3 = Color3.fromRGB(227, 227, 227)
			LabelText.TextSize = 26.000
			LabelText.TextWrapped = true
			LabelText.TextScaled = true
			LabelText.TextXAlignment = Enum.TextXAlignment.Left

			ChatImage.Name = "ChatImage"
			ChatImage.Parent = LabelFrame
			ChatImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ChatImage.BackgroundTransparency = 1.000
			ChatImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChatImage.BorderSizePixel = 0
			ChatImage.Position = UDim2.new(0.0590717308, -5, 0.1875, -2)
			ChatImage.Size = UDim2.new(0, 22, 0, 22)
			ChatImage.ZIndex = 5
			ChatImage.Image = "rbxassetid://13130554026"
			ChatImage.ImageColor3 = Color3.fromRGB(228, 197, 255)
		end

		function Content.CreateDivider(DividerTitle)
			local DividerFrame = Instance.new("Frame")
			local DividerCorner = Instance.new("UICorner")
			local DividerText = Instance.new("TextLabel")

			DividerFrame.Name = "DividerFrame"
			DividerFrame.Parent = TabContent
			DividerFrame.Active = true
			DividerFrame.BackgroundColor3 = Color3.fromRGB(53, 50, 74)
			DividerFrame.BackgroundTransparency = 0.500
			DividerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DividerFrame.BorderSizePixel = 0
			DividerFrame.ClipsDescendants = true
			DividerFrame.Size = UDim2.new(0, 237, 0, 22)
			DividerFrame.ZIndex = 4

			DividerCorner.Name = "DividerCorner"
			DividerCorner.Parent = DividerFrame

			DividerText.Name = "DividerText"
			DividerText.Parent = DividerFrame
			DividerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DividerText.BackgroundTransparency = 1.000
			DividerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DividerText.BorderSizePixel = 0
			DividerText.Size = UDim2.new(0, 237, 0, 22)
			DividerText.ZIndex = 5
			DividerText.FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			DividerText.Text = DividerTitle
			DividerText.TextColor3 = Color3.fromRGB(227, 227, 227)
			DividerText.TextSize = 22.000
			DividerText.TextWrapped = true
		end

		return Content
	end
	return TabSys
end
return Lib
