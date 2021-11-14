local ParentOfSystem = Concord.system({ pool = {"parent_of"} })

function ParentOfSystem:destroy_entity(options)
  if options.entity.parent_of then
    for _, entity in ipairs(options.entity.parent_of.children) do
      self:getWorld():emit("destroy_entity", { entity = entity } )
    end
  end
end

return ParentOfSystem
