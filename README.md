# Pibu
Pibu é um module que vai te auxiliar na hora de criar botões com interações, como: animações quando o mouse passar em cima do botão, quando o botão for clicado etc. Com ele também é possível criar botões mais complexos, como Toggles e Sliders.

### Dependências
[Janitor](https://github.com/howmanysmall/Janitor)

### Styles
O _Pibu_ possui uma pasta chamada `Styles`, ela é utilizada para armazenar os estilos de animações de cada botão. Por padrão existe uma animação chamada "Example", que mostra como ela pode ser utilizada na prática.

Para aplicar um Style a um botão é muito simples, aqui um exemplo:
```lua
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Pibu = require(ReplicatedStorage.Pibu)

local newButton = Pibu.new(guiButton, {
	Style = 'Example'
})

local function onClick() 
	print('Click!') 
end

newButton.OnClick:Connect(onClick)
```

![Style_Example](https://cdn.discordapp.com/attachments/565259586341437466/857313690100563978/xvMOWqN1lD.mp4)

### Templates
O _Pibu_ possui uma pasta chamada `Templates`, ela é utilizada para armazenar templates de botões, como um Slider ou um Toggle.

Para utilizar os templates que você criar é extremamente simples, aqui um exemplo:
```lua
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Pibu = require(ReplicatedStorage.Pibu)

local newButton = Pibu.newFromTemplate('SimpleToggle', guiButton)

local function onToggle(newValue: boolean) 
	print(string.format('New value: %q', tostring(newValue)))
end

newButton.OnToggle:Connect(onToggle)
```

![Template_Example](https://cdn.discordapp.com/attachments/556880110897201163/841428428045549608/Yy6wc5Fr2H.mp4)