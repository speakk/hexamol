local Map = require 'models.map'
local PathFinder = require 'models.path_finder'

local serpent = require 'libs.serpent'

local Gamestate = require 'libs.hump.gamestate'
local game_over = require 'states.game_over'

local in_game = {}

function in_game:load_game(options)
  self.world_width = 640
  self.world_height = 480
  self.world = Concord.world()
  self.paused = false

  self.world:addSystems(
    ECS.s.input, ECS.s.player_input, ECS.s.hover_handler, ECS.s.click_handler,
    ECS.s.map_click_handler, ECS.s.turn, ECS.s.attack, ECS.s.turn_action,
    ECS.s.ai, ECS.s.path_hilight, ECS.s.health, ECS.s.kill, ECS.s.action_points,
    ECS.s.select_entity, ECS.s.move_entity, ECS.s.place_character, ECS.s.is_in_hex,
    ECS.s.path_finding, ECS.s.grid, ECS.s.sprite, ECS.s.debug,
    ECS.s.spawn_teams,
    ECS.s.base, ECS.s.game_over, ECS.s.ui, ECS.s.parent_of, ECS.s.copy_transform,
    ECS.s.currency, ECS.s.ui_currency, ECS.s.ui_unit_info, ECS.s.ui_right_bar
  )

  self.map = Map(320, 240, 6, self.world)
  self.path_finder = PathFinder(self.map)

  if not options.load_previous then
    self.world:emit("initialize_map_entities", options.against_ai)
    self.world:emit("start_turn")
  else
    local dataString = love.filesystem.read("save_file")
    local _, data = serpent.load(dataString)
    print("Start deseralizing")
    self.world:deserialize(data, false)
    self.world:emit("game_loaded")
  end
end

function in_game:enter(_, options)
  self:load_game(options)
end

function in_game:resize(w, h)
  self.world:emit("resize", w, h)
end

function in_game:update(dt)
  self.world:emit("frame_start", dt)
  self.world:emit("update", dt)
  self.world:emit("frame_end")
end

function in_game:draw()
  love.graphics.clear(0.13, 0.15, 0.10)
  self.world:emit("draw")
end

function in_game:leave()
  print("leave?")
  self.world:clear()
end

function in_game.game_over(_, winning_team)
  Gamestate.push(game_over, {
    game_finished = true,
    winning_team = winning_team
  })
end

function in_game:key_pressed(key, scancode, isrepeat)
  --print("in game key", key)
  self.world:emit("key_pressed", key, scancode, isrepeat)

  -- TODO: Game over test
  if key == 'g' then self.world:emit("game_over", false) end

  if key == 'f5' then
    local data = self.world:serialize()

    print(inspect(data))
    love.filesystem.write("save_file", serpent.block(data))
  end

  if key == 'f9' then
    local dataString = love.filesystem.read("save_file")
    local _, data = serpent.load(dataString)
    self.world:deserialize(data, true)
  end
end

function in_game:mouse_moved(x, y)
  self.world:emit("mouse_moved", x, y)
end

function in_game:mouse_pressed(x, y, button)
  self.world:emit("mouse_pressed", x, y, button)
end

return in_game
