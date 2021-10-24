local push = require "libs.push.push"

local SpriteSystem = Concord.system({ pool = {"position", "layer"}, camera = {"camera", "position" } })

local layers = {
  {
    name = "world",
    camera_tansform = true,
    entities = {}
  },
  {
    name = "ui",
    camera_tansform = false,
    entities = {}
  }
}

function SpriteSystem:init(world)
  --self.canvas = love.graphics.newCanvas(love.graphics.getDimensions())
  --Concord.entity(world):give("draw", self.canvas)

  self.pool.onAdded = function(_, entity)
    local layerName = entity.layer.name
    for _, layer in ipairs(layers) do
      if layer.name == layerName then
        table.insert(layer.entities, entity)
      end
    end
  end

  self.pool.onRemoved = function(_, entity)
    local layerName = entity.layer.name
    for _, layer in ipairs(layers) do
      if layer.name == layerName then
        table.remove_value(layer.entities, entity)
      end
    end
  end
end

-- function SpriteSystem:resize()
--   --self.canvas = love.graphics.newCanvas(love.graphics.getDimensions())
-- end

function SpriteSystem:draw()
  --love.graphics.clear(0.13, 0.15, 0.10)

  for _, layer in ipairs(layers) do
    love.graphics.push()

    if layer.camera_tansform and self.camera then
      local active_camera = functional.find_match(self.camera, function(cam_entity) return cam_entity.camera.active end)
      if active_camera then
        local camX, camY = active_camera.position.x, active_camera.position.y
        local w, h = push:getDimensions()
        love.graphics.translate((-camX+w/2), (-camY+h/2))
      end
    end

    for _, entity in ipairs(layer.entities) do
      local position = entity.position
      if (entity.health) then
        local red = entity.health.value/entity.health.max_health
        love.graphics.setColor(red/2+0.5, red, red)
      end

      if (entity.color) then
        local color = entity.color
        love.graphics.setColor(color.r, color.g, color.b, color.a)
      end

      local scale = entity.scale and entity.scale.value or 1
      local rotate = entity.rotate and entity.rotate.value or 0

      if entity.sprite then
        local originX = entity.origin and entity.origin.x or 0.5
        local originY = entity.origin and entity.origin.y or 0.5

        if (entity.sprite.quad) then
          local _, _, w, h = entity.sprite.quad:getViewport()
          love.graphics.draw(entity.sprite.value, entity.sprite.quad, position.x, position.y, rotate, scale, scale, w*originX, h*originY)
        else
          local width, height = entity.sprite.value:getDimensions()
          love.graphics.draw(entity.sprite.value, position.x, position.y, rotate, scale, scale, width*originX, height*originY)
        end
      end

      if (entity.health or entity.color) then
        love.graphics.setColor(1,1,1)
      end
    end

    love.graphics.pop()
  end
end

return SpriteSystem


