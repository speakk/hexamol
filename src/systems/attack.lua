local AttackSystem = Concord.system({})

function AttackSystem:make_attack(options)
  assert (options.by)
  assert (options.against)

  -- TODO: Should we use take_turn_action here? Probably not
  -- In any case: Move entities close to target first
  self:getWorld():emit("move_entities", {
    path = options.path,
    entities = { options.by }
  })
end

return AttackSystem
