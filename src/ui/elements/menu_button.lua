local helium = require "libs.helium"
local useButton = require "libs.helium.shell.button"
local useState = require "libs.helium.hooks.state"
local flux = require "libs.flux"

local black = {0, 0, 0}

return helium(function(param, view)
	local colorAnim = useState(black)
	local animProg = useState{
		state = 0
	}

	local bState = useButton(
		param.onClick,
		nil,
		function()
			flux.to(colorAnim, 0.4, param.color)
			flux.to(animProg, 0.3, {state = 1})
		end,
		function()
			flux.to(colorAnim, 0.4, black)
			flux.to(animProg, 0.3, {state = 0})
		end
	)

	return function()
		love.graphics.setColor(param.color[1],param.color[2],param.color[3],animProg.state)
                if param.ico then
                  love.graphics.draw(param.ico,0+(50*animProg.state),(view.h/2)-(param.ico:getHeight()/2))
                end
		love.graphics.setColor(colorAnim[1],colorAnim[2],colorAnim[3],1)
		love.graphics.print(param.text,(20*animProg.state),12)
                print("Being drawn?")
	end
end)
