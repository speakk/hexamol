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

    if self.layout == "vertical" then
      local padding = 10
      local totalVertical = 0

      for i, child in ipairs(self.children) do
        local margin = 0
        if i > 1 then
          if self.children[i-1].margin then
            margin = self.children[i-1].margin
          end
        end
        totalVertical = totalVertical + child.h + padding + margin
      end

      local startY = self.h/2 - totalVertical/2

      local totalMargin = 0
      for i, child in ipairs(self.children) do
        local margin = 0
        if i > 1 then
          if self.children[i-1].margin then
            margin = self.children[i-1].margin
          end
        end

        totalMargin = totalMargin + margin

        child.x = self.w/2 - child.w/2
        child.y = startY + ((i-1) * (child.h + padding) + totalMargin)
      end
    end
  end
}
