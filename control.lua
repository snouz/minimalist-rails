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
