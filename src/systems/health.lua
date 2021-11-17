local HealthSystem = Concord.system( { pool = { "health" }, bars = { "health_bar", "sprite" } } )

local barSize = 32
local padding = 2
local sizeY = 4
local minSpacing = 7
local minSizeX = 7

function HealthSystem:draw_bar(entity)
  local canvas = entity.sprite.value
  local previous_canvas = love.graphics.getCanvas()

  local health = entity.health_bar.target_entity.health

  love.graphics.push('all')
  love.graphics.origin()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.setColor(0.8, 0.7, 0.7, 1)
  local amount = health.value
  local spacing = math.min(barSize / amount, minSpacing)
  local sizeX = math.min(math.floor((spacing) - padding), minSizeX)
  local finalWidth = amount * math.floor(spacing)
  local startX = barSize/2 - finalWidth/2
  for i=1,amount do
    love.graphics.rectangle("fill", startX + (i-1) * math.floor(spacing), 0, sizeX, sizeY, 45)
  --love.graphics.rectangle("fill", 0, 0, 100, 100)
  end
  love.graphics.setCanvas(previous_canvas)
  love.graphics.pop()
end

function HealthSystem:init(world)
  self.pool.onAdded = function(_, entity)
    local newCanvas = love.graphics.newCanvas(barSize, sizeY)

    local health_bar = Concord.entity(world)
    :give("sprite", newCanvas)
    :give("layer", "icons")
    :give("position")
    :give("origin", 0.5, -2)
    :give("child_of", entity)
    :give("copy_transform", entity)
    :give("health_bar", entity)

    -- TODO: Add check if already parent_of
    entity:give("parent_of", { health_bar })

    self:draw_bar(health_bar)
  end
end

function HealthSystem:do_damage(options)
  local against = options.against

  if against.health then
    against.health.value = against.health.value - options.damage
    if against.health.value <= 0 then
      self:getWorld():emit("kill_character", {
        character = against
      })
    end
  end

  for _, entity in ipairs(self.bars) do
    self:draw_bar(entity)
  end
end

return HealthSystem
