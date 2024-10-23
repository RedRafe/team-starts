local size = settings.startup['ts_solar_system_size'].value
local size_to_index = { small = 3, medium = 6, large = 9 }
local nauvis = {
    'nuvira',
    'novaris',
    'nandira',
    'navoria',
    'nautara',
    'nodaris',
    'nerudis',
    'nivaris',
    'nauvanis',
    'nalvian',
    'nolara',
    'nymaris',
    'naedris',
    'neravus',
    'nulvion',
    'norvios',
    'nauris',
    'navera',
    'nusutis',
    'nyloria',
    'naxion',
    'nazara',
    'nutara',
    'nurelis',
    'nythria',
    'naviris',
    'naurion',
    'navithos',
    'nauvenis',
    'nulvire',
  }
  for i = 1, size_to_index[size] do
    local f = game.forces['player_'..i]
    if f and f.valid then
      f.unlock_space_location(nauvis[i])
      f.lock_space_location('nauvis')
      f.set_surface_hidden('nauvis', true)
    end
  end