local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

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
    element:draw(self.x + (x or 0), self.y + (y or 0))
  end
  -- for i, element in ipairs(self.children) do
  --   if self.layout == "vertical" then
  --     --local padding = 5
  --     --element:draw(self.x, self.y + ((i-1) * (element.h + padding)))
  --   else
  --     element:draw(self.x + x, self.y + y)
  --   end
  -- end
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)

    self.layout = options.layout
  end,
  update = function(self)
    if self.layout == "vertical" then
      local padding = 10
      for i, child in ipairs(self.children) do
        child.x = 0
        child.y = ((i-1) * (child.h + padding))
      end
    end
  end
}
