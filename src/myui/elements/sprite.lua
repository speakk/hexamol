local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.sprite, self.x + x, self.y + y, 0, self.scale, self.scale)
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    self.sprite = options.sprite or error("Sprite element needs sprite")
    self.scale = options.scale or 1
    local spriteW, spriteH = self.sprite:getDimensions()
    spriteW = spriteW * self.scale
    spriteH = spriteH * self.scale
    options.w = options.w or spriteW
    options.h = options.h or spriteH

    BaseElement.init(self, options)
  end,
}

