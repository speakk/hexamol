local helium = require 'libs.helium'

local HeliumSystem = Concord.system({ pool = { "helium" }})

--local renderer = require 'myui.myui'()

function HeliumSystem:init()
  self.pool.onAdded = function(_, entity)
    --entity.renderer = require 'myui_myui'()
    -- entity.helium.scene = helium.scene.new(true)
    -- print("Activating and drawing...")

    -- entity.helium.scene:activate()
    -- entity.helium.ui_element:draw()
    -- entity.helium.scene:draw()

    -- if not entity.helium.active then
    --   entity.helium.scene:deactivate()
    -- end
  end
end

-- function HeliumSystem:activate(entity)
--   entity.helium.scene:activate()
--   entity.helium.active = true
-- end
-- 
-- function HeliumSystem:deactivate(entity)
--   entity.helium.scene:deactivate()
--   entity.helium.active = false
-- end

function HeliumSystem:update(dt)
  for _, entity in ipairs(self.pool) do
    if entity.helium.active then
      --entity.helium.scene:update(dt)
    end
  end
end

function HeliumSystem:draw()
  for _, entity in ipairs(self.pool) do
    if entity.helium.active then
      --entity.helium.ui_element:draw()
      --entity.helium.scene:draw()
      entity.helium.ui_element:draw()
    end
    --print("DRAWING")
  end
end

function HeliumSystem:resize(w, h)
  for _, entity in ipairs(self.pool) do
    --entity.helium.scene:setPixelScale(push._SCALE.x, push._SCALE.x)
    entity.helium.ui_element:draw()
    --entity.helium.scene:resize(w, h)
  end
end

function HeliumSystem:mouse_moved(x, y)
  local realX, realY = push:toGame(x, y)
  for _, entity in ipairs(self.pool) do
    entity.helium.ui_element:mousemoved(realX, realY)
    --entity.helium.ui_element:mousemoved(x, y)
  end
end

-- function HeliumSystem:debugDraw()
--   for _, entity in ipairs(self.pool) do
--     if entity.helium.active then
--       entity.helium.scene:drawInputBoxes()
--     end
--     --print("DRAWING")
--   end
-- 
-- end

return HeliumSystem
