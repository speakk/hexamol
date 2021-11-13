local UiSystem = Concord.system({ pool = { "ui" }})

function UiSystem:update(dt)
  for _, entity in ipairs(self.pool) do
    if entity.ui.active then
      entity.ui.element:update(dt)
    end
  end
end

function UiSystem:draw()
  for _, entity in ipairs(self.pool) do
    if entity.ui.active then
      entity.ui.element:draw()
    end
  end
end

function UiSystem:mouse_moved(x, y)
  local realX, realY = push:toGame(x, y)
  for _, entity in ipairs(self.pool) do
    entity.ui.element:mouse_moved(realX, realY)
  end
end

function UiSystem:mouse_pressed(x, y, button)
  local realX, realY = push:toGame(x, y)
  for _, entity in ipairs(self.pool) do
    entity.ui.element:mouse_pressed(realX, realY, button)
  end
end

return UiSystem
