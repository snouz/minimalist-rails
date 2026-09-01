local function israil(entity)
  if entity and (entity.name == "straight-rail-minimal" 
  or entity.name == "curved-rail-a-minimal" 
  or entity.name == "curved-rail-b-minimal" 
  or entity.name == "half-diagonal-rail-minimal") then
    return true
  else
    return false
  end
end
local function iselevatedrail(entity)
  if entity and (entity.name == "elevated-straight-rail-minimal" 
  or entity.name == "elevated-curved-rail-a-minimal" 
  or entity.name == "elevated-curved-rail-b-minimal" 
  or entity.name == "elevated-half-diagonal-rail-minimal"
  or entity.name == "rail-ramp-minimal" ) then
    return true
  else
    return false
  end
end

local function get_connected_rails(entity)
  local connected = {}
  if israil(entity) or iselevatedrail(entity) then
    local rail_directions = {defines.rail_direction.front, defines.rail_direction.back}
    local connection_directions = {defines.rail_connection_direction.left, defines.rail_connection_direction.straight, defines.rail_connection_direction.right}

    for _, rail_dir in pairs(rail_directions) do
      for _, conn_dir in pairs(connection_directions) do
        local neighbor = entity.get_connected_rail{
          rail_direction = rail_dir,
          rail_connection_direction = conn_dir
        }
        if neighbor and neighbor.valid then
          table.insert(connected, neighbor)
        end
      end
    end
  end

  return connected
end

local function try_connect_poles(pole1, pole2)
  if pole1 and pole1.valid and pole2 and pole2.valid then
    -- Force connection regardless of range
    pole1.get_wire_connector(defines.wire_connector_id.pole_copper, true).connect_to(pole2.get_wire_connector(defines.wire_connector_id.pole_copper, true), false, defines.wire_origin.script)
    pole1.get_wire_connector(defines.wire_connector_id.circuit_red, true).connect_to(pole2.get_wire_connector(defines.wire_connector_id.circuit_red, true), false, defines.wire_origin.script)
    pole1.get_wire_connector(defines.wire_connector_id.circuit_green, true).connect_to(pole2.get_wire_connector(defines.wire_connector_id.circuit_green, true), false, defines.wire_origin.script)
  end
end

local function place_hidden_pole(rail)
   local surface = rail.surface
   local position = rail.position
   local pole_name = "hidden-rail-pole"
 
   local existing_poles = surface.find_entities_filtered{position = position, name = pole_name}
   if #existing_poles == 0 then
      local pole = surface.create_entity{name = pole_name, position = position, force = rail.force}
      pole.get_wire_connector(defines.wire_connector_id.pole_copper, true).disconnect_all()
      for _, neighbor_rail in pairs(get_connected_rails(rail)) do
        local hidden_poles = neighbor_rail.surface.find_entities_filtered{
          position = neighbor_rail.position,
          type = "electric-pole"
        }
        for _, neighbor_pole in pairs(hidden_poles) do
          try_connect_poles(pole, neighbor_pole)
        end
      end
   end
end

local function place_invisible_hidden_pole(rail)
   local surface = rail.surface
   local position = rail.position
   local pole_name = "hidden-rail-pole-invisible"
 
   local existing_poles = surface.find_entities_filtered{position = position, name = pole_name}
   if #existing_poles == 0 then
      local pole = surface.create_entity{name = pole_name, position = position, force = rail.force}
      pole.get_wire_connector(defines.wire_connector_id.pole_copper, true).disconnect_all()
      for _, neighbor_rail in pairs(get_connected_rails(rail)) do
        local hidden_poles = neighbor_rail.surface.find_entities_filtered{
          position = neighbor_rail.position,
          type = "electric-pole"
        }
        for _, neighbor_pole in pairs(hidden_poles) do
          try_connect_poles(pole, neighbor_pole)
        end
      end
   end
end

local function remove_hidden_pole(rail)
  local surface = rail.surface
  local position = rail.position
  local pole_name = "hidden-rail-pole"
 
  -- Find and remove the hidden pole
  local poles = surface.find_entities_filtered{position = position, name = pole_name}
  for _, pole in pairs(poles) do
    pole.destroy()
  end
end

local function remove_invisible_hidden_pole(rail)
  local surface = rail.surface
  local position = rail.position
  local pole_name = "hidden-rail-pole-invisible"
 
   -- Find and remove the hidden pole
  local poles = surface.find_entities_filtered{position = position, name = pole_name}
  for _, pole in pairs(poles) do
    pole.destroy()
  end
end

-- Register event for when a rail is built
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, function(event)
   local entity = event.created_entity or event.entity
   if israil(entity) then
      place_hidden_pole(entity)
   elseif iselevatedrail(entity) then
      place_invisible_hidden_pole(entity)
   end
end)

-- Register event for when a rail is removed
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(event)
   local entity = event.entity
   if israil(entity) then
      remove_hidden_pole(entity)
   elseif iselevatedrail(entity) then
      remove_invisible_hidden_pole(entity)
   end
end)




--[[





-- upgrade fix
local rail_upgrades = {
  ["rail-ramp"] = "rail-ramp-minimal",
  ["elevated-straight-rail"] = "elevated-straight-rail-minimal",
  ["elevated-curved-rail-a"] = "elevated-curved-rail-a-minimal",
  ["elevated-curved-rail-b"] = "elevated-curved-rail-b-minimal",
  ["elevated-half-diagonal-rail"] = "elevated-half-diagonal-rail-minimal"
}

local minimal_rails = {
  ["rail-ramp-minimal"] = true,
  ["elevated-straight-rail-minimal"] = true,
  ["elevated-curved-rail-a-minimal"] = true,
  ["elevated-curved-rail-b-minimal"] = true,
  ["elevated-half-diagonal-rail-minimal"] = true
}

local pending = {}

local function key(entity)
  if not entity.valid or not entity.unit_number then
    return nil
  end

  return entity.surface.index .. ":" .. entity.unit_number
end

local function remember(entity)
  if not entity.valid then
    return
  end

  local target = rail_upgrades[entity.name]

  if not target then
    return
  end

  if not prototypes.entity[target] then
    return
  end

  local entity_key = key(entity)

  if not entity_key then
    return
  end

  pending[entity_key] = {
    entity = entity,
    target = target
  }
end

local function forget(entity)
  if not entity or not entity.valid then
    return
  end

  local entity_key = key(entity)

  if entity_key then
    pending[entity_key] = nil
  end
end

local function force_upgrade(entity, target)
  if not entity.valid then
    return
  end

  if entity.name ~= "rail-ramp"
      and entity.name ~= "elevated-straight-rail"
      and entity.name ~= "elevated-curved-rail-a"
      and entity.name ~= "elevated-curved-rail-b"
      and entity.name ~= "elevated-half-diagonal-rail" then
    return
  end

  -- IMPORTANT:
  -- Do not create another robot order here.
  --
  -- We only use apply_upgrade() if Factorio still has the original
  -- upgrade order attached to this entity.
  if not entity.to_be_upgraded() then
    return
  end

  entity.apply_upgrade(target)
end

script.on_event(defines.events.on_marked_for_upgrade, function(event)
  remember(event.entity)
end)

script.on_event(defines.events.on_cancelled_upgrade, function(event)
  forget(event.entity)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
  local entity = event.entity

  if not entity or not entity.valid then
    return
  end

  if not minimal_rails[entity.name] then
    return
  end

  -- The construction robot successfully built one of our
  -- minimal rails. The normal bot upgrade therefore succeeded.
  --
  -- Nothing else needs to be done here.
  --
  -- We only clean up any pending entry for an old rail at
  -- this exact position.

  local surface = entity.surface

  local nearby_entities = surface.find_entities_filtered({
    position = entity.position,
    radius = 0.1
  })

  for _, nearby_entity in pairs(nearby_entities) do
    if nearby_entity.valid and rail_upgrades[nearby_entity.name] then
      forget(nearby_entity)
    end
  end
end)

script.on_event(defines.events.on_robot_mined_entity, function(event)
  local entity = event.entity

  if not entity or not entity.valid then
    return
  end

  if not rail_upgrades[entity.name] then
    return
  end

  local entity_key = key(entity)

  if not entity_key then
    return
  end

  if pending[entity_key] then
    pending[entity_key] = nil
  end
end)




]]





--[[

local function force_upgrades_enabled()
  return settings.global["minimalist-rails-force-upgrades"]
    and settings.global["minimalist-rails-force-upgrades"].value
end



local rail_upgrades = {
  ["rail-ramp"] = "rail-ramp-minimal",
  ["elevated-straight-rail"] = "elevated-straight-rail-minimal",
  ["elevated-curved-rail-a"] = "elevated-curved-rail-a-minimal",
  ["elevated-curved-rail-b"] = "elevated-curved-rail-b-minimal",
  ["elevated-half-diagonal-rail"] = "elevated-half-diagonal-rail-minimal"
}

local pending_rail_upgrades = {}

script.on_init(function()
  pending_rail_upgrades = {}
end)

script.on_configuration_changed(function()
  pending_rail_upgrades = pending_rail_upgrades or {}
end)

local function remember_rail_upgrade(entity)
  if not entity.valid then return end
  local target_name = rail_upgrades[entity.name]

  if target_name and prototypes.entity[target_name] and entity.to_be_upgraded() then
    local key = entity.surface.index .. ":" .. math.floor(entity.position.x * 100) .. ":" .. math.floor(entity.position.y * 100)
    pending_rail_upgrades[key] = {
      surface_index = entity.surface.index,
      position = {
        x = entity.position.x,
        y = entity.position.y
      },
      direction = entity.direction,
      force = entity.force,
      source_name = entity.name,
      target_name = target_name
    }
  end
end

script.on_event(defines.events.on_marked_for_upgrade, function(event)
  if not next(pending_rail_upgrades) then return end
  remember_rail_upgrade(event.entity)
end)


local function force_rail_upgrade(data)
  local surface = game.surfaces[data.surface_index]
  if not surface or not surface.valid then return true end
  local entities = surface.find_entities_filtered({
    position = data.position,
    radius = 1
  })

  local rail = nil
  for _, entity in pairs(entities) do
    if entity.valid and entity.name == data.source_name then
      rail = entity
      break
    end
  end
  if not rail then return true end

  -- First try Factorio's normal in-place upgrade.
  if rail.to_be_upgraded() then
    local upgraded = rail.apply_upgrade(data.target_name)
    if upgraded then return true end
  end

  if not rail.can_be_destroyed() then return false end

  local surface_position = {
    x = data.position.x,
    y = data.position.y
  }
  local force = data.force
  -- Destroy the old rail.
  if rail.name and rail.name:find("rail", 1, true) then
    rail.destroy({raise_destroy = true})
  end

  -- Create the minimal rail in exactly the same position and direction.
  local new_rail = surface.create_entity({
    name = data.target_name,
    position = surface_position,
    direction = data.direction,
    force = force
  })

  if not new_rail then
    game.print("not new_rail")
    return false
  end

  return true
end

script.on_event(defines.events.on_robot_built_entity, function(event)
  if not next(pending_rail_upgrades) then return end
  local stack = event.stack
  for key, data in pairs(pending_rail_upgrades) do
    local surface = game.surfaces[data.surface_index]

    if not surface or not surface.valid then
      --pending_rail_upgrades[key] = nil
    else
      local entities = surface.find_entities_filtered({
        position = data.position,
        radius = 1
      })

      local rail = nil
      for _, entity in pairs(entities) do
        if entity.valid and entity.name == data.source_name then
          rail = entity
          break
        end
      end

      if not rail then
      elseif not rail.is_registered_for_upgrade() then
        if force_rail_upgrade(data) then
          game.print("force_rail_upgrade")
          pending_rail_upgrades[key] = nil
        end
      end
    end
  end
end)
 ]]


--[[
local rail_upgrades = {
  ["rail-ramp"] = "rail-ramp-minimal",
  ["elevated-straight-rail"] = "elevated-straight-rail-minimal",
  ["elevated-curved-rail-a"] = "elevated-curved-rail-a-minimal",
  ["elevated-curved-rail-b"] = "elevated-curved-rail-b-minimal",
  ["elevated-half-diagonal-rail"] = "elevated-half-diagonal-rail-minimal"
}

local function force_upgrades_enabled()
  return settings.global["minimalist-rails-force-upgrades"]
    and settings.global["minimalist-rails-force-upgrades"].value
end


local pending_rail_upgrades = {}

script.on_init(function()
  pending_rail_upgrades = {}
end)

script.on_configuration_changed(function()
  pending_rail_upgrades = pending_rail_upgrades or {}
end)

local function remember_rail_upgrade(entity)
  if not entity.valid then return end

  local target_name = rail_upgrades[entity.name]

  if target_name and prototypes.entity[target_name] and entity.to_be_upgraded() then
    local key =
      entity.surface.index .. ":" ..
      math.floor(entity.position.x * 100) .. ":" ..
      math.floor(entity.position.y * 100)

    pending_rail_upgrades[key] = {
      surface_index = entity.surface.index,

      position = {
        x = entity.position.x,
        y = entity.position.y
      },

      direction = entity.direction,
      force = entity.force,
      source_name = entity.name,
      target_name = target_name
    }
  end
end

script.on_event(defines.events.on_marked_for_upgrade, function(event)
  if not force_upgrades_enabled() then return end
  remember_rail_upgrade(event.entity)
end)


local function find_rail(data)
  local surface = game.surfaces[data.surface_index]

  if not surface or not surface.valid then
    return nil
  end

  -- Keep this tight. We already know the exact position of
  -- the entity that was marked for upgrade.
  local entities = surface.find_entities_filtered({
    position = data.position,
    radius = 0.1
  })

  for _, entity in pairs(entities) do
    if entity.valid and entity.name == data.source_name then
      return entity
    end
  end

  return nil
end


local function force_rail_upgrade(data)
  local surface = game.surfaces[data.surface_index]

  if not surface or not surface.valid then
    return true
  end

  local rail = find_rail(data)

  if not rail then
    return true
  end

  -- First try Factorio's normal in-place upgrade.
  if rail.to_be_upgraded() then
    local upgraded = rail.apply_upgrade(data.target_name)

    if upgraded then
      return true
    end
  end

  -- IMPORTANT:
  -- Never destroy a rail that has a train on it.
  --
  -- Destroying the rail can cause the train to disappear.
  --
  -- In this situation we simply leave the original rail alone.
  if rail.train then
    return false
  end

  if not rail.can_be_destroyed() then
    return false
  end

  local surface_position = {
    x = rail.position.x,
    y = rail.position.y
  }

  local direction = rail.direction
  local force = rail.force

  -- Destroy ONLY this rail.
  rail.destroy({
    raise_destroy = true
  })

  -- Create ONLY this rail.
  local new_rail = surface.create_entity({
    name = data.target_name,
    position = surface_position,
    direction = direction,
    force = force
  })

  if not new_rail then
    game.print("not new_rail")
    return false
  end

  return true
end


-- Find the pending rail that is closest to the robot that just
-- performed a build operation.
--
-- This is the important part that prevents all connected rails
-- from being processed.
local function find_pending_upgrade_for_robot(robot)
  if not robot or not robot.valid then
    return nil, nil
  end

  local best_key = nil
  local best_data = nil
  local best_distance_squared = math.huge

  for key, data in pairs(pending_rail_upgrades) do
    if data.surface_index == robot.surface.index then

      local rail = find_rail(data)

      if rail then
        local dx = rail.position.x - robot.position.x
        local dy = rail.position.y - robot.position.y

        local distance_squared = dx * dx + dy * dy

        if distance_squared < best_distance_squared then
          best_distance_squared = distance_squared
          best_key = key
          best_data = data
        end
      end
    end
  end

  return best_key, best_data
end


script.on_event(defines.events.on_robot_built_entity, function(event)
  if not force_upgrades_enabled() then return end
  if not next(pending_rail_upgrades) then return end

  -- Use the actual robot that triggered this event.
  local robot = event.robot

  if not robot or not robot.valid then
    return
  end

  -- IMPORTANT:
  -- Do NOT loop over every pending rail.
  --
  -- Only find the one pending rail that this robot is actually
  -- working on.
  local key, data = find_pending_upgrade_for_robot(robot)

  if not key or not data then
    return
  end

  local surface = game.surfaces[data.surface_index]

  if not surface or not surface.valid then
    pending_rail_upgrades[key] = nil
    return
  end

  local rail = find_rail(data)

  if not rail then
    -- The robot successfully replaced the rail normally.
    pending_rail_upgrades[key] = nil
    return
  end

  -- The old rail is still present.
  --
  -- The robot has reached the relevant area, but Factorio did not
  -- complete the upgrade.
  if not rail.is_registered_for_upgrade() then
    if force_rail_upgrade(data) then
      game.print("force_rail_upgrade")
      pending_rail_upgrades[key] = nil
    end
  end
end)
]]





















--[[



local function force_upgrades_enabled()
  return settings.global["minimalist-rails-force-upgrades"].value
end



local rail_upgrades = {
  ["rail-ramp"] = "rail-ramp-minimal",
  ["elevated-straight-rail"] = "elevated-straight-rail-minimal",
  ["elevated-curved-rail-a"] = "elevated-curved-rail-a-minimal",
  ["elevated-curved-rail-b"] = "elevated-curved-rail-b-minimal",
  ["elevated-half-diagonal-rail"] = "elevated-half-diagonal-rail-minimal"
}

local pending_rail_upgrades = {}

local function get_pending_key(entity)
  return entity.surface.index .. ":" ..
         math.floor(entity.position.x * 100) .. ":" ..
         math.floor(entity.position.y * 100)
end

local function remember_rail_upgrade(entity)
  if not entity.valid then
    return
  end

  local target_name = rail_upgrades[entity.name]

  if not target_name then
    return
  end

  if not prototypes.entity[target_name] then
    return
  end

  if not entity.to_be_upgraded() then
    return
  end

  local key = get_pending_key(entity)

  pending_rail_upgrades[key] = {
    surface_index = entity.surface.index,
    position = {
      x = entity.position.x,
      y = entity.position.y
    },
    direction = entity.direction,
    force = entity.force,
    source_name = entity.name,
    target_name = target_name
  }
end

local function force_rail_upgrade(data)
  local surface = game.surfaces[data.surface_index]
  if not surface or not surface.valid then return true end
  local entities = surface.find_entities_filtered({
    position = data.position,
    radius = 1
  })
  game.print("test1")

  local rail = nil
  for _, entity in pairs(entities) do
    if entity.valid and entity.name == data.source_name then
      rail = entity
      break
    end
  end
  if not rail then return true end

  game.print("test2")
  -- First try Factorio's normal in-place upgrade.
  if rail.to_be_upgraded() then
    local upgraded = rail.apply_upgrade(data.target_name)
    if upgraded then return true end
  end

  if not rail.can_be_destroyed() then return false end

  game.print("test3")
  local surface_position = {
    x = data.position.x,
    y = data.position.y
  }
  local force = data.force
  -- Destroy the old rail.
  if rail.name and rail.name:find("rail", 1, true) then
    rail.destroy({raise_destroy = true})
  end
  game.print("test4")

  -- Create the minimal rail in exactly the same position and direction.
  local new_rail = surface.create_entity({
    name = data.target_name,
    position = surface_position,
    direction = data.direction,
    force = force
  })
  game.print("test5")

  if not new_rail then
    game.print("not new_rail")
    return false
  end
  game.print("test6")

  return true
end

script.on_init(function()
  pending_rail_upgrades = {}
end)

script.on_configuration_changed(function()
  pending_rail_upgrades = pending_rail_upgrades or {}
end)

--script.on_event(defines.events.on_marked_for_upgrade, function(event)
--  if not force_upgrades_enabled() then return end
--  remember_rail_upgrade(event.entity)
--end)

script.on_event(defines.events.on_marked_for_upgrade, function()

  game.print("defines.events.on_marked_for_upgrade"))
  game.print("" .. tostring(settings.global["minimalist-rails-force-upgrades"].value))
  if not force_upgrades_enabled() then return end
  remember_rail_upgrade(event.entity)
  game.print("on_marked_for_upgrade1")
  --if not next(pending_rail_upgrades) then
  --  return
  --end
  game.print("on_marked_for_upgrade2")

  for key, data in pairs(pending_rail_upgrades) do
    local surface = game.surfaces[data.surface_index]

    if not surface or not surface.valid then
      pending_rail_upgrades[key] = nil
    else
  game.print("on_marked_for_upgrade3")
      local entities = surface.find_entities_filtered({
        position = data.position,
        radius = 1,
      })

      local rail = nil

      for _, entity in pairs(entities) do
        if entity.valid and entity.name == data.source_name then
          rail = entity
          break
        end
      end

      if not rail then
  game.print("on_marked_for_upgrade4")
        pending_rail_upgrades[key] = nil
      --elseif not rail.to_be_upgraded() then
        -- The upgrade order has disappeared.
      --  pending_rail_upgrades[key] = nil
      else --if not rail.is_registered_for_upgrade() then
        -- A construction robot has been dispatched.
        if force_rail_upgrade(data) then
  game.print("on_marked_for_upgrade5")
          pending_rail_upgrades[key] = nil
        end
      end
    end
  end
end)

]]