local HealthSystem = Concord.system( { pool = { "health" }, bars = { "health_bar", "sprite" } } )

function HealthSystem:do_damage(options)
  local by = options.by
  local against = options.against

  if against.health then
    against.health.value = against.health.value - options.damage
    if against.health.value <= 0 then
      self:getWorld():emit("kill_character", {
        by = by,
        character = against
      })
    end
  end

  self:getWorld():emit("health_changed", against)
end

return HealthSystem
