local Event = require 'utils.event'
local Planets = require 'shared.planets'

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
      --storage.map_force_to_planet[force_name] = target_planet
      storage.map_planet_to_force[target_planet] = force_name
    end
  end
end)