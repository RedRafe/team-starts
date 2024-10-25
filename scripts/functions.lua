local Table = require 'utils.table'
local shared = {
  planets = require 'shared.planets',
  connections = require 'shared.connections',
}

local contains = Table.contains

local Functions = {}

-- == LOCAL UTILS =============================================================

Functions.spawn = function()
  return { x = 0, y = 0 }
end
local _spawn = Functions.spawn

---@param position MapPosition
---@param surface LuaSurface
Functions.gps_to_string = function(position, surface)
  return string.format('[gps=%.2f,%.2f,%s]', position.x, position.y, surface.name)
end
local _gps = Functions.gps_to_string

---@param player LuaPlayer
Functions.player_with_color = function(player)
  return string.format(
    '[color=%.2f,%.2f,%.2f]%s[/color]',
    player.color.r * 0.6 + 0.4,
    player.color.g * 0.6 + 0.4,
    player.color.b * 0.6 + 0.4,
    player.name
  )
end
local _player_with_color = Functions.player_with_color

---@param force LuaForce
Functions.get_player_list = function(force)
  local list = {}
  if not force or not force.valid then
    return list
  end
  for _, player in pairs(force.players) do
    list[#list + 1] = _player_with_color(player)
  end
  return list
end

-- ============================================================================

Functions.universe_size = function()
  return #shared.planets.nauvis
end


---@param force LuaForce
Functions.get_team_name = function(force)
  local name = '[invalid force name]'
  if not force or not force.name then
    return name
  end
  if force.name == 'player' then
    name = 'Player'
    return name
  end

  if not game.forces[force.name] then
    return name
  end
  name = storage.team_names[force.name]
  if #name > 50 then
    return name:sub(1, 47)..'...'
  else
    return name
  end
end

--- Returns true if force can land on surface, false otherwise
---@param surface LuaSurface
---@param force LuaForce
Functions.surface_force_restrictions = function(surface, force)
  local planet_name = surface.planet and surface.planet.name
  if not planet_name then
    return true
  end
  local allowed_force_name = storage.map_planet_to_force[planet_name]
  if allowed_force_name ~= nil then
    return allowed_force_name == force.name
  end
  return true
end

---@param surface LuaSurface
Functions.remove_adjacent_restrictions = function(surface, force)
  local removed_forces = {}
  local planet = surface.planet and surface.planet.name
  local connections = prototypes.space_connection
  local list = shared.planets
  for _, connection in pairs(connections) do
    local other_planet = false
    if connection.from.name == planet then
      other_planet = connection.to.name
    elseif connection.to.name == planet then
      other_planet = connection.from.name
    end
    if other_planet and storage.map_expansion_to_force[other_planet] then
      local other_force = storage.map_expansion_to_force[other_planet]
      storage.map_expansion_to_force[other_planet] = nil
      storage.map_planet_to_force[other_planet] = nil
      removed_forces[#removed_forces + 1] = { other_planet, other_force }
    end
  end
  for _, v in pairs(removed_forces) do
    game.print({
      'info.force_gained_access',
      Functions.get_team_name(force),
      v[1],
      Functions.get_team_name(game.forces[v[2]]),
    })
    force.unlock_space_location(v[1])
  end
end

---@param entity LuaEntity (player.character)
---@param position? MapPosition
---@param surface LuaSurface
---@param raise_teleport? boolean
---@param snap_to_grid? boolean
Functions.teleport = function(entity, position, surface, raise_teleport, snap_to_grid)
  position = position or _spawn()
  local pos = surface.find_non_colliding_position(entity.name, position, 32, 1, snap_to_grid)
  if pos then
    entity.teleport(pos, surface, raise_teleport, snap_to_grid)
  else
    game.print({'info.teleport_error', entity.name, _gps(position, surface)})
  end
end

---@param force LuaForce
Functions.get_force_planets = function(force)
  local planets = {
    home = storage.map_force_to_planet[force.name]
  }
  for planet_name, force_name in pairs(storage.map_planet_to_force) do
    if force_name == force.name then
      if planet_name ~= planets.home then
        planets.expansion = planet_name
      end
    end
  end
  return planets
end

---@param planet_name string
Functions.get_or_create_planet_surface = function(planet_name)
  local planet = game.planets[planet_name]
  if not (planet and planet.valid) then
    return
  end
  local surface = planet.surface
  if not (surface and surface.valid) then
    surface = planet.create_surface()
  end
  if surface and surface.valid then
    surface.request_to_generate_chunks(_spawn(), 1)
    surface.force_generate_chunk_requests()
  end
  return surface
end

---@param player LuaPlayer
---@param force LuaForce
Functions.switch_force = function(player, force)
  if not (player and player.valid) then
    return
  end
  if not (force and force.valid) then
    return
  end
  local planets = Functions.get_force_planets(force)
  if force.name == 'player' then
    planets = { home = 'nauvis' }
  end
  if not (planets and planets.home) then
    return
  end
  local surface = Functions.get_or_create_planet_surface(planets.home)
  if not (surface and surface.valid) then
    return
  end

  local old_force = Functions.get_team_name(player.force)
  local new_force = Functions.get_team_name(force)
  player.force = force
  game.print(_player_with_color(player) .. ' has switched from ' .. old_force .. ' to ' .. new_force)
  Functions.teleport(player.character, nil, surface, true)
end

---@param source LuaForce
---@param destination LuaForce
Functions.merge_technologies = function(source, destination)
  if not (source and source.valid) then
    return
  end
  if not (destination and destination.valid) then
    return
  end
  for name, tech in pairs(destination.technologies) do
    local src_tech = source.technologies[name]
    tech.enabled = tech.enabled or src_tech.enabled
    if not tech.researched then
      if src_tech.researched then
        tech.researched = true
      end
      if tech.saved_progress < src_tech.saved_progress then
        tech.saved_progress = src_tech.saved_progress
      end
    end
    if tech.level and tech.level < src_tech.level then
      tech.level = src_tech.level
    end
  end
end

---@param source LuaForce
---@param destination LuaForce
Functions.merge_locations = function(source, destination)
  if not (source and source.valid) then
    return
  end
  if not (destination and destination.valid) then
    return
  end
  for name, _ in pairs(game.planets) do
    if source.is_space_location_unlocked(name) then
      destination.unlock_space_location(name)
      destination.print({'info.planet_unlocked', name})
    end
  end
end

---@param source LuaForce
---@param destination LuaForce
Functions.merge_forces = function(source, destination)
  if not (source and source.valid) then
    return
  end
  if not (destination and destination.valid) then
    return
  end
  if source.name == 'player' then
    return
  end
  game.merge_forces(source, destination)
end

---@param force LuaForce|string
Functions.remove_force = function(force)
  local name = force.name or force
  storage.map_force_to_planet[name] = nil
  for k, v in pairs(storage.map_planet_to_force) do
    if v == name then
      storage.map_planet_to_force[k] = nil
    end
  end
  for k, v in pairs(storage.map_expansion_to_force) do
    if v == name then
      storage.map_planet_to_force[k] = nil
    end
  end
  storage.team_names[name] = nil
  storage.first_landing[name] = nil
  storage.map_force_to_expansion[name] = nil
end

---@param player LuaPlayer
Functions.leave_corpse = function(player)
  if not player.character then
    return
  end

  local inventories = {
    player.get_inventory(defines.inventory.character_main),
    player.get_inventory(defines.inventory.character_guns),
    player.get_inventory(defines.inventory.character_ammo),
    player.get_inventory(defines.inventory.character_armor),
    player.get_inventory(defines.inventory.character_vehicle),
    player.get_inventory(defines.inventory.character_trash),
  }

  local corpse = false
  for _, i in pairs(inventories) do
    for index = 1, #i, 1 do
      if not i[index].valid then
        break
      end
      corpse = true
      break
    end
    if corpse then
      player.character.die()
      break
    end
  end

  if player.character then
    player.character.destroy()
  end
  player.character = nil
  --player.set_controller({ type = defines.controllers.god })
  --player.create_character()
end

-- ============================================================================

return Functions