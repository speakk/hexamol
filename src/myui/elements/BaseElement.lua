local Class = require 'libs.hump.class'

return Class {
  init = function(self, options)
    self.x = options.x or 0
    self.y = options.y or 0
    self.w = options.w or error("Element needs property w (width)")
    self.h = options.h or error("Element needs property h (height)")
    self.children = options.children or {}
    self.draw_func = options.draw_func or error("Element needs draw_func")
    self.transform_func = options.transform_func or function(x, y) return x, y end
    self.onClick = options.onClick
    self.margin = options.margin
  end,
  draw = function(self, x, y)
    self:draw_func(x, y)
    for _, element in ipairs(self.children) do
      element:draw(self.x + (x or 0), self.y + (y or 0))
    end
  end,
  addChild = function(self, child)
    child.transform_func = self.transform_func
    table.insert(self.children, child)

    return child
  end,
  isInElement = function(self, x, y)
    return
      x > self.x and
      x < self.x + self.w and
      y > self.y and
      y < self.y + self.h
  end,
  mouse_moved = function(self, x, y)
    if not self.x or not self.y then return end
    if not x or not y then return end

    for _, child in ipairs(self.children) do
      child:mouse_moved(x - self.x, y - self.y)
    end

    if self:isInElement(x, y) then
      if self.onHover then
        self:onHover(x, y)
      end
    else
      if self.onHoverOut then
        self:onHoverOut(x, y)
      end
    end
  end,
  mouse_pressed = function(self, x, y, button)
    if not self.x or not self.y then return end
    if not x or not y then return end

    for _, child in ipairs(self.children) do
      child:mouse_pressed(x - self.x, y - self.y, button)
    end

    if self:isInElement(x, y) then
      if self.onClick then
        self:onClick(x, y)
      end
    end
  end,
  update = function(self, dt)
    for _, child in ipairs(self.children) do
      child:update(dt)
    end
  end
}
