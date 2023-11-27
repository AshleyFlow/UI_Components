local Fusion = require(script.Parent.Parent.Parent.fusion)
local Children = Fusion.Children
local New = Fusion.New
local Value = Fusion.Value

return function(parent)
	local tick1 = Value(false)
	local tick2 = Value(false)
	local tick3 = Value(false)

	local obj = New("Frame")({
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		Parent = parent,
		[Children] = {
			require(script.Parent)({
				Tick = tick1,
			}),
			require(script.Parent)({
				Tick = tick2,
				Position = UDim2.fromScale(0.5, 0.25),
			}),
			require(script.Parent)({
				Tick = tick3,
				Position = UDim2.fromScale(0.5, 0.75),
			}),
		},
	})

	return function()
		tick1:set(nil)
		tick2:set(nil)
		tick3:set(nil)
		obj:Destroy()
		obj = nil
	end
end
