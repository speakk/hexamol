local SpawnTeamsSystem = Concord.system({})

local baseSprite = love.graphics.newImage("media/base.png")

function SpawnTeamsSystem:spawn_base(team, bottom)
  local q, r
  local color = team.color

  if bottom then
    q, r = -3, 6
  else
    q, r = 3, -6
  end

  local targetHex = states.in_game.map:getHex(q, r)

  local entity = Concord.entity(self:getWorld())
  :give("sprite", baseSprite)
  :give("layer", "world")
  :give("position")
  :give("origin", 0.5, 0.9)
  :give("color", color.r, color.g, color.b)
  :give("is_in_team", team)
  :give("health", 200)
  :give("base")

  self:getWorld():emit("place_entity_in_hex", entity, targetHex)
end

function SpawnTeamsSystem:create_spawn_area(team1, team2)
  for q=-6,-4 do
    for r=4,6 do
      local hex1 = states.in_game.map:getHex(q, r)
      local hex2Coords = states.in_game.map.reflectHexR(hex1)
      local hex2 = states.in_game.map:getHex(hex2Coords.coordinates.q, hex2Coords.coordinates.r)
      hex1:give("spawn_hex", team1)
      hex2:give("spawn_hex", team1)

      local hex3Coords = states.in_game.map.reflectHexUp(hex1)
      local hex4Coords = states.in_game.map.reflectHexUp(hex2)
      local hex3 = states.in_game.map:getHex(hex3Coords.coordinates.q, hex3Coords.coordinates.r)
      local hex4 = states.in_game.map:getHex(hex4Coords.coordinates.q, hex4Coords.coordinates.r)
      hex3:give("spawn_hex", team2)
      hex4:give("spawn_hex", team2)
    end
  end

  -- TODO: Here is where you continue
  -- Check out the hovered coords, see what's up
  -- for q=4,6 do
  --   for r=2,-2 do
  --     local hex = states.in_game.map:getHex(q, r)
  --     hex:give("spawn_hex", team)
  --   end
  -- end
end

function SpawnTeamsSystem:initialize_map_entities()
  local player = Concord.entity(self:getWorld())
  :give("team", "player")
  :give("current_turn")
  :give("player_controlled")
  :give("color", 0.6, 1, 0.4)
  :give("action_points", 5)

  local ai = Concord.entity(self:getWorld())
  :give("team", "ai")
  :give("ai_controlled")
  :give("color", 0.9, 0.7, 1.0)
  :give("action_points", 5)

  self:spawn_base(player, true)
  self:spawn_base(ai)

  self:create_spawn_area(player, ai)
end


return SpawnTeamsSystem
