local turn_actions = require 'models.turn_actions'

local MapClickHandlerSystem = Concord.system({ playerTeams = { "player_controlled", "team" }, isInMap = { "is_in_hex" }, selected = { "selected" } })

function MapClickHandlerSystem:handle_map_click(hex)
  local team = self.playerTeams[1]

  local entity_exists_in_hex = states.in_game.map:isHexOccupied(hex)

  if entity_exists_in_hex then
    if entity_exists_in_hex.is_in_team.teamEntity == team then
      self:getWorld():emit("select_entity", entity_exists_in_hex)
    elseif #(self.selected) > 0 then
      self:getWorld():emit("take_turn_action", team,
        turn_actions.move_and_attack,
        {
          by = self.selected[1],
          against = entity_exists_in_hex,
          path = states.in_game.map.last_found_path
        }
      )
    end
  elseif #(self.selected) > 0 then
    self:getWorld():emit("take_turn_action", team,
      turn_actions.move_entities,
      {
        target_hex = hex,
        entities = self.selected
      }
    )
  else
    self:getWorld():emit("take_turn_action", team,
      turn_actions.place_character,
      {
        target_hex = hex,
        team = team
      }
    )
  end
end

return MapClickHandlerSystem

