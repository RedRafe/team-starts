local Event = require 'utils.event'
local Functions = require 'scripts.functions'

local function is_associated_expansion_planet(surface, force)
  local expansion = storage.first_landing[force.name]
  return (expansion ~= nil) and expansion == (surface.planet and surface.planet.name)
end

Event.add(defines.events.on_player_changed_surface, function(event)
  local player = game.get_player(event.player_index)

  -- Enable that force to unlock other SA planets as well
  if is_associated_expansion_planet(player.physical_surface, player.force) then
    storage.first_landing[player.force.name] = nil
    Functions.merge_forces(player.force, game.forces.player)
    Functions.remove_adjacent_restrictions(player.physical_surface, player.force)
  end
end)