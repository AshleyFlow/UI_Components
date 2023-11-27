local Fusion = require(script.Parent.Parent.fusion)
local Children = Fusion.Children
local Computed = Fusion.Computed
local DoNothing = Fusion.doNothing
local ForValues = Fusion.ForValues
local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Tween = Fusion.Tween
local Value = Fusion.Value

local defaultColor0 = Color3.new(1, 1, 1)
local defaultColor1 = Color3.fromRGB(253, 10, 10)
local defaultTween = TweenInfo.new(0.5)

return function(props)
	local open = Value(false)

	return New("Frame")({
		ClipsDescendants = false,
		Parent = props.Parent,
		Position = props.Position or UDim2.new(),
		BackgroundTransparency = 1,
		AnchorPoint = props.AnchorPoint or Vector2.new(),
		Size = props.Size or UDim2.fromScale(0.2, 0.5),
		[Children] = {
			--New("UIListLayout")({}),
			New("Frame")({
				BackgroundColor3 = defaultColor0,
				Position = Tween(
					Computed(function()
						return if open:get() then UDim2.new() else UDim2.fromScale(0, 0.5)
					end),
					defaultTween
				),
				Size = UDim2.fromScale(1, 0.15),
				[Children] = {
					New("UIPadding")({
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5),
						PaddingLeft = UDim.new(0, 15),
						PaddingRight = UDim.new(0, 15),
					}),
					New("UICorner")({}),
					New("TextButton")({
						ZIndex = 2,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						TextScaled = true,
						Text = "W.I.P",
						TextColor3 = defaultColor0:Lerp(Color3.new(), 0.15),
						[OnEvent("Activated")] = function()
							open:set(not open:get())
						end,
					}),
					New("ImageButton")({
						Image = "rbxassetid://6798365555",
						ImageColor3 = defaultColor1,
						Rotation = Tween(
							Computed(function()
								return if open:get() then 180 else 0
							end),
							defaultTween
						),
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(1, 0.5),
						Size = UDim2.fromScale(0.15, 1),
						ScaleType = Enum.ScaleType.Fit,
						[Children] = {
							New("UIScale")({ Scale = 0.5 }),
						},
					}),
				},
			}),
			New("Frame")({
				ClipsDescendants = true,
				BackgroundColor3 = defaultColor0,
				ZIndex = 0,
				BackgroundTransparency = 1,
				Position = Tween(
					Computed(function()
						return if open:get() then UDim2.fromScale(0, 0.15) else UDim2.fromScale(0, 0.6)
					end),
					defaultTween
				),
				Size = Tween(
					Computed(function()
						return if open:get() then UDim2.fromScale(1, 0.9) else UDim2.fromScale(1, 0)
					end),
					defaultTween
				),
				[Children] = {
					New("UIListLayout")({}),
					ForValues(props.Items, function(name)
						local colorify = Value(0)

						return New("TextLabel")({
							Size = UDim2.fromScale(1, (1 / #props.Items) / 2.5),
							Text = name,
							TextScaled = true,
							BackgroundColor3 = Tween(
								Computed(function()
									return defaultColor0:Lerp(defaultColor1, colorify:get())
								end),
								defaultTween
							),
							BackgroundTransparency = 0,
							[OnEvent("MouseEnter")] = function()
								colorify:set(0.1)
							end,
							[OnEvent("MouseLeave")] = function()
								colorify:set(0)
							end,
							[Children] = {
								New("UICorner")({}),
							},
						})
					end, DoNothing),
				},
			}),
		},
	})
end
