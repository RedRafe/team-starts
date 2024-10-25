local Event = require 'utils.event'
local Table = require 'utils.table'
local Planets = require 'shared.planets'
local Functions = require 'scripts.functions'

Event.on_init(function()
  local map_force_to_planet = {}
  local assigned_planets = {}

  -- Create all new forces
  for index, name in pairs(Planets.nauvis) do
    local force = game.create_force('player_'..index)
    map_force_to_planet[force.name] = name
    assigned_planets[name] = force.name
    storage.map_force_to_planet[force.name] = name
    storage.map_planet_to_force[name] = force.name
    storage.team_names[force.name] = string.format('Team %02d', index)
  end

  -- Create surface-force links
  for _, connection in pairs(prototypes.space_connection) do
    local home_planet = connection.from.name
    if assigned_planets[home_planet] then
      local force_name = assigned_planets[home_planet] 
      local target_planet = connection.to.name
      storage.map_planet_to_force[target_planet] = force_name
    end
  end

  for force_name, locationID in pairs(storage.map_force_to_planet) do
    local force = game.forces[force_name]
    force.unlock_space_location(locationID)
    force.lock_space_location('nauvis')
    force.set_surface_hidden('nauvis', true)

    local expansion = Functions.get_force_planets(force).expansion
    storage.first_landing[force_name] = expansion
    storage.map_expansion_to_force[expansion] = force_name
    storage.map_force_to_expansion[force_name] = expansion
  end
end)

Event.add(defines.events.on_forces_merging, function(event)
  local src, dst = event.source, event.destination
  local _name = Functions.get_team_name
  game.print({'info.merging_forces', _name(src), _name(dst)})
  Functions.merge_locations(src, dst)
  Functions.remove_force(src)
  Functions.merge_technologies(src, dst)
end)

local TECH_TO_PLANET = {
  ['planet-discovery-aquilo'] = 'aquilo',
  ['planet-discovery-fulgora'] = 'fulgora',
  ['planet-discovery-gleba'] = 'gleba',
  ['planet-discovery-vulcanus'] = 'vulcanus',
}
Event.add(defines.events.on_research_finished, function(event)
  local tech = event.research
  local force = tech.force
  local target_base = TECH_TO_PLANET[tech.name]
  if not target_base then
    return
  end
  -- Unlock only reserved expansion
  local force_planets = Functions.get_force_planets(force)
  local expansion = force_planets and force_planets.expansion
  if expansion then
    if Table.contains(Planets[target_base] or {}, expansion) then
      force.unlock_space_location(expansion)
      force.lock_space_location(target_base)
      force.print({'info.planet_unlocked', expansion})
    end
  end
  -- Unlock all Aquilo(s) at once
  if target_base == 'aquilo' then
    for _, alt_aquilo in pairs(Planets.aquilo) do
      force.unlock_space_location(alt_aquilo)
      force.print({'info.planet_unlocked', alt_aquilo})
    end
  end
end)

local SIZE_TO_INDEX = { small = 3, medium = 6, large = 9 }
local function reset_space_locations(event)
  local f = event.force
  if not Functions.starts_with(f.name, 'player_') then
    return
  end
  local i = string.gsub(f.name, 'player_', '')
  i = tonumber(i)
  if not i then
    return
  end

  local nauvis = Planets.nauvis
  local size = settings.startup['ts_solar_system_size'].value

  if f and f.valid then
    f.unlock_space_location(nauvis[i])
    f.lock_space_location('nauvis')
    f.set_surface_hidden('nauvis', true)
  end

  for _, base in pairs({'gleba', 'fulgora', 'vulcanus'}) do
    local custom = Planets[base]
    if f.technologies['planet-discovery-'..base].researched then
      f.lock_space_location(base)
      f.unlock_space_location(custom[math.ceil(i/3)])
    end
    if game.planets[base] and game.planets[base].surface then
      f.set_surface_hidden(game.planets[base].surface, true)
    end
  end
end
Event.add(defines.events.on_force_reset, reset_space_locations)
Event.add(defines.events.on_technology_effects_reset, reset_space_locations)
Event.on_configuration_changed(function()
  for _, f in pairs(game.forces) do
    reset_space_locations({ force = f })
  end
end)