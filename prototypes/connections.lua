local connections = require 'shared.connections'
local edge = 'solar-system-edge'
local edge_icon = '__space-age__/graphics/icons/solar-system-edge.png'

local planet = data.raw.planet
local connection = data.raw['space-connection']

local function get_planet_icon(name)
  return planet[name] and planet[name].icon or edge_icon
end

local function exists(name)
  return (name == edge) or (planet[name] ~= nil)
end

for _, obj in pairs(connections) do
  local from, to, base = obj[1], obj[2], obj[3]

  if not exists(from) or not exists(to) then
    goto skip
  end
  
  local connection = table.deepcopy(connection[base])
  connection.name = from..'-'..to
  connection.from = from
  connection.to = to
  connection.icons = {
    {
      icon = '__space-age__/graphics/icons/planet-route.png',
    },
    {
      icon = get_planet_icon(from),
      icon_size = 64,
      scale = 1 / 3,
      shift = { -6, -6 },
    },
    {
      icon = get_planet_icon(to),
      icon_size = 64,
      scale = 1 / 3,
      shift = { 6, 6 }
    },
  }

  data:extend{ connection }
  ::skip::
end