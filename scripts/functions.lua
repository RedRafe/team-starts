local shared = {
  planets = require 'shared.planets',
  connections = require 'shared.connections',
}

local Functions = {}

-- == LOCAL UTILS =============================================================

Functions.spawn = function()
  return { x = 0, y = 0 }
end
local _spawn = Functions.spawn

Functions.gps_to_string = function(position, surface)
  return string.format('[gps=%.2f,%.2f,%s]', position.x, position.y, surface.name)
end
local _gps = Functions.gps_to_string

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

Functions.get_team_name = function(force)
  if not force or not force.name or not game.forces[force.name] then
    return '[invalid force name]'
  end
  local name = storage.team_names[force.name]
  if #name > 50 then
    return name:sub(1, 47)..'...'
  else
    return name
  end
end

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

Functions.teleport = function(entity, position, surface, raise_teleport, snap_to_grid)
  position = position or _spawn()
  local pos = surface.find_non_colliding_position(entity.name, position, 0, 1, snap_to_grid)
  if pos then
    entity.teleport(pos, surface, raise_teleport, snap_to_grid)
  else
    game.print({'teleport_error', entity.name, _gps(position, surface)})
  end
end

Functions.get_force_planets = function(force)
  local planets = {
    home = storage.map_force_to_planet[force.name]
  }
  for planet_name, force_name in pairs(storage.map_planet_to_force) do
    if force_name == force.name then
      if planet_name ~= planets.home then
        planets.expansion =planet_name
      end
    end
  end
  return planets
end

-- ============================================================================

return Functions