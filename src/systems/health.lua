local HealthSystem = Concord.system( {} )

function HealthSystem:do_damage(options)
  local against = options.against

  if against.health then
    against.health.value = against.health.value - options.damage
    if against.health.value <= 0 then
      self:getWorld():emit("kill_character", {
        character = against
      })
    end
  end
end

return HealthSystem
