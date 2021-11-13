local Class = require 'libs.hump.class'

return Class {
  init = function(self, options)
    self.x = options.x or 0
    self.y = options.y or 0
    self.w = options.w or error("Button needs property w (width)")
    self.h = options.w or error("Button needs property h (height)")
    self.children = options.children or {}
    self.draw_func = options.draw_func or error("Element needs draw_func")
    self.transform_func = options.transform_func or function(x, y) return x, y end
  end,
  draw = function(self, x, y)
    self:draw_func(x, y)
  end,
  addChild = function(self, child)
    child.transform_func = self.transform_func
    table.insert(self.children, child)
  end,
  isInElement = function(self, x, y)
    print("Checking if in element...", x, y, "against", self.x, self.y)
    return
      x > self.x and
      x < self.x + self.w and
      y > self.y and
      y < self.y + self.h
  end,
  mousemoved = function(self, x, y)
    --local realX, realY = self.transform_func(x, y)
    local selfX, selfY = self.transform_func(self.x, self.y)
    print("um", selfX, selfY)
    if not selfX or not selfY then return end
    --print("mousemoved", x, y, self.debugName or "")
    for _, child in ipairs(self.children) do
      
      -- TODO: Add transform stuff here? (like just add parent something)
      child:mousemoved(x - selfX, y - selfY)
    end

    if self:isInElement(x, y) then
      if self.onHover then
        self:onHover(x, y)
      end
    end
  end
}
