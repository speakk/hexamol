local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function on_hover(self, x, y)

end

local function draw_func(self, x, y)
  love.graphics.setColor(0,0.1,0.1,1)
  love.graphics.rectangle(
    'fill',
    self.x + (x or 0),
    self.y + (y or 0),
    self.w,
    self.h
  )

  for _, element in ipairs(self.children) do
    element:draw(self.x, self.y)
  end
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)
  end,
}
