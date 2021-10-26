local PlaceCharacterSystem = Concord.system({})

local characterSprite = love.graphics.newImage("media/character_a.png")

function PlaceCharacterSystem:place_character(hex, team)
  assert(hex, "Hex not provided to place_character")

  print("Placing?", hex)

  Concord.entity(self:getWorld())
    :give("position")
    :give("is_in_hex", hex)
    :give("sprite", characterSprite)
    :give("origin", 0.5, 1)
    :give("layer", "world")
    :give("is_in_team", team)
end

return PlaceCharacterSystem
