local TweenService = game:GetService('TweenService')

local TWEEN_INFO: TweenInfo = TweenInfo.new(0.75, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local SIZES: { [string]: number } = {
	Selected = 1.15,
	Default = 1,
	Click = 0.75,
}

local uiScales: { [GuiButton]: UIScale } = {}

local function tweenUIScale(uiScale: UIScale, targetSize: number)
	TweenService
		:Create(uiScale, TWEEN_INFO, {
			Scale = targetSize,
		})
		:Play()
end

return {
	Setup = function(buttonObject)
		local objectToTween = buttonObject._objectToTween
		local buttonJanitor = buttonObject._janitor

		local uiScale: UIScale? = objectToTween:FindFirstChild('UIScale')
		if not uiScale then
			uiScale = buttonJanitor:Add(Instance.new('UIScale'))
			uiScale.Parent = objectToTween
		end

		buttonJanitor:Add(function()
			uiScales[objectToTween] = nil
		end)

		uiScales[objectToTween] = uiScale
	end,

	Click = function(button: GuiButton, hovering: boolean)
		local uiScale: UIScale = uiScales[button]
		uiScale.Scale = SIZES.Click

		tweenUIScale(uiScale, hovering and SIZES.Selected or SIZES.Default)
	end,

	Hover = function(button: GuiButton, hovering: boolean)
		tweenUIScale(uiScales[button], hovering and SIZES.Selected or SIZES.Default)
	end,
}
