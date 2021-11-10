local state = {}

function state:enter(from)
  self.from = from

  self.world = Concord.world()

  self.world:addSystems(
    ECS.s.helium
  )

  Concord.entity(self.world)
    :give("helium", {
      ui_def = require 'ui.game_over',
      active = true
    })
end

function state:update(dt)
  self.world:emit("update", dt)
end

function state:draw()
  self.from:draw()

  self.world:emit("draw")
  love.graphics.print("GAME OVER")
end

return state
