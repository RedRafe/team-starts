local function make_gui_sprite(name, size, p)
  local sprite = {
    type = 'sprite',
    name = name,
    filename = '__team-starts__/graphics/'..name..'.png',
    size = size or 64,
    flags = { 'gui-icon' },
  }
  for k, v in pairs(p or {}) do
    sprite[k] = v
  end
  data:extend{ sprite }
end

make_gui_sprite('ts_121', 512)