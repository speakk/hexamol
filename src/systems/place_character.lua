local PlaceCharacterSystem = Concord.system({})
local push = require "libs.push.push"

local characterSprite = love.graphics.newImage("media/character_a.png")

function PlaceCharacterSystem:place_character(x, y, team)
  team = team or 1
  local screenX, screenY = push:toGame(x, y)
  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)

  print("Placing?", hex)

  if hex then
    Concord.entity(self:getWorld())
      :give("position")
      :give("is_in_hex", hex)
      :give("sprite", characterSprite)
      :give("origin", 0.5, 1)
      :give("layer", "world")
      :give("team", team)
  end
end

return PlaceCharacterSystem
