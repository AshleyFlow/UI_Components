local Fusion = require(script.Parent.Parent.fusion)
local Children = Fusion.Children
local Computed = Fusion.Computed
local DoNothing = Fusion.doNothing
local ForPairs = Fusion.ForPairs
local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Out = Fusion.Out
local Ref = Fusion.Ref
local Tween = Fusion.Tween
local Value = Fusion.Value

local defaultColor0 = Color3.new(1, 1, 1)
local defaultColor1 = Color3.new(0, 0.75, 1)
local defaultTweenInfo = TweenInfo.new(0.35)

type Props = {
	Position: UDim2?,
	Size: UDim2?,
	Tree: {},
	Index: any,
	Parent: Instance?,
	Color0: Color3?,
	Color1: Color3?,
	TweenInfo: TweenInfo?,
}

return function(props: Props)
	local tree = {}
	local main = Value()
	local main_absolutesize = Value(Vector2.zero)

	ForPairs(props.Tree, function(i: number, v: string)
		local hover = Value(false)
		local color = Computed(function()
			return if i ~= props.Index:get() then props.Color0 or defaultColor0 else props.Color1 or defaultColor1
		end)

		local visible = Computed(function()
			return if props.Index:get() < i then false else true
		end)

		local notLast = Computed(function()
			return i < props.Index:get()
		end)

		tree[i] = Value()

		return New("Frame")({
			[Ref] = tree[i],
			BackgroundColor3 = Tween(color, props.TweenInfo or defaultTweenInfo),
			Visible = visible,
			Size = Tween(
				Computed(function()
					local size = main_absolutesize:get() or Vector2.new()
					return if visible:get()
						then UDim2.new((1 / #props.Tree), -(size.X / #props.Tree), 1, 0)
						else UDim2.new(0, 0, 1, 0)
				end),
				props.TweenInfo or defaultTweenInfo
			),
			Name = v,
			Parent = main, -- if i == 1 then main else tree[i - 1]
			LayoutOrder = i,
			[OnEvent("MouseEnter")] = function()
				task.wait()
				hover:set(true)
			end,
			[OnEvent("MouseLeave")] = function()
				hover:set(false)
			end,
			[Children] = {
				New("TextButton")({
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Active = notLast,
					[OnEvent("Activated")] = function()
						props.Index:set(i)
					end,
				}),
				New("TextLabel")({
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = Tween(
						Computed(function()
							return UDim2.fromScale(notLast:get() and 0.1 or 0.25, 0.5)
						end),
						props.TweenInfo or defaultTweenInfo
					),
					Size = Computed(function()
						return UDim2.fromScale(notLast:get() and 0.9 or 0.75, 0.7)
					end),
					TextColor3 = Computed(function()
						return if notLast:get()
							then (props.Color0 or defaultColor0):Lerp(Color3.new(), 0.2)
							else props.Color0 or defaultColor0
					end),
					TextStrokeColor3 = (props.Color0 or defaultColor0):Lerp(Color3.new(), 0.2),
					TextStrokeTransparency = Tween(
						Computed(function()
							return if hover:get() and notLast:get() then 0.75 else 1
						end),
						props.TweenInfo or defaultTweenInfo
					),
					TextScaled = true,
					TextTransparency = Tween(
						Computed(function()
							return if visible:get() then 0 else 1
						end),
						props.TweenInfo or defaultTweenInfo
					),
					Text = v,
				}),
				Computed(function()
					return New("ImageLabel")({
						BackgroundTransparency = 1,
						ImageColor3 = Computed(function()
							return if notLast:get()
								then (props.Color0 or defaultColor0):Lerp(Color3.new(), 0.2)
								else props.Color0 or defaultColor0
						end),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Image = Computed(function()
							return if notLast:get() then "rbxassetid://8540264523" else "rbxassetid://13069510409"
						end),
						Size = Computed(function()
							return UDim2.fromScale(notLast:get() and 0.1 or 0.25, 1)
						end),
						[Children] = {
							Computed(function()
								return if notLast:get() then New("UIAspectRatioConstraint")({}) else nil
							end, DoNothing),
						},
					})
				end, DoNothing),
			},
		})
	end, DoNothing)

	return New("Frame")({
		[Ref] = main,
		Position = props.Position or UDim2.new(),
		Size = props.Size or UDim2.fromScale(1, 0.1),
		BackgroundTransparency = 1,
		Parent = props.Parent,
		[Children] = {
			New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			New("Frame")({
				--[Ref] = main,
				ClipsDescendants = false,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(0.1, 1),
				Name = "MainBranch",
				LayoutOrder = 0,
				[Out("AbsoluteSize")] = main_absolutesize,
				[Children] = {
					New("TextButton")({
						ZIndex = 2,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						[OnEvent("Activated")] = function()
							props.Index:set(0)
						end,
					}),
					New("ImageLabel")({
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						ImageColor3 = props.Color1 or defaultColor1,
						Image = "rbxassetid://4034483344",
						Size = UDim2.fromScale(0.8, 0.8),
						ScaleType = Enum.ScaleType.Fit,
					}),
					--New("UIAspectRatioConstraint")({}),
				},
			}),
		},
	})
end
