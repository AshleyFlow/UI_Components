local RunService = game:GetService("RunService")
local Fusion = require(script.Parent.Parent.Parent.fusion)
local Value = Fusion.Value

return function(parent: Instance)
	local myTree = { "1", "2", "3", "4", "5 6 7" }
	local index = Value(#myTree)
	local obj = require(script.Parent)({
		Index = index,
		Tree = myTree,
		Parent = parent,
	})

	local last = os.clock()
	local random = RunService.Heartbeat:Connect(function()
		if os.clock() - last > 3 then
			index:set(#myTree)
			last = os.clock()
		end
	end)

	return function()
		random:Disconnect()
		obj:Destroy()
	end
end
