local PathHilightSystem = Concord.system( { selected = { "selected", "is_in_hex" } } )

--function PathHilightSystem:init()
--  --self.last_found_path = nil
--end

function PathHilightSystem:hex_hovered(hex)
  self.last_hovered_hex = hex
  --print("hex_hovered", hex)
end

function PathHilightSystem:update(dt)
  if states.in_game.map.last_hovered_hex then
    for _, entity in ipairs(self.selected) do
      local from = entity.is_in_hex.hex
      local path = states.in_game.path_finder:find_path(from, states.in_game.map.last_hovered_hex)

      if path then
        states.in_game.map:setLastFoundPath(path)
      end
    end
  end
end

return PathHilightSystem
