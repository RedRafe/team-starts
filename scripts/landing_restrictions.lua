local Event = require 'utils.event'
local Functions = require 'scripts.functions'

Event.add(defines.events.on_player_changed_surface, function(event)
  local player = game.get_player(event.player_index)

  if not Functions.surface_force_restrictions(player.physical_surface, player.force) then
    local old_surface = game.get_surface(event.surface_index)
    if old_surface and old.surface.valid then
      Functions.teleport(player.character, nil, old_surface, true)
    else
      game.print({'info.surface_force_restriction', Functions.player_with_color(player), player.physical_surface.planet.name })
    end
  end
end)