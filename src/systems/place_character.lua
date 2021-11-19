local PlaceCharacterSystem = Concord.system({ teams = { "team" }})

local characterSprite = love.graphics.newImage("media/character_a.png")
local characterSprite2 = love.graphics.newImage("media/character_b.png")

function PlaceCharacterSystem:place_character(options)
  assert(options.target_hex, "Hex not provided to place_character")

  print("Placing?", options.target_hex)

  local sprite = characterSprite
  local teamIndex = table.index_of(self.teams, options.team)
  if teamIndex == 2 then
    sprite = characterSprite2
  end

  local entity = Concord.entity(self:getWorld())
    :give("position")
    :give("sprite", sprite)
    :give("origin", 0.5, 1)
    :give("health", 3)
    :give("layer", "world")
    :give("can_be_selected")
    :give("can_be_moved")
    :give("movement_range", 4)
    :give("is_in_team", options.team)
    :give("action_points", 1)

  self:getWorld():emit("place_entity_in_hex", entity, options.target_hex)
  print("placed in...", options.target_hex.coordinates.q, options.target_hex.coordinates.r)
end

return PlaceCharacterSystem
