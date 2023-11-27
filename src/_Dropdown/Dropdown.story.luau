--local Fusion = require(script.Parent.Parent.Parent.fusion)

return function(parent: Instance)
	local obj = require(script.Parent)({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Parent = parent,
		Items = {
			"Test1",
			"Test3",
			"Test4",
		},
	})

	return function()
		obj:Destroy()
	end
end
