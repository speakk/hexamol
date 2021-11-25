local Map = require 'models.map'
local PathFinder = require 'models.path_finder'
local state = {}

function state:enter(from)
  self.from = from

  self.world = Concord.world()

  self.world:addSystems(
    ECS.s.grid, ECS.s.sprite,
    ECS.s.ui, ECS.s.hover_handler
  )

  self.map = Map(320, 240, 28, self.world, "square")
  self.path_finder = PathFinder(self.map)


  Concord.entity(self.world)
    :give("ui", {
      element = require 'ui.main_menu'(),
      active = true
    })
    :remove("serializable")

  self.world:emit("initialize_map_entities")
end

function state:update(dt)
  self.world:emit("frame_start", dt)
  self.world:emit("update", dt)
  self.world:emit("frame_end")
end

function state:draw()
  love.graphics.clear(0.13, 0.15, 0.10)
  self.world:emit("draw")
end

function state:mouse_moved(x, y)
  self.world:emit("mouse_moved", x, y)
end

function state:leave()
  self.world:clear()
end

-- TODO: Make a "decorateState" functino that adds all mouse_pressed etc events

function state:mouse_pressed(x, y, button)
  self.world:emit("mouse_pressed", x, y, button)
end

return state

