local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.sprite, self.x + x, self.y + y)
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    self.sprite = options.sprite or error("Sprite element needs sprite")
    local w, h = self.sprite:getDimensions()
    options.w = w
    options.h = h

    BaseElement.init(self, options)
  end,
}

