local Event = require 'utils.event'
local Functions = require 'scripts.functions'

local function is_associated_expansion_planet(surface, force)
  local expansion = storage.first_landing[force.name]
  return (expansion ~= nil) and expansion == (surface.planet and surface.planet.name)
end

Event.add(defines.events.on_player_changed_surface, function(event)
  local player = game.get_player(event.player_index)

  -- Teleport back player accessing other team's reserved expansions
  if not Functions.surface_force_restrictions(player.physical_surface, player.force) then
    local old_surface = game.get_surface(event.surface_index)
    if old_surface and old_surface.valid then
      Functions.teleport(player.character, nil, old_surface, true)
    else
      game.print({'info.surface_force_restriction', Functions.player_with_color(player), player.physical_surface.planet.name })
    end
  end

  -- Enable that force to unlock other SA planets as well
  if is_associated_expansion_planet(player.physical_surface, player.force) then
    storage.first_landing[player.force.name] = nil
    Functions.merge_forces(player.force, game.forces.player)
    Functions.remove_adjacent_restrictions(player.physical_surface, player.force)
  end
end)