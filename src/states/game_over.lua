local state = {}

function state:enter(from)
  self.from = from
end

function state:update(dt)

end

function state:draw()
  self.from:draw()

  love.graphics.print("GAME OVER")
end

return state
