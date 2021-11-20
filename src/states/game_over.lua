local state = {}

function state:enter(from, options)
  self.from = from

  self.world = Concord.world()

  self.world:addSystems(
    ECS.s.ui
  )

  Concord.entity(self.world)
    :give("ui", {
      element = require 'ui.main_menu'(options),
      active = true
    })
end

function state:update(dt)
  self.world:emit("update", dt)
end

function state:draw()
  self.from:draw()
  self.world:emit("draw")
end

function state:mouse_moved(x, y)
  self.world:emit("mouse_moved", x, y)
end

-- TODO: Make a "decorateState" functino that adds all mouse_pressed etc events

function state:mouse_pressed(x, y, button)
  self.world:emit("mouse_pressed", x, y, button)
end

return state
