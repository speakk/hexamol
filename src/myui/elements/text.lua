local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  -- local w = self.font:getWidth(self.text)
  -- local h = self.font:getHeight()
  if (self.currentTextColor) then
    love.graphics.setColor(self.currentTextColor)
  end
  --love.graphics.print(self.text, self.x + (x or 0), self.y + (y or 0))
  --love.graphics.print(self.text, self.x/2 - realW/2 + (x or 0), self.y + (y or 0))
  -- local textX = self.x + x + ((self.w - w) / 2)
  -- local textY = self.y + y + ((self.h - h) / 2)
  love.graphics.setFont(self.font)
  love.graphics.print(self.text, self.x + x, self.y + y)
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    self.font = options.font or love.graphics.getFont()
    self.font = options.font or love.graphics.getFont()
    self.text = options.text or error("Text element needs text")
    options.w = self.font:getWidth(self.text)
    options.h = self.font:getHeight()

    BaseElement.init(self, options)

    self.originalTextColor = options.color or { 1.0, 0.8, 0.3 }
    self.textHoverColor = { 0.0, 0.2, 0.3 }

    self.currentTextColor = {}
    for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
  end,
  onHover = function(self, x, y)
    for i=1,3 do self.currentTextColor[i] = self.textHoverColor[i] end
  end,
  onHoverOut = function(self, x, y)
    for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
  end,
}
