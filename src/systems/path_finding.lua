local PathFindingSystem = Concord.system({ selected = { "selected", "is_in_hex" }, wantsPath = { "wants_path" }, hasPath = { "has_path" } })

function PathFindingSystem:update(dt)
  for _, entity in ipairs(self.wantsPath) do
    -- TODO: Threaded / coroutines?
    local path = states.in_game.path_finder:find_path(entity.wants_path.from, entity.wants_path.to)
    if path then
      entity:give("has_path", path)
      entity:remove("wants_path")
    end
  end

  for _, entity in ipairs(self.hasPath) do
    local hasPath = entity.has_path
    local currentIndex = hasPath.currentIndex or 1

    local path = hasPath.path
    local currentNode = path[currentIndex]
    assert (currentNode, "No currentNode found?")
    self:getWorld():emit("place_entity_in_hex", entity, currentNode)

    hasPath.currentIndex = currentIndex + 1

    local endIndex = #path
    if self.hasPath.stop_next_to_target then
      endIndex = endIndex - 1
    end

    if hasPath.currentIndex > endIndex then
      self:getWorld():emit("path_finished", entity)
    end
  end
end

function PathFindingSystem:path_finished(entity)
  entity:remove("has_path")
  print("Finished path!")
end

return PathFindingSystem
