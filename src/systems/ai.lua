local turn_actions = require 'models.turn_actions'
local AiSystem = Concord.system({ ai_teams = { "team", "ai_controlled" }, pool = { "is_in_team" }})

function AiSystem:getAiEntities()
  return functional.filter(self.pool, function(entity)
    for _, team in ipairs(self.ai_teams) do
      if entity.is_in_team.teamEntity == team then
        return true
      end
    end
  end)
end

function AiSystem:run_ai_turn(teamEntity)
  -- TODO: Make it do stuff!

  local randomHex = states.in_game.map:getRandomFreeHex()
  self:getWorld():emit("take_turn_action", teamEntity,
    turn_actions.place_character,
    {
      target_hex = randomHex,
      team = teamEntity
    }
  )

  local aiEntities = self:getAiEntities()
  if aiEntities then
    local randomEntity = table.pick_random(aiEntities)
    if randomEntity then
      local newRandomHex = states.in_game.map:getRandomFreeHex()
      if (newRandomHex) then
        randomEntity:give("wants_path", randomEntity.is_in_hex.hex, newRandomHex)
      end
    end
  end

  tick.delay(function()
    self:getWorld():emit("take_turn_action", teamEntity, turn_actions.end_turn)
  end, 2)
end

return AiSystem
