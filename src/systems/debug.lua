local DebugSystem = Concord.system({ teams = { "team" }})

function DebugSystem:draw()
  love.graphics.printf("Teams: ", 10, 10, 100)
  for i, entity in ipairs(self.teams) do
    local label = entity.team.name
    if entity.current_turn then
      label = label .. " <"
    end
    love.graphics.printf(label, 10, 30 + 20 * i, 100)
  end
end

return DebugSystem
