local characterSprite = "media/character_a_1.png"
local characterSprite2 = "media/character_a_2.png"

local teamSprites = { characterSprite, characterSprite2 }

return function(entity, options)
  assert(options.teamIndex, "Character A assemblage needs teamIndex")
  local sprite = teamSprites[options.teamIndex]

  entity
  :give("position")
  :give("sprite", sprite)
  :give("origin", 0.5, 0.9)
  :give("health", 3)
  :give("layer", "world")
  :give("can_be_selected")
  :give("can_be_moved")
  :give("movement_range", 4)
  :give("action_points", 0, 1)
  :give("assemblage_id", "character_a")
  :ensure("key")
end
