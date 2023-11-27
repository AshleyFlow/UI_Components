local Fusion = require(script.Parent.Parent.fusion)
local Children = Fusion.Children
local Computed = Fusion.Computed
local New = Fusion.New
local Out = Fusion.Out
local Tween = Fusion.Tween
local Value = Fusion.Value

type Props = {
	Color0: CanBeState<Color3>?,
	Color1: CanBeState<Color3>?,
	AnchorPoint: CanBeState<Vector2>?,
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	Parent: CanBeState<Instance>?,
	Alpha: StateObject<number>,
}

return function(props: Props)
	local abs_size = Value()

	return New("Frame")({
		BackgroundTransparency = 1,
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		Size = props.Size or UDim2.fromScale(0.5, 0.15),
		Parent = props.Parent,
		[Out("AbsoluteSize")] = abs_size,
		[Children] = {
			--New("UIAspectRatioConstraint")({}),
			New("Frame")({
				-- Frame1
				BackgroundColor3 = props.Color0 or Color3.new(1, 1, 1),
				Size = UDim2.fromScale(1, 1),
				[Children] = {
					New("UICorner")({
						CornerRadius = UDim.new(0.5, 0),
					}),
				},
			}),
			New("Frame")({
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = Tween(
					Computed(function()
						return UDim2.fromScale(props.Alpha:get(), 1)
					end),
					TweenInfo.new(0.5)
				),
				[Children] = {
					New("Frame")({
						-- Frame2
						BackgroundColor3 = props.Color1 or Color3.new(1, 0, 0),
						Size = Computed(function()
							if abs_size:get() == nil then
								return UDim2.new()
							end

							return UDim2.fromOffset(abs_size:get().X + 1, abs_size:get().Y + 1)
						end),
						[Children] = {
							New("UICorner")({
								CornerRadius = UDim.new(0.5, 0),
							}),
						},
					}),
				},
			}),
		},
	})
end
