local push = require "libs.push.push"

local outlineShader = love.graphics.newShader('src/shaders/outline.fs')

local SpriteSystem = Concord.system({ pool = {"position", "layer"}, camera = {"camera", "position" } })

local layers = {
  {
    name = "world",
    camera_tansform = true,
    z_sorted = true,
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

local function zSort(a, b)
  return a.position.y < b.position.y
end

function SpriteSystem:draw()

  for _, layer in ipairs(layers) do
    love.graphics.push()

    if layer.z_sorted then
      table.stable_sort(layer.entities, zSort)
    end

    if layer.camera_tansform and self.camera then
      local active_camera = functional.find_match(self.camera, function(cam_entity) return cam_entity.camera.active end)
      if active_camera then
        local camX, camY = active_camera.position.x, active_camera.position.y
        --local w, h = push:getDimensions()
        local w, h = love.graphics:getDimensions()
        love.graphics.translate((-camX+w/2), (-camY+h/2))
      end
    end

    for _, entity in ipairs(layer.entities) do
      local position = entity.position
      if (entity.health) then
        local red = entity.health.value/entity.health.max
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
          local w, h = entity.sprite.value:getDimensions()

          -- TODO: Move this outside this else statement
          if (entity.selected) then
            love.graphics.setShader(outlineShader)
            local thickness = 1
            if outlineShader:hasUniform("stepSize") then
              outlineShader:send( "stepSize",{thickness/w,thickness/h} )
            end
          end

          love.graphics.draw(entity.sprite.value, math.floor(position.x), math.floor(position.y), rotate, scale, scale, w*originX, h*originY)
        end

        if (entity.selected) then
          love.graphics.setShader()
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


