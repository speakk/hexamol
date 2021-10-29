local AttackSystem = Concord.system({})

function AttackSystem:move_and_attack(options)
  assert (options.by)
  assert (options.against)

  -- TODO: Should we use take_turn_action here? Probably not
  -- In any case: Move entities close to target first
  self:getWorld():emit("move_entities", {
    path = options.path,
    entities = { options.by },
    -- TODO: Make this do take_turn_action
    finish_path_action = {
      event_name = "perform_attack",
      options = {
        by = options.by,
        against = options.against
      }
    }
  })
end

function AttackSystem:perform_attack(options)
  --self:getWorld():emit("do_damage", options.against, options.attack.damage)
  self:getWorld():emit("do_damage", {
    against = options.against,
    damage = 50
  })
end

return AttackSystem
