local PlaceCharacterSystem = Concord.system({})

local characterSprite = love.graphics.newImage("media/character_a.png")
local characterSprite2 = love.graphics.newImage("media/character_b.png")

function PlaceCharacterSystem:place_character(options)
  assert(options.target_hex, "Hex not provided to place_character")

  print("Placing?", options.target_hex)

  local sprite = characterSprite
  if options.team.ai_controlled then
    sprite = characterSprite2
  end

  local entity = Concord.entity(self:getWorld())
    :give("position")
    :give("sprite", sprite)
    :give("origin", 0.5, 1)
    :give("health", 100)
    :give("layer", "world")
    :give("is_in_team", options.team)

  self:getWorld():emit("place_entity_in_hex", entity, options.target_hex)
end

return PlaceCharacterSystem
