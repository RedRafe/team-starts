local function slice(tbl, index)
  local res = {}
  for i = 1, math.min(index, #tbl) do
    res[i] = tbl[i]
  end
  return res
end

local size_to_index = { small = 3, medium = 6, large = 9 }

local planets = {
  nauvis = {
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
  },
  gleba = {
    'gloria',
    'gloreth',
    'glevia',
    'glebrun',
    'glebonis',
    'glenara',
    'glebyra',
    'glethos',
    'gleminus',
    'gleboris',
  },
  vulcanus = {
    'volcanis',
    'vulthera',
    'vulkaris',
    'vulkoria',
    'valcanus',
    'vulsaris',
    'vulcania',
    'vulvoria',
    'vultharis',
    'velcanus',
  },
  fulgora = {
    'fulgoris',
    'fulgorin',
    'fulvaris',
    'fulgorae',
    'fulgeris',
    'fulgoraith',
    'fulgorid',
    'fulgaris',
    'fulgornis',
    'fulvoria',
  },
  aquilo = {
    'aquithor',
    'aquilus',
    'aquilith',
    'aquillia',
    'aquira',
    'aquolani',
    'aquion',
    'aquivus',
    'aquanora',
    'aquirae',
  },
}

local selected = settings.startup['ts_solar_system_size'].value
local system_size = size_to_index[selected]

return {
  nauvis = slice(planets.nauvis, system_size * 3),
  gleba = slice(planets.gleba, system_size),
  vulcanus = slice(planets.vulcanus, system_size),
  fulgora = slice(planets.fulgora, system_size),
  aquilo = slice(planets.aquilo, system_size / 3),
}
