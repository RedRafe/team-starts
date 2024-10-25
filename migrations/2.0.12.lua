local size = settings.startup['ts_solar_system_size'].value
local size_to_index = { small = 3, medium = 6, large = 9 }

log('Before: Is space location unlocked? ' .. (game.forces.player_13.is_space_location_unlocked('naedris') and 'true' or 'false'))

for i = 1, (3 * size_to_index[size]) do
  local f = game.forces['player_'..i]
  if f and f.valid then
    f.reset_technology_effects()
  end
end

log('After: Is space location unlocked? ' .. (game.forces.player_13.is_space_location_unlocked('naedris') and 'true' or 'false'))