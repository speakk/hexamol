local AttackSystem = Concord.system({})

local attack_icon_sprite = love.graphics.newImage("media/attack_icon.png")

function AttackSystem:move_and_attack(options)
  assert (options.unit)
  assert (options.against)

  print("move_and_attack")

  local range = options.unit.movement_range and options.unit.movement_range.value or nil

  local path = options.path or states.in_game.path_finder:find_path(options.unit.is_in_hex.hex, options.against.is_in_hex.hex, range,
    { options.against.is_in_hex.hex },
  true)

  if not path then
    print("No path found in move_and_attack!", options.unit, options.against)
  end
  print("path", #path)

  -- TODO: Should we use take_turn_action here? Probably not
  -- In any case: Move entities close to target first
  self:getWorld():emit("move_entity", {
    path = path,
    unit = options.unit,
    -- TODO: Make this do take_turn_action
    finish_path_action = {
      event_name = "perform_attack",
      options = {
        unit = options.unit,
        against = options.against
      }
    }
  })
end

local function spawnAttackIcon(self, unit, against)
  local finalPosX = (unit.position.x + against.position.x) / 2
  local finalPosY = (unit.position.y + against.position.y) / 2

  local attackIcon = Concord.entity(self:getWorld())
    :give("position", finalPosX, finalPosY - 50)
    :give("scale", 1)
    :give("sprite", attack_icon_sprite)
    :give("layer", "icons")

  local length = 0.5
  flux.to(attackIcon.scale, length, { value = 2 }):oncomplete(function()
    self:getWorld():emit("destroy_entity", { entity = attackIcon })
  end)

end

function AttackSystem:perform_attack(options)
  local unit = options.unit
  local against = options.against

  local range = unit.attack_range and unit.attack_range.value or 1
  local distance = Gamestate.current().map:getDistance(unit.is_in_hex.hex, against.is_in_hex.hex)
  if range < distance then return end

  self:getWorld():emit("do_damage", {
    by = unit,
    against = against,
    damage = 1
  })

  spawnAttackIcon(self, unit, against)
end

return AttackSystem
