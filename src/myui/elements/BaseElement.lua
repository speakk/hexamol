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
    return
      x > self.x and
      x < self.x + self.w and
      y > self.y and
      y < self.y + self.h
  end,
  mousemoved = function(self, x, y)
    print("mousemoved", x, y)
    for _, child in ipairs(self.children) do
      -- TODO: Add transform stuff here? (like just add parent something)
      child:mousemoved(x, y)
    end

    if self:isInElement(x, y) then
      if self.onHover then
        self:onHover(x, y)
      end
    end
  end
}
