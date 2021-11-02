local PathHilightSystem = Concord.system( { selected = { "selected", "is_in_hex" }, player_controlled = { "player_controlled", "team" } } )

function PathHilightSystem:hex_hovered(hex)
  self.last_hovered_hex = hex
end

function PathHilightSystem:isEntityEnemy(entity)
  if not entity then return end
  local playerTeam = self.player_controlled[1]
  if not playerTeam then return end

  if entity.is_in_team.teamEntity ~= playerTeam then
    return true
  end
end

function PathHilightSystem:update(dt)
  if states.in_game.map.last_hovered_hex then
    local hexEntity = states.in_game.map:getHexEntities(states.in_game.map.last_hovered_hex)
    local containsEnemies = self:isEntityEnemy(hexEntity)

    for _, entity in ipairs(self.selected) do
      local from = entity.is_in_hex.hex
      local path
      if containsEnemies then
        path = states.in_game.path_finder:find_path(from, states.in_game.map.last_hovered_hex, { states.in_game.map.last_hovered_hex }, true)
      else
        path = states.in_game.path_finder:find_path(from, states.in_game.map.last_hovered_hex)
      end

      if path then
        states.in_game.map:setLastFoundPath(path)
      end
    end
  end
end

return PathHilightSystem
