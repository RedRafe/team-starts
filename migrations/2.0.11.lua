local Planets = require 'shared.planets'

for index, name in pairs(Planets.nauvis) do
  local force = game.forces['player_'..index]
  if force and force.valid then
    storage.map_force_to_planet[force.name] = name
  end
end