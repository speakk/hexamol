local KillSystem = Concord.system( { destroy_at_frame_end = { "destroy_at_frame_end" } } )

function KillSystem:kill_character(options)
  self:getWorld():emit("destroy_entity", { entity = options.character })
end

function KillSystem:destroy_entity(options)
  options.entity:give("destroy_at_frame_end")
end

function KillSystem:frame_end()
  for _, entity in ipairs(self.destroy_at_frame_end) do
    entity:destroy()
  end
end

return KillSystem

