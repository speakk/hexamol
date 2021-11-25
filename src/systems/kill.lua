local KillSystem = Concord.system( { destroy_at_frame_end = { "destroy_at_frame_end" } } )

function KillSystem:kill_character(options)
  self:getWorld():emit("destroy_entity", { entity = options.character })
  self:getWorld():emit("reward_killer", { killer = options.by })
end

-- TODO: Rewards somewhere else
function KillSystem:reward_killer(options)
  -- self:getWorld():emit("change_currency", {
  --   team = options.killer.is_in_team.team,
  --   amount = 1
  -- })
end

function KillSystem.destroy_entity(_, options)
  options.entity:give("destroy_at_frame_end")
end

function KillSystem:frame_end()
  for _, entity in ipairs(self.destroy_at_frame_end) do
    entity:destroy()
  end
end

return KillSystem

