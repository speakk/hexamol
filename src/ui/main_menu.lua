local font = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 48, "mono")
local titleFont = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 82, "mono")

local Gamestate = require "libs.hump.gamestate"

return function(options)
  options = options or {}
  local screenW, screenH = push:getDimensions()

  local fullscreenContainer = require 'myui.elements.container'({
    layout = "vertical",
    w = screenW,
    h = screenH,
    transform_func = function(x, y) return push:toGame(x, y) end
  })

  local menu = require 'myui.elements.container'({
    layout = "vertical",
    w = 530,
    h = 400,
    backgroundColor = {0.2, 0.7, 0.5, 0.1}
  })

  fullscreenContainer:addChild(menu)

  local text = "HEXAMOL"
  if options.game_finished then
    text = options.winning_team.team.name .. " WON!"
  end

  menu:addChild(require 'myui.elements.text'({
    text = text,
    font = titleFont,
    margin = 20,
    color = { 1, 0.4, 0.2 }
  }))

  local buttonMargin = 10

  menu:addChild(require 'myui.elements.button'(
  {
    w = 380,
    h = 50,
    margin = buttonMargin,
    onClick = function()
      -- Workaround to make sure leave is called in in_game
      local stateTack = Gamestate.getStack()
      if #stateTack > 1 then
        Gamestate.pop()
      end
      Gamestate.switch(require('states.dummy'))
      Gamestate.switch(require('states.in_game'), true)
    end
  })):addChild(require 'myui.elements.text'(
  {
    text = "New Game (vs AI)",
    font = font,
  }
  ))

  menu:addChild(require 'myui.elements.button'(
  {
    w = 480,
    h = 50,
    margin = buttonMargin,
    onClick = function()
      -- Workaround to make sure leave is called in in_game
      local stateTack = Gamestate.getStack()
      if #stateTack > 1 then
        Gamestate.pop()
      end
      Gamestate.switch(require('states.dummy'))
      Gamestate.switch(require('states.in_game'), false)
    end
  })):addChild(require 'myui.elements.text'(
  {
    text = "New Game (vs Player)",
    font = font
  }
  ))

  menu:addChild(require 'myui.elements.button'(
  {
    w = 100,
    h = 50,
    margin = buttonMargin,
    onClick = function()
      love.event.quit()
    end
  })):addChild(require 'myui.elements.text'(
  {
    text = "Quit",
    font = font
  }
  ))
  return fullscreenContainer
end


