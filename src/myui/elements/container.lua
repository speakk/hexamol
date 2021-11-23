local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle(
    'fill',
    self.x + (x or 0),
    self.y + (y or 0),
    self.w,
    self.h
    )
  end
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)

    self.layout = options.layout
    self.backgroundColor = options.backgroundColor
  end,
  update = function(self)
    BaseElement.update(self)
  end
}
