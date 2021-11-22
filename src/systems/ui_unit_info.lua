local UIUnitInfoSystem = Concord.system(
{
  action_points = { "action_points", "is_in_hex" },
  action_point_bars = { "action_point_bar" },
  health = { "health", "is_in_hex" },
  health_bars = { "health_bar" }
})

-- Action point bar
local actionPointSize = 5

-- Health bar
local barSize = 32
local padding = 2
local sizeY = 4
local minSizeX = 7

-- Common
local minSpacing = 7


function UIUnitInfoSystem:init(world)
  self.action_points.onAdded = function(_, entity)
    local action_points = entity.action_points
    local newCanvas = love.graphics.newCanvas((action_points.max) * actionPointSize, actionPointSize)

    local action_point_bar = Concord.entity(world)
    :give("sprite", newCanvas)
    :give("layer", "icons")
    :give("position")
    :give("origin", 0.5, 11)
    :give("child_of", entity)
    :give("copy_transform", entity)
    :give("action_point_bar", entity)

    -- TODO: Add check if already parent_of
    entity:give("parent_of", { action_point_bar })

    self:draw_action_point_bar(action_point_bar)
  end

  self.health.onAdded = function(_, entity)
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

    self:draw_health_bar(health_bar)
  end
end

function UIUnitInfoSystem.draw_action_point_bar(_, entity)
  local canvas = entity.sprite.value
  local previous_canvas = love.graphics.getCanvas()

  local action_points = entity.action_point_bar.target_entity.action_points

  local w, _ = canvas:getDimensions()

  love.graphics.push('all')
  love.graphics.origin()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.setColor(0.8, 1.0, 0.7, 1)
  local amount = action_points.value
  print(amount)
  local spacing = math.min(w / amount, minSpacing)
  local finalWidth = amount * math.floor(spacing)
  local startX = w/2 - finalWidth/2
  for i=1,amount do
    love.graphics.rectangle("fill", startX + (i-1) * math.floor(spacing), 0, actionPointSize, actionPointSize, 45)
  end
  love.graphics.setCanvas(previous_canvas)
  love.graphics.pop()
end

local findChild = function(pool, parent)
  for _, child in ipairs(pool) do
    if child.child_of.parent == parent then
      return child
    end
  end
end

function UIUnitInfoSystem:action_points_changed(parent_entity)
  local entity = findChild(self.action_point_bars, parent_entity)
  assert(entity, "No action point bar entity found for entity")

  self:draw_action_point_bar(entity)
end

function UIUnitInfoSystem:health_changed(parent_entity)
  local entity = findChild(self.health_bars, parent_entity)

  assert(entity, "No health bar entity found for entity")

  self:draw_health_bar(entity)
end

function UIUnitInfoSystem.draw_health_bar(_, entity)
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
  end
  love.graphics.setCanvas(previous_canvas)
  love.graphics.pop()
end


return UIUnitInfoSystem
