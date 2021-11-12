require "libs.batteries":export()
Concord = require "libs.concord"
Class = require "libs.hump.class"
inspect = require "libs.inspect"
vector = require "libs.hump.vector-light"
tick = require "libs.tick"
flux = require "libs.flux"

local Gamestate = require "libs.hump.gamestate"

push = require "libs.push.push"

local gameWidth, gameHeight = 640, 480 --fixed game resolution
love.graphics.setDefaultFilter('nearest', 'nearest')
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = false, canvas = false })
--push:setupCanvas({ { name = "action_points" } })

-- Enable require without specifying 'src' in the beginning
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";src/?.lua")

-- CONCORD CONFIG START --
-- Create global Concord aliases for ease of access

--local assemblageUtil = require "utils.assemblage"

ECS = {
  c = Concord.components,
  -- a = assemblageUtil.createAssemblageHierarchy("src/assemblages"),
  s = {},
}

Concord.utils.loadNamespace("src/components")
Concord.utils.loadNamespace("src/systems", ECS.s)
-- CONCORD CONFIG END --

states = {
  in_game = require("states.in_game"),
  game_over = require("states.game_over")
}

--local main_state_machine = state_machine(states)

--main_state_machine:set_state("in_game")

Gamestate.switch(states.in_game)

function love.update(dt)
  tick.update(dt)
  flux.update(dt)
  --main_state_machine:update(dt)
  Gamestate.current():update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  if (Gamestate.current().key_pressed) then
    Gamestate.current():key_pressed(key, scancode, isrepeat)
  end
end

function love.mousemoved(x, y)
  if (Gamestate.current().mouse_moved) then
    Gamestate.current():mouse_moved(x, y)
  end
end

function love.mousepressed(x, y, button)
  if (Gamestate.current().mouse_pressed) then
    Gamestate.current():mouse_pressed(x, y, button)
  end
end

function love.resize(w, h)
  push:resize(w, h)
  if (Gamestate.current().resize) then
    Gamestate.current():resize(w, h)
  end
end

function love.draw()
  push:start()
  --main_state_machine:draw()
  Gamestate.current():draw()
  push:finish()
end
