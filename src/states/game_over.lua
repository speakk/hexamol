local state = {}

local Gamestate = require "libs.hump.gamestate"

local getMenu = function()
  local menu = require 'myui.elements.container'({
    layout = "vertical",
    x = 100,
    y = 100,
    w = 400,
    h = 400,
    transform_func = function(x, y) return push:toGame(x, y) end
  })

  menu:addChild(require 'myui.elements.button'(
    {
      w = 100,
      h = 100,
      text = "New Game",
      onClick = function()
        Gamestate.pop()
        Gamestate.switch(require('states.dummy'))
        Gamestate.switch(require('states.in_game'))
      end
    }))

  menu:addChild(require 'myui.elements.button'(
    {
      w = 100,
      h = 100,
      text = "Quit",
      onClick = function(self, x, y)
        love.event.quit()
      end
    }))

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

-- TODO: Make a "decorateState" functino that adds all mouse_pressed etc events

function state:mouse_pressed(x, y, button)
  self.world:emit("mouse_pressed", x, y, button)
end

return state
