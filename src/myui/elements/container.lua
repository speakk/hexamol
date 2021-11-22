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
      local totalVertical = 0

      for i, child in ipairs(self.children) do
        local margin = 0
        if i > 1 then
          if self.children[i-1].margin then
            margin = self.children[i-1].margin
          end
        end
        totalVertical = totalVertical + child.h + margin
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
        child.y = startY + ((i-1) * (child.h + margin) + totalMargin)
      end
    end

    if self.layout == "horizontal" then
      -- HORIZONTAL LAYOUT BEGIN --
      -- TODO: Move into helper
      local padding = 5
      local totalHorizontal = 0

      for i, child in ipairs(self.children) do
        local margin = 0
        if i > 1 then
          if self.children[i-1].margin then
            margin = self.children[i-1].margin
          end
        end
        totalHorizontal = totalHorizontal + child.w + padding + margin
      end

      local startX = self.w/2 - totalHorizontal/2

      for i, child in ipairs(self.children) do
        local margin = 0
        if i > 1 then
          if self.children[i-1].margin then
            margin = self.children[i-1].margin
          end
        end

        child.x = startX + ((i-1) * (child.w + (i > 1 and padding or 0) + margin))
        child.y = self.h/2 - child.h/2
      end
    end
  end
}
