local PathFindingSystem = Concord.system({ selected = { "selected", "is_in_hex" }, wantsPath = { "wants_path" }, hasPath = { "has_path" } })

function PathFindingSystem:init()
  self.wantsPath.onAdded = function(_, entity)
    --print("entityAdded?")
    -- TODO: Threaded / coroutines?
    local path = states.in_game.path_finder:find_path(entity.wants_path.from, entity.wants_path.to)
    entity:give("has_path", path)
    entity:remove("wants_path")
    --print("Gave path", inspect(path))
  end
end

function PathFindingSystem:hex_hovered(hex)
  --print("hex_hovered", hex)
  for _, entity in ipairs(self.selected) do
    local from = entity.is_in_hex.hex
    --local target = states.in_game.path_finder:find_path(from, hex)
    --print("Gave wants_path")
    entity:give("wants_path", from, hex)
  end
end

function PathFindingSystem:update(dt)
  for _, hasPath in ipairs(self.hasPath) do
    for _, hex in ipairs(hasPath.has_path.path) do
      hex.hilight_path = true
    end
  end
end

return PathFindingSystem
