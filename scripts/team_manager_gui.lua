local Event = require 'utils.event'
local Functions = require 'scripts.functions'
local Gui = require 'utils.gui'

local f = string.format
local TEST_1 = '[color=acid]Zyphorix[/color] [color=red]NibbleWorm[/color] [color=green]Glimwiggle[/color] [color=cyan]Borqee[/color] [color=cyan]Zyglot[/color] [color=orange]Crimboxnattle[/color] [color=pink]TwinklePuff[/color] [color=green]Jumboborax[/color] [color=red]Fizzywerp[/color] [color=cyan]MocachinoBeast[/color]'

local main_button_name = Gui.uid_name()
local main_frame_name = Gui.uid_name()
local leave_force_button_name = Gui.uid_name()
local join_force_button_name = Gui.uid_name()

local Public = {}

local function get_player_counts(force)
  return {
    online = #force.connected_players,
    offline = #force.players - #force.connected_players,
    total = #force.players,
  }
end

local function debounce(player)
  if player.admin then
    return false
  end
  local tick = storage.cooldown[player.index]
  if tick and tick > game.tick then
    player.print({'info.cooldown', math.ceil((tick - game.tick) / 3600)})
    return true
  end
  storage.cooldown[player.index] = game.tick + storage.DEBOUNCE_TICKS
  return false
end

function Public.update_top_button(player)
  Gui.add_top_element(player, {
    type = 'sprite-button',
    name = main_button_name,
    sprite = 'ts_121',
    tooltip = {'gui.tm_tooltip'},
  })
end

function Public.toggle_main_button(player)
  local main_frame = player.gui.screen[main_frame_name]
  if main_frame then
    Gui.destroy(main_frame)
  else
    if storage.restrict_player_from_changing_team[player.index] then
      player.print({'info.chained'})
      return
    end
    Public.get_main_frame(player)
  end
end

local function display_team(parent, force)
  if not force or not force.valid then
    return
  end

  local player = game.get_player(parent.player_index)
  local planets = Functions.get_force_planets(force)

  local frame = parent.add { type = 'frame' }
  local flow_1 = frame.add { type = 'flow', direction = 'vertical' }
  Gui.set_style(flow_1, { padding = 0 })
  
  local inside = flow_1.add { type = 'frame', style = 'inside_shallow_frame_with_padding', direction = 'vertical' }
  Gui.set_style(inside, { padding = 0 })

  -- title
  local subheader = inside.add { type = 'frame', style = 'subheader_frame' }
  Gui.set_style(subheader, { horizontally_stretchable = true })
  subheader.add { type = 'label', caption = 'Team '.. force.index-3, style = 'subheader_caption_label', tooltip = {'gui.rename_tooltip'} }
  
  -- contents
  local content = inside.add { type = 'flow', direction = 'vertical' }
  Gui.set_style(content, { padding = 8, vertical_spacing = 8, vertically_stretchable = true })

  do -- description
    local d_frame = content.add { type = 'frame', style = 'deep_frame_in_shallow_frame_for_description', direction = 'vertical' }
    Gui.set_style(d_frame, { width = 180, natural_width = 180 })
    d_frame.add { type = 'label', caption = Functions.get_team_name(force), style = 'info_label', tooltip = storage.team_names[force.name] }
    d_frame.add { type = 'line', style = 'tooltip_horizontal_line' }
    local fr = d_frame.add { type = 'flow', direction = 'vertical' }
      fr.add { type = 'label', caption = 'Home planet: ', style = 'semibold_caption_label' }
      fr.add { type = 'label', caption = {'', f('[planet=%s]\t\t', planets.home), {'space-location-name.'..planets.home} }}
    local fr = d_frame.add { type = 'flow', direction = 'vertical' }
      fr.add { type = 'label', caption = 'Reserved expansion: ', style = 'semibold_caption_label' }
      fr.add { type = 'label', caption = {'', f('[planet=%s]\t\t', planets.expansion), {'space-location-name.'..planets.expansion} }}
  end

  -- members
  content.add { type = 'label', style = 'bold_label', caption = 'Members' }
  local p_counts = get_player_counts(force)
    content.add { type = 'label', style = 'semibold_caption_label', caption = f('\tOnline: %d/%d', p_counts.online, p_counts.total)}
    content.add { type = 'label', style = 'semibold_caption_label', caption = f('\tOffline: %d/%d', p_counts.offline, p_counts.total)}
    if p_counts.total > 0 then
      content.add { type = 'label', style = 'semibold_caption_label', caption = '\tPlayers list:'}
      local players_frame = content.add({
        type = 'frame',
        name = 'players',
        direction = 'vertical',
        style = 'deep_frame_in_shallow_frame',
      })
      Gui.set_style(players_frame, { horizontal_align = 'center', maximal_width = 180, padding = 5, horizontally_stretchable = true })

      local label = players_frame.add({ type = 'label', name = 'members', caption = table.concat(Functions.get_player_list(force), '   ') })
      Gui.set_style(label, { single_line = false, font = 'default-small', horizontal_align = 'center' })
    end

  Gui.add_pusher(content, 'vertical')
  local flow_3 = content.add { type = 'flow', direction = 'horizontal', style = 'player_input_horizontal_flow' }
  Gui.set_style(flow_3, { vertical_align = 'center', left_padding = 8, right_padding = 8 })

  local button
  local p_force = game.get_player(parent.player_index).force
  local leave = flow_3.add { type = 'button', style = 'red_back_button', caption = 'Leave', name = leave_force_button_name }
  Gui.set_style(leave, { height = 24, natural_height = 24, minimal_width = 80 })
  Gui.set_data(leave, { force_index = force.index })
  leave.visible = p_force == force
  leave.tooltip = {'info.cooldown_tooltip', storage.DEBOUNCE_TICKS / 3600}

  Gui.add_pusher(flow_3)
  local join = flow_3.add { type = 'button', style = 'confirm_button_without_tooltip', caption = 'Join', name = join_force_button_name }
  Gui.set_style(join, { height = 24, natural_height = 24, minimal_width = 60 })
  Gui.set_data(join, { force_index = force.index })
  join.visible = p_force ~= force
  join.tooltip = {'info.cooldown_tooltip', storage.DEBOUNCE_TICKS / 3600}
  join.enabled = player.admin or (not storage.is_team_locked[force.name])
  if not join.enabled then
    join.caption = 'Closed'
  end
end

function Public.get_main_frame(player)
  local frame = player.gui.screen[main_frame_name]
  if frame and frame.valid then
    return frame
  end

  frame = Gui.add_closable_frame(player, {
    name = main_frame_name,
    caption = 'Team starts'
  })
  Gui.set_style(frame, {
    natural_width = 400,
    natural_height = 900,
  })

  local inner = frame.add { type = 'frame', style = 'inside_deep_frame', direction = 'vertical' }
  local subheader = inner.add { type = 'frame', style = 'subheader_frame' }
  Gui.set_style(subheader, { use_header_filler = true, horizontally_stretchable = true })

  local flow = subheader.add { type = 'flow', direction = 'horizontal' }
  Gui.set_style(flow, { vertical_align = 'center', left_padding = 8, right_padding = 8 })
  local subtitle = flow.add { type = 'label', caption = 'Calidus solar system', style = 'subheader_caption_label' }

  local sp = inner.add { type = 'scroll-pane', style = 'naked_scroll_pane' }

  local info = sp.add { type = 'frame', direction = 'vertical' }.add { type = 'flow', style = 'player_input_horizontal_flow' }
  Gui.set_style(info, { horizontally_stretchable = true })
  info.add { type = 'label', caption = {'gui.team_manager_caption'}, tooltip = {'gui.team_manager_tooltip'} }
  Gui.add_pusher(info)
  info.add { type = 'label', caption = {'gui.current_force', Functions.get_team_name(player.force)} }

  Gui.set_style(sp, { padding = 12 })
  local grid = sp.add { type = 'table', column_count = 3 }

  for i = 1, Functions.universe_size() do
    display_team(grid, game.forces['player_'..i])
  end
end

Gui.on_click(main_button_name, function(event)
  Public.toggle_main_button(event.player)
end)

Gui.on_click(leave_force_button_name, function(event)
  if debounce(event.player) then
    return
  end
  Functions.switch_force(event.player, game.forces.player)
end)

Gui.on_click(join_force_button_name, function(event)
  if debounce(event.player) then
    return
  end
  local data = Gui.get_data(event.element)
  Public.toggle_main_button(event.player)
  Functions.switch_force(event.player, game.forces[data.force_index])
end)

Event.add(defines.events.on_player_joined_game, function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then
    return
  end
  Public.update_top_button(player)
end)

return Public