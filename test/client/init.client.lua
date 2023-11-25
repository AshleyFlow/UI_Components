local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Modules.fusion)
local Children = Fusion.Children
local New = Fusion.New
local Value = Fusion.Value

local myTree = { "Test1", "Test2", "Test3", "WOW", "OK", "YE TE TE TE", "DUGUDUGUDGUDu" }
local index = Value(#myTree)

New("ScreenGui")({
	Parent = Players.LocalPlayer.PlayerGui,
	[Children] = {
		require(ReplicatedStorage.Modules.uicomponents.Breadcrumb)({
			Tree = myTree,
			Index = index,
		}),
		require(ReplicatedStorage.Modules.uicomponents.Checkbox)({
			Tick = Value(false),
		}),
	},
})

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.R then
		index:set(#myTree)
	end
end)
