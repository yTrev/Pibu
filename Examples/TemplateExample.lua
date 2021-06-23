local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Button = require(ReplicatedStorage.Button)
local newButton = Button.newFromTemplate('SimpleToggle', guiButton, true)

newButton.OnToggle:Connect(function(newValue: boolean)
	print(string.format('New value: %q', tostring(newValue)))
end)
