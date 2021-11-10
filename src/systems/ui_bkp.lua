local UISystem = Concord.system({ action_points_pool = { "action_points", "current_turn" }})

local action_point_icon = love.graphics.newImage('media/action_point.png')

-- TODO: Ditch this and use actual max action points
local assumed_action_points = 10

local action_point_margin = 10

function UISystem:init(world)
  --local actionPointElementWidth = 500
  self.action_point_canvas = love.graphics.newCanvas(
    (action_point_icon:getWidth() + action_point_margin) * assumed_action_points, action_point_icon:getHeight()
  )

  local w, h = push:getDimensions()
  local actionPointX = w/2
  local actionPointY = h - 60
  --local actionPointX = w/2 - actionPointElementWidth/2
  --local actionPointY = h - 60
  self.action_point_entity = Concord.entity(world)
    :give("sprite", self.action_point_canvas)
    :give("position", actionPointX, actionPointY)
    :give("origin", 0.5, 0.5)
    :give("layer", "ui")
end

function UISystem:draw()
  local current_turn = self.action_points_pool[1]
  if not current_turn then return end

  local current_canvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.action_point_canvas)
  love.graphics.clear()
  local w = action_point_icon:getWidth() + action_point_margin
  for i=1,current_turn.action_points.value do
    love.graphics.draw(action_point_icon, (i-1) * w, 0)
  end
  love.graphics.setCanvas(current_canvas)
end

return UISystem
