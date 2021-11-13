local font = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 48, "mono")
local titleFont = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 82, "mono")

local Gamestate = require "libs.hump.gamestate"

return function()
  local screenW, screenH = push:getDimensions()

  local fullscreenContainer = require 'myui.elements.container'({
    layout = "vertical",
    w = screenW,
    h = screenH,
    transform_func = function(x, y) return push:toGame(x, y) end
  })

  local menu = require 'myui.elements.container'({
    layout = "vertical",
    w = 400,
    h = 400,
    backgroundColor = {0.2, 0.7, 0.5, 0.1}
  })

  fullscreenContainer:addChild(menu)

  menu:addChild(require 'myui.elements.text'({
    text = "HEXAMOL",
    font = titleFont,
    margin = 20,
    color = { 1, 0.4, 0.2 }
  }))

  menu:addChild(require 'myui.elements.button'(
    {
      w = 200,
      h = 50,
      onClick = function()
        --Gamestate.pop()
        Gamestate.switch(require('states.dummy'))
        Gamestate.switch(require('states.in_game'))
      end
    })):addChild(require 'myui.elements.text'(
    {
      text = "New Game",
      font = font
    }
    ))

  menu:addChild(require 'myui.elements.button'(
    {
      w = 100,
      h = 50,
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


