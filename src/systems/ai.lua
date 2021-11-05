local turn_actions = require 'models.turn_actions'
local AiSystem = Concord.system({
  ai_teams = { "team", "ai_controlled" },
  in_team = { "is_in_team", "can_be_moved" },
  current = { "current_turn", "team", "ai_controlled" },
  all_in_map = { "is_in_hex" }
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
  print("run_ai_turn", action_delay)
end

local actions = {
  {
    -- Random move
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then
        return false
      end

      return aiEntities
    end,
    run = function(self, team, aiEntities)
      assert(aiEntities)
      local randomEntity = table.pick_random(aiEntities)
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
    end,
    total_action_points = turn_actions.move_entities.action_points
  },
  {
    -- Random place
    isViable = function(self, team)
      return states.in_game.map:getRandomFreeHex()
    end,
    run = function(self, team, randomHex)
      assert(randomHex)
      self:getWorld():emit("take_turn_action", team,
        turn_actions.place_character,
        {
          target_hex = randomHex,
          team = team
        }
      )
    end,
    total_action_points = turn_actions.place_character.action_points
  },
  {
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then return false end
      local random_entity = table.pick_random(aiEntities)

      local enemies = functional.filter(self.all_in_map, function(entity)
        return entity.is_in_team.teamEntity ~= team
      end)

      if not enemies or #enemies == 0 then return false end

      return {
        random_entity = random_entity,
        enemies = enemies
      }
    end,
    -- Random attack
    run = function(self, team, data)
      assert(data.enemies)
      assert(data.random_entity)
      local enemies = data.enemies
      local random_entity = data.random_entity

      local random_enemy = table.pick_random(enemies)
      self:getWorld():emit("take_turn_action", team,
        turn_actions.move_and_attack,
        {
          by = random_entity,
          against = random_enemy
        }
      )
    end,
    total_action_points = turn_actions.move_and_attack.action_points
  }
}

function AiSystem:do_random_action(team)
  local action_datas = {}
  local viable_actions = functional.filter(actions, function(action)
    if action.total_action_points > team.action_points.value then
      return false
    end

    local action_data = action.isViable(self, team)
    if action_data then
      action_datas[action] = action_data
      return true
    end
  end)

  if #viable_actions == 0 then return false end

  local action = table.pick_random(viable_actions)
  local result = action.run(self, team, action_datas[action])
  return true
end

function AiSystem:update(dt)
  local current = self.current[1]
  if not current then return end

  self.action_delay_timer = self.action_delay_timer - dt
  local viable_left = true
  if self.action_delay_timer <= 0 then
    viable_left = self:do_random_action(current)
    self.action_delay_timer = action_delay
  end

  if current.action_points.value <= 0 or not viable_left then
    self:getWorld():emit("take_turn_action", current, turn_actions.end_turn)
  end
end

return AiSystem
