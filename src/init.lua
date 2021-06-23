-- ===========================================================================
-- Modules
-- ===========================================================================
local Janitor = require(script.Parent.Janitor)

-- ===========================================================================
-- Constants
-- ===========================================================================
local VALID_INPUTS = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.Touch] = true,
	[Enum.KeyCode.ButtonA] = true,
}

-- ===========================================================================
-- Variables
-- ===========================================================================
local Styles = {}

--stylua: ignore
local getTemplate do
	local loadedTemplates: { [string]: any } = {}

	getTemplate = function(template: string)
		local isLoaded = loadedTemplates[template]
		if isLoaded then
			return isLoaded
		else
			local loadedModule = require(script.Templates[template])
			loadedTemplates[template] = loadedModule

			return loadedModule
		end
	end
end

local stylesModules: { ModuleScript } = script.Styles
for _: number, styleModule: ModuleScript in ipairs(stylesModules:GetChildren()) do
	Styles[styleModule.Name] = require(styleModule)
end

local Pibu = {}
Pibu.__index = Pibu

type ButtonSettings = {
	ClickCooldown: number,
	MainObject: GuiObject?,
}

function Pibu.new(buttonInstance: GuiButton, buttonSettings: ButtonSettings): Button
	assert(buttonInstance:IsA('GuiButton'), string.format("%q isn't a valid button!", buttonInstance:GetFullName()))

	buttonSettings = buttonSettings or {}

	local newJanitor: any = Janitor.new()
	local clickEvent: BindableEvent = newJanitor:Add(Instance.new('BindableEvent'), 'Destroy')
	local hoverEvent: BindableEvent = newJanitor:Add(Instance.new('BindableEvent'), 'Destroy')

	local self = setmetatable({
		OnClick = clickEvent.Event,
		OnHover = hoverEvent.Event,
		Button = buttonInstance,

		Settings = buttonSettings,
		_objectToTween = buttonSettings.MainObject or buttonInstance,
		_click = clickEvent,
		_hover = hoverEvent,
		_janitor = newJanitor,
	}, Pibu)

	if buttonSettings.Style then
		self:SetStyle(buttonSettings.Style)
	end

	newJanitor:Add(
		buttonInstance.Activated:Connect(function()
			self:Click()
		end),
		'Disconnect'
	)

	newJanitor:Add(
		buttonInstance.MouseEnter:Connect(function()
			self:Hover(true)
		end),
		'Disconnect'
	)

	newJanitor:Add(
		buttonInstance.MouseLeave:Connect(function()
			self:Hover(false)
		end),
		'Disconnect'
	)

	self._janitor:Add(function()
		table.clear(self)
		setmetatable(self, nil)
	end, true)

	return self
end

function Pibu:AddActivator(button: GuiButton)
	self._janitor:Add(
		button.InputBegan:Connect(function(inputObject: InputObject)
			if button.Active and VALID_INPUTS[inputObject.UserInputType] or VALID_INPUTS[inputObject.KeyCode] then
				self:Click()
			end
		end),
		'Disconnect'
	)
end

function Pibu.newFromTemplate(template: string, ...)
	local templateModule = getTemplate(template)

	return templateModule.new(...)
end

function Pibu:ApplyTemplate(template: string)
	getTemplate(template)(self)
end

function Pibu:SetStyle(style: string)
	local styleModule = Styles[style]
	styleModule.Setup(self)

	self._style = styleModule
end

function Pibu:Click()
	local cooldown: number? = self.Settings.Cooldown
	if cooldown then
		local now: number = time()
		local lastClick: number? = self._lastClick

		if lastClick then
			local delta: number = (now - lastClick)
			if delta <= cooldown then
				return
			end
		end

		self._lastClick = now
	end

	local buttonStyle = self._style
	if buttonStyle and buttonStyle.Click then
		buttonStyle.Click(self._objectToTween, self._isHover)
	end

	self._click:Fire()
end

function Pibu:Hover(bool: boolean)
	self._hover:Fire(bool)

	self._isHover = bool

	local buttonStyle = self._style
	if buttonStyle then
		buttonStyle.Hover(self._objectToTween, bool)
	end
end

function Pibu:Destroy()
	self._janitor:Destroy()
end

export type Button = typeof(Pibu.new())

return Pibu
