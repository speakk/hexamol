local SpawnTeamsSystem = Concord.system({})

local baseSprite = love.graphics.newImage("media/base.png")

function SpawnTeamsSystem:spawn_base(team)
  local q, r
  local colorR, colorG, colorB
  if team.player_controlled then
    q, r = -3, 6
    colorR, colorG, colorB = 0.6, 1, 0.4
  else
    q, r = 3, -6
    colorR, colorG, colorB = 0.9, 0.7, 1.0
  end

  local targetHex = states.in_game.map:getHex(q, r)

  local entity = Concord.entity(self:getWorld())
  :give("sprite", baseSprite)
  :give("layer", "world")
  :give("position")
  :give("origin", 0.5, 0.9)
  :give("color", colorR, colorG, colorB)
  :give("is_in_team", team)
  :give("health", 200)
  :give("base")

  self:getWorld():emit("place_entity_in_hex", entity, targetHex)
end

function SpawnTeamsSystem:initialize_map_entities()
  local player = Concord.entity(self:getWorld()):give("team", "player"):give("current_turn"):give("player_controlled"):give("action_points", 5)
  local ai = Concord.entity(self:getWorld()):give("team", "ai"):give("ai_controlled"):give("action_points", 5)

  self:spawn_base(player)
  self:spawn_base(ai)
end


return SpawnTeamsSystem
