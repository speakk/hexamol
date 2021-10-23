local in_game = {}

-- local function generate_map()
--   return {}
-- end

function in_game:load_game(_)
  self.world_width = 640
  self.world_height = 480
  self.world = Concord.world()

  self.world:addSystems( ECS.s.grid )
  self.world:emit("initialize_map_entities")
end

function in_game:enter()
  self:load_game()
end

function in_game:resize(w, h)
  self.world:emit("resize", w, h)
end

function in_game:update(dt)
  self.world:emit("frame_start")
  self.world:emit("update", dt)
  self.world:emit("frame_end")
end

function in_game:draw()
  love.graphics.clear(0.1, 0, 0, 1)
  self.world:emit("draw")
end

function in_game:key_pressed(key, scancode, isrepeat)
  --print("in game key", key)
  self.world:emit("key_pressed", key, scancode, isrepeat)
end

return in_game
