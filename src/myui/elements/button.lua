local Class = require 'libs.hump.class'
local BaseElement = require 'myui.elements.BaseElement'

local function draw_func(self, x, y)
  love.graphics.setColor(self.currentColor)
  love.graphics.rectangle(
  'fill',
  self.x + (x or 0),
  self.y + (y or 0),
  self.w,
  self.h
  )
end

return Class {
  __includes = BaseElement,
  init = function(self, options)
    options.draw_func = options.draw_func or draw_func
    BaseElement.init(self, options)

    self.debugName = "button"
    self.originalColor = { 0.6, 0.4, 0.3 }
    self.hoverColor = { 0.8, 0.8, 0.5 }

    self.currentColor = {}
    for i=1,3 do self.currentColor[i] = self.originalColor[i] end
  end,
  onHover = function(self, x, y)
    for i=1,3 do self.currentColor[i] = self.hoverColor[i] end
    for _, child in ipairs(self.children) do
      if child.onHover then
        child:onHover(x, y)
      end
    end
  end,
  onHoverOut = function(self, x, y)
    --print("Hover out!")
    for i=1,3 do self.currentColor[i] = self.originalColor[i] end
    for _, child in ipairs(self.children) do
      if child.onHoverOut then
        child:onHoverOut(x, y)
      end
    end
  end,
  update = function(self)
    BaseElement.update(self)

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
}
