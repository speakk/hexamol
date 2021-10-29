local MoveEntitySystem = Concord.system({})

function MoveEntitySystem.move_entities(_, options)
  for _, entity in ipairs(options.entities) do
    entity:remove("selected") -- TODO: Should unselecting be done elsewhere?

    if options.path then
      entity:give("has_path", options.path)
    else
      local from = entity.is_in_hex.hex
      entity:give("wants_path", from, options.target_hex)
      entity:remove("has_path")
    end
    states.in_game.map:setLastFoundPath(nil)
  end
end

return MoveEntitySystem
