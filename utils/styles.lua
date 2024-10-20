local Public = {}

Public.default_close = {
  style = {
    height = 28,
    font = 'default-semibold',
    font_color = { 0, 0, 0 },
  },
}

Public.default_top_element = {
  name = 'frame_button',
  style = {
    font_color = { 165, 165, 165 },
    font = 'heading-2',
    minimal_height = 40,
    maximal_height = 40,
    minimal_width = 40,
    padding = -2,
  },
}

Public.default_left_element = {
  style = {
    padding = 2,
    font_color = { 165, 165, 165 },
    font = 'heading-2',
    use_header_filler = false,
  },
}

Public.default_pusher = {
  style = {
    top_margin = 0,
    bottom_margin = 0,
    left_margin = 0,
    right_margin = 0,
  },
}

return Public
