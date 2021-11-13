local state = {}

local getMenu = function()
  local menu = require 'myui.elements.container'({
    x = 100,
    y = 100,
    w = 400,
    h = 400,
    children = {
      require 'myui.elements.button'({ w = 100, h = 100, text = "New Game"}),
    }
  })

  return menu
end

function state:enter(from)
  self.from = from

  self.world = Concord.world()

  self.world:addSystems(
    ECS.s.helium
  )

  Concord.entity(self.world)
    :give("helium", {
      ui_element = getMenu(),
      active = true
    })
end

function state:update(dt)
  self.world:emit("update", dt)
end

function state:draw()
  self.from:draw()

  self.world:emit("draw")
  --love.graphics.print("GAME OVER STATE INIT")
end

function state:debugDraw()
  self.world:emit("debugDraw")
end

function state:mouse_moved(x, y)
  self.world:emit("mouse_moved", x, y)
end

return state
