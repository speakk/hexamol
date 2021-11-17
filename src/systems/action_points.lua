local ActionPointsSystem = Concord.system({ pool = { "action_points" }, bars = { "action_point_bar" } })

local actionPointSize = 5
local minSpacing = 7

function ActionPointsSystem:draw_bar(entity)
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

function ActionPointsSystem:init(world)
  self.pool.onAdded = function(_, entity)
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

    self:draw_bar(action_point_bar)
  end

end

function ActionPointsSystem:use_action_points(options)
  local action_points = options.unit.action_points
  action_points.value = action_points.value - options.amount
  print("action points now", action_points.value)

  if action_points.value <= 0 then
    self:getWorld():emit("ran_out_of_action_points", options.unit)
    action_points.value = 0
  end

  -- TODO: Just draw the one bar that changed
  for _, entity in ipairs(self.bars) do
    self:draw_bar(entity)
  end
end

function ActionPointsSystem:end_turn()
  for _, unit in ipairs(self.pool) do
    unit.action_points.value = unit.action_points.max
  end
end

return ActionPointsSystem
