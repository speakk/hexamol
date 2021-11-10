local helium = require 'libs.helium'

local ui = {}

local elementCreator = helium(function(param, view)
  return function()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle('fill', 0, 0, view.w, view.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('UI!!')
  end
end)

local element = elementCreator({text = 'foo-bar'}, 100, 20)

function ui:drawElements()
  element:draw(200, 100)
end

return ui

