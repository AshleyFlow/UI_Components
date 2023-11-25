local Fusion = require(script.Parent.Parent.fusion)
local Children = Fusion.Children
local Computed = Fusion.Computed
local New = Fusion.New
local Event = Fusion.OnEvent
local Spring = Fusion.Spring
local Value = Fusion.Value

local cam = workspace.CurrentCamera
local vps = Value(cam.ViewportSize)
cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	vps:set(cam.ViewportSize)
end)

type Props = {
	Color0: Color3?,
	Color1: Color3?,
	Color2: Color3?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Size: UDim2?,
	Parent: Instance?,
}

return function(props)
	local color0 = props.Color0 or Color3.new(1, 1, 1)
	local color1 = props.Color1 or Color3.new(1, 0, 0)
	local color2 = props.Color2 or Color3.new(0, 0.75, 1)

	local cornerRadius = Value(10)
	local scaleSpring = Spring(Value(1), 15, 0.35)
	local cornerRadiusSpring = Spring(cornerRadius, 10, 0.5)
	local transparencySpring = Spring(Value(0), 15, 0.5)
	local colorifySpring = Spring(Value(0), 15, 0.5)

	return New("Frame")({
		Parent = props.Parent,
		Size = props.Size or UDim2.fromScale(0.15, 0.15),
		Position = props.Position or UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		BackgroundColor3 = Spring(
			Computed(function()
				return if props.Tick:get() then color2 else color0
			end),
			15,
			0.5
		),
		BackgroundTransparency = transparencySpring,
		[Children] = {
			New("UIAspectRatioConstraint")({}),
			New("UIScale")({ Scale = scaleSpring }),
			New("UICorner")({
				CornerRadius = Computed(function()
					return UDim.new(0, cornerRadiusSpring:get())
				end),
			}),
			New("UIStroke")({
				Color = Computed(function()
					return color0:Lerp(Color3.new(), 0.1):Lerp(color1, colorifySpring:get())
				end),
				Thickness = Spring(
					Computed(function()
						return if props.Tick:get() then 0 else (vps:get() or Vector2.zero).Magnitude / 200
					end),
					15,
					0.35
				),
			}),
			New("ImageLabel")({
				BackgroundTransparency = 1,
				Image = "rbxassetid://14189590169",
				Rotation = Spring(
					Computed(function()
						return if props.Tick:get() then 0 else -15
					end),
					15,
					0.25
				),
				Size = UDim2.fromScale(1, 1),
				Visible = props.Tick,
				[Children] = {
					New("UIScale")({
						Scale = Spring(
							Computed(function()
								return if props.Tick:get() then 1 else 0.85
							end),
							15,
							0.25
						),
					}),
				},
			}),
			New("TextButton")({
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				[Event("Activated")] = function()
					cornerRadiusSpring:addVelocity(60)
					transparencySpring:addVelocity(4)
					colorifySpring:addVelocity(0.5)
					scaleSpring:addVelocity(-0.1)

					props.Tick:set(not props.Tick:get())
				end,
				[Event("MouseButton1Down")] = function()
					cornerRadius:set(15)
				end,
				[Event("MouseButton1Up")] = function()
					cornerRadius:set(10)
				end,
			}),
		},
	})
end
