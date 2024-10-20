local planets = require 'shared.planets'

for base_name, list in pairs(planets) do
  for index, new_name in pairs(list) do
    local planet = table.deepcopy(data.raw.planet[base_name])
    planet.name = new_name
    planet.order = string.format('%s[%s]', planet.order[1], new_name)
    planet.localised_description = {'space-location-description.'..base_name}

    local offset = 0.02 + (index / (table_size(planets[base_name]) + 1))
    if base_name == 'gleba' then offset = offset + 0.02 end
    if base_name == 'fulgora' then offset = offset + 0.07 end
    if base_name == 'aquilo' then offset = offset + 0 end
    planet.orientation = offset
    planet.label_orientation = offset

    data:extend{ planet }
  end
end

data.raw.planet.vulcanus.orientation = 0
data.raw.planet.nauvis.orientation = 0.02
data.raw.planet.gleba.orientation = 0
data.raw.planet.fulgora.orientation = 0.08
data.raw.planet.aquilo.orientation = 0.04