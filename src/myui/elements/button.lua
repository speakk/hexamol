local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local font = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 48, "mono")

local function draw_func(self, x, y)
  love.graphics.setColor(self.currentColor)
  love.graphics.rectangle(
    'fill',
    self.x + (x or 0),
    self.y + (y or 0),
    self.w,
    self.h
  )

  if self.text then
    local w = font:getWidth(self.text)
    local h = font:getHeight()
    if (self.currentTextColor) then
      love.graphics.setColor(self.currentTextColor)
    end
    --love.graphics.print(self.text, self.x + (x or 0), self.y + (y or 0))
    --love.graphics.print(self.text, self.x/2 - realW/2 + (x or 0), self.y + (y or 0))
    local textX = self.x + x + ((self.w - w) / 2)
    local textY = self.y + y + ((self.h - h) / 2)
    love.graphics.setFont(font)
    love.graphics.print(self.text, textX, textY)
  end

  for _, element in ipairs(self.children) do
    element:draw(x + self.x, y + self.y)
  end
end

local Button = Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)

    self.text = options.text
    self.debugName = "button"
    self.originalColor = { 0.6, 0.4, 0.3 }
    self.hoverColor = { 0.8, 0.8, 0.5 }
    self.originalTextColor = { 1.0, 0.8, 0.3 }
    self.textHoverColor = { 0.0, 0.2, 0.3 }

    self.currentColor = {}
    for i=1,3 do self.currentColor[i] = self.originalColor[i] end
    self.currentTextColor = {}
    for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
  end,
  onHover = function(self, x, y)
    --print("HOVERED!")
    for i=1,3 do self.currentColor[i] = self.hoverColor[i] end
    for i=1,3 do self.currentTextColor[i] = self.textHoverColor[i] end
  end,
  onHoverOut = function(self, x, y)
    --print("Hover out!")
    for i=1,3 do self.currentColor[i] = self.originalColor[i] end
    for i=1,3 do self.currentTextColor[i] = self.originalTextColor[i] end
  end
}

return Button
