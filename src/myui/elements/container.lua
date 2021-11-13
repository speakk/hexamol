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
    self.backgroundColor = options.backgroundColor
  end,
  update = function(self)
    BaseElement.update(self)

    if self.layout == "vertical" then
      local padding = 10
      local totalVertical = 0

      for _, child in ipairs(self.children) do
        totalVertical = totalVertical + child.h + padding
      end

      local startY = self.h/2 - totalVertical/2

      for i, child in ipairs(self.children) do
        child.x = self.w/2 - child.w/2
        child.y = startY + ((i-1) * (child.h + padding))
      end
    end
  end
}
