local RunService = game:GetService("RunService")
local Fusion = require(script.Parent.Parent.Parent.fusion)
local Value = Fusion.Value

return function(parent)
	local rng = Random.new()
	local alpha = Value(1)
	local obj = require(script.Parent)({
		Alpha = alpha,
		Parent = parent,
	})

	local last = os.clock()
	local c = RunService.Heartbeat:Connect(function()
		if os.clock() - last > 1 then
			alpha:set(rng:NextNumber(0, 1))
			last = os.clock()
		end
	end)

	return function()
		c:Disconnect()
		c = nil
		rng = nil
		obj:Destroy()
		obj = nil
	end
end
