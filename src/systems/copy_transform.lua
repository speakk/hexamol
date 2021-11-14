local CopyPosition = Concord.system({ pool = { "copy_transform", "position" }})

function CopyPosition:update(dt)
  for _, entity in ipairs(self.pool) do
    local target = entity.copy_transform.target_entity
    if entity.copy_transform.speed then
      entity.position.x = math.lerp(entity.position.x, target.position.x, 1 - math.pow(entity.copy_transform.speed, dt))
      entity.position.y = math.lerp(entity.position.y, target.position.y, 1 - math.pow(entity.copy_transform.speed, dt))
    else
      entity.position.x = target.position.x
      entity.position.y = target.position.y
    end
  end
end

return CopyPosition

