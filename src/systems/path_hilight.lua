local PathHilightSystem = Concord.system( { selected = { "selected", "is_in_hex" } } )

function PathHilightSystem:init()
  self.hilightEntity = Concord.entity(self:getWorld())
  self.last_hovered_hex = nil
end

function PathHilightSystem:hex_hovered(hex)
  self.last_hovered_hex = hex
  --print("hex_hovered", hex)
end

function PathHilightSystem:update(dt)
  if self.last_hovered_hex then
    for _, entity in ipairs(self.selected) do
      local from = entity.is_in_hex.hex
      local path = states.in_game.path_finder:find_path(from, self.last_hovered_hex)

      if path then
        for _, hex in ipairs(path) do
          hex.hilight_path = true
        end
      end
    end
  end
end

return PathHilightSystem
