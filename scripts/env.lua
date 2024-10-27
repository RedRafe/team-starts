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
  storage.map_planet_to_force = {}
  storage.map_force_to_planet = {}
  storage.map_expansion_to_force = {}
  storage.map_force_to_expansion = {}
  storage.team_names = {}
  storage.first_landing = {}
  storage.cooldown = {}
  storage.DEBOUNCE_TICKS = 60 * 60 * 15
  storage.restrict_player_from_changing_team = {}
  storage.is_team_locked = {}
  storage.platform_inventories = {}
end)