local KillSystem = Concord.system( {} )

function KillSystem:kill_character(options)
  options.character:destroy()
end

return KillSystem

