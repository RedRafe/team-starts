local TMGui = require 'scripts.team_manager_gui'
local Functions = require 'scripts.functions'
local player_with_color = Functions.player_with_color

commands.add_command(
  'chain',
  '/chain <player_name>, restricts player from freely change teams [ADMIN only]',
  function(event)
    local player = game.get_player(event.player_index)
    if not (player and player.valid) or not player.admin then
      return
    end
    if not event.parameter then
      player.print('/chain <player_name> missing 1st argument: <player_name> :: string')
      return
    end
    local target = game.get_player(event.parameter)
    if target and target.valid and not storage.restrict_player_from_changing_team[target.index] then
      game.print({'info.info_chain', player_with_color(player), player_with_color(target)})
      storage.restrict_player_from_changing_team[target.index] = true
      TMGui.toggle_main_button(target)
      TMGui.toggle_main_button(target)
    end
  end
)

commands.add_command(
  'unchain',
  '/unchain <player_name>, allows player to freely change teams [ADMIN only]',
  function(event)
    local player = game.get_player(event.player_index)
    if not (player and player.valid) or not player.admin then
      return
    end
    if not event.parameter then
      player.print('/unchain <player_name> missing 1st argument: <player_name> :: string')
      return
    end
    local target = game.get_player(event.parameter)
    if target and target.valid and storage.restrict_player_from_changing_team[target.index] then
      game.print({'info.info_unchain', player_with_color(player), player_with_color(target)})
      storage.restrict_player_from_changing_team[target.index] = nil
      TMGui.toggle_main_button(target)
      TMGui.toggle_main_button(target)
    end
  end
)


-- /rename 6 The best team ever
commands.add_command(
  'rename',
  '/rename <id> <name>, change the name of a team [ADMIN only]',
  function(event)
    local player = game.get_player(event.player_index)
    if not (player and player.valid) or not player.admin then
      return
    end
    if not event.parameter then
      player.print('/rename  <id> <name>, wrong arguments <id> :: number or <name> :: string')
      return
    end
    local text = event.parameter
    local id = string.match(text, '^%d+') -- first number
    local name = string.match(text, ' (.*)') -- everything after space
    if not id or not name then
      return
    end
    id, name = tonumber(id), tostring(name)
    if not id or not type(id) == 'number' or not name or not type(name) == 'string' or name == '' then
      return
    end
    local force = game.forces['player_'..id]
    if not force or not force.valid or force.name == 'player' then
      return
    end
    local old = storage.team_names[force.name]
    storage.team_names[force.name] = name
    game.print({'info.rename_team', old, name})
  end
)