local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  love.graphics.setColor(1,0.6,0.6,1)
  love.graphics.rectangle(
    'fill',
    self.x + (x or 0),
    self.y + (y or 0),
    self.w,
    self.h
  )

  if self.text then
    love.graphics.setColor(0,0.0,0.6,1)
    love.graphics.print(self.text, self.x + (x or 0), self.y + (x or 0))
  end

  for _, element in ipairs(self.children) do
    element:draw(self.x, self.y)
  end
end

local Button = Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)

    self.text = options.text
    self.debugName = "button"
  end,
  onHover = function(self, x, y)
    print("HOVERED!")
  end
}

return Button
