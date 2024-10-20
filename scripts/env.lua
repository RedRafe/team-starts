_DEBUG = false
_CHEATS = false
_DUMP_ENV = false
_STAGE = {
  settings = 1,
  data = 2,
  migration = 3,
  control = 4,
  init = 5,
  load = 6,
  config_change = 7,
  runtime = 8
}
_LIFECYCLE = _STAGE.control

local Event = require 'utils.event'

Event.on_init(function()
  storage.planets = {}
  storage.map_planet_to_force = {}
  storage.map_force_to_planet = {}
  storage.team_names = {}
end)