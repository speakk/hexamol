local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  if (self.currentTextColor) then
    love.graphics.setColor(self.currentTextColor)
  end
  love.graphics.setFont(self.font)
  love.graphics.printf(self.text, self.x + x, self.y + y, self.w, self.align)
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    self.font = options.font or love.graphics.getFont()
    self.font = options.font or love.graphics.getFont()
    self.align = options.align or "left"
    self.text = options.text or error("Text element needs text")
    options.w = options.w or self.font:getWidth(self.text)
    options.h = options.h or self.font:getHeight()

    BaseElement.init(self, options)

    self.originalTextColor = options.color or { 1.0, 0.8, 0.3 }
    --self.textHoverColor = { 0.0, 0.2, 0.3 }

    self.currentTextColor = {}
    for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
  end,
  onHover = function(self)
    if self.textHoverColor then
      for i=1,3 do self.currentTextColor[i] = self.textHoverColor[i] end
    end
  end,
  onHoverOut = function(self)
    if self.textHoverColor then
      for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
    end
  end,
}
