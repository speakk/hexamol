require "libs.batteries":export()
Concord = require "libs.concord"
inspect = require "libs.inspect"
vector = require "libs.hump.vector-light"

local push = require "libs.push.push"

local gameWidth, gameHeight = 640, 480 --fixed game resolution
love.graphics.setDefaultFilter('nearest', 'nearest')
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})

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
  in_game = require("states.in_game")
}

local main_state_machine = state_machine(states)

main_state_machine:set_state("in_game")

function love.update(dt)
  main_state_machine:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  if (main_state_machine:current_state().key_pressed) then
    main_state_machine:current_state():key_pressed(key, scancode, isrepeat)
  end
end

function love.mousemoved(x, y)
  if (main_state_machine:current_state().mouse_moved) then
    main_state_machine:current_state():mouse_moved(x, y)
  end
end

function love.resize(w, h)
  push:resize(w, h)
  if (main_state_machine:current_state().resize) then
    main_state_machine:current_state():resize(w, h)
  end
end

function love.draw()
  push:start()
  main_state_machine:draw()
  push:finish()
end
