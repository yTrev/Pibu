local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Pibu = require(ReplicatedStorage.Pibu)

local newButton = Pibu.new(guiButton, {
	Style = 'Example',
})

newButton.OnClick:Connect(function()
	print('Click!')
end)
