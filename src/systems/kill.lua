local KillSystem = Concord.system( {} )

function KillSystem:kill_character(options)
  self:getWorld():emit("destroy_entity", { entity = options.character })
end

function KillSystem:destroy_entity(options)
  options.entity:destroy()
end

return KillSystem

