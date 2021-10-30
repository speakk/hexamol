local turn_actions = require 'models.turn_actions'
local AiSystem = Concord.system({
  ai_teams = { "team", "ai_controlled" },
  in_team = { "is_in_team" },
  current = { "current_turn", "team", "ai_controlled" }
})

function AiSystem:getTeamEntities(team)
  return functional.filter(self.in_team, function(entity)
    if entity.is_in_team.teamEntity == team then
      return true
    end
  end)
end

function AiSystem.init()
end

local action_delay = 1

function AiSystem:run_ai_turn(teamEntity)
  self.action_delay_timer = action_delay
  -- self.loop = coroutine.create(function()
  --   while (teamEntity.action_points.value > 0) do

  --   end
  -- end)

  --[[


  tick.delay(function()
    self:getWorld():emit("take_turn_action", teamEntity, turn_actions.end_turn)
  end, 2)
  --]]
end

local actions = {
  {
    -- Random move
    run = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if aiEntities then
        local randomEntity = table.pick_random(aiEntities)
        if randomEntity then
          local newRandomHex = states.in_game.map:getRandomFreeHex()
          if (newRandomHex) then
            self:getWorld():emit("take_turn_action", team,
              turn_actions.move_entities,
              {
                target_hex = newRandomHex,
                entities = { randomEntity }
              }
            )
          end
        end
      end
    end
  },
  {
    -- Random place
    run = function(self, team)
      local randomHex = states.in_game.map:getRandomFreeHex()
      self:getWorld():emit("take_turn_action", team,
        turn_actions.place_character,
        {
          target_hex = randomHex,
          team = team
        }
      )
    end
  }
}

function AiSystem:do_random_action(team)
  local action = table.pick_random(actions)
  action.run(self, team)
end

function AiSystem:update(dt)
  local current = self.current[1]
  if not current then return end

  self.action_delay_timer = self.action_delay_timer - dt
  if self.action_delay_timer <= 0 then
    self:do_random_action(current)
    self.action_delay_timer = action_delay
  end

  if current.action_points.value <= 0 then
    self:getWorld():emit("take_turn_action", current, turn_actions.end_turn)
  end
end

return AiSystem
