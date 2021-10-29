local AttackSystem = Concord.system({})

function AttackSystem:make_attack(options)
  assert (options.by)
  assert (options.against)

  print("Pew pew")

  -- TODO: Should we use take_turn_action here? Probably not
  -- In any case: Move entities close to target first
  self:getWorld():emit("move_entities", {
    target_hex = options.against.is_in_hex,
    stop_next_to_target = true,
    force_target_available = true,
    entities = { options.by }
  })
end

return AttackSystem
