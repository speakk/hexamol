local AttackSystem = Concord.system({})

local attack_icon_sprite = love.graphics.newImage("media/attack_icon.png")

function AttackSystem:move_and_attack(options)
  assert (options.by)
  assert (options.against)

  -- TODO: Should we use take_turn_action here? Probably not
  -- In any case: Move entities close to target first
  self:getWorld():emit("move_entities", {
    path = options.path,
    entities = { options.by },
    -- TODO: Make this do take_turn_action
    finish_path_action = {
      event_name = "perform_attack",
      options = {
        by = options.by,
        against = options.against
      }
    }
  })
end

function AttackSystem:perform_attack(options)
  local by = options.by
  local against = options.against
  self:getWorld():emit("do_damage", {
    against = against,
    damage = 50
  })

  local finalPosX = math.lerp(by.position.x, against.position.x, 0.5)
  local finalPosY = math.lerp(by.position.y, against.position.y, 0.5)

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

return AttackSystem
