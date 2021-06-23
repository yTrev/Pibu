local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Janitor = require(ReplicatedStorage.Janitor)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(buttonInstance: GuiButton, initialValue: boolean)
	local newJanitor = Janitor.new()

	local onToggle: BindableEvent = newJanitor:Add(Instance.new('BindableEvent'), 'Destroy')

	local self = setmetatable({
		Button = buttonInstance,
		OnToggle = onToggle.Event,
		Value = initialValue,
		_event = onToggle,
		_janitor = newJanitor,
	}, Toggle)

	newJanitor:Add(
		buttonInstance.Activated:Connect(function()
			self:Update()
		end),
		'Disconnect'
	)

	return self
end

function Toggle:Update(value: boolean)
	if value == nil then
		value = not self.Value
	end

	self.Value = value
	self._event:Fire(value)
end

function Toggle:Destroy()
	self._janitor:Destroy()
end

return Toggle
