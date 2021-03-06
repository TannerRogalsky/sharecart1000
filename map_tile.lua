MapTile = class('MapTile', Base)

function MapTile:initialize(parent, x, y)
  Base.initialize(self)
  self.parent = parent
  self.x = x
  self.y = y

  self.color = COLORS.white
  self.content = {}
end

function MapTile:update(dt)
end

function MapTile:render(x, y)
  g.setColor(self.color:rgb())
  local _, letter = next(self.content)

  if letter then
    g.printf(letter, x, y, self.parent.tile_width, "center")
  end
end

function MapTile:cost_to_move_to()
  local cost = 0
  for _,content in pairs(self.content) do
    if is_func(content) then
      cost = cost + content:cost_to_move_to()
    elseif is_num(content) then
      cost = cost + content.cost_to_move_to
    end
  end
  return cost
end

function MapTile:mousepressed(x, y, button)
end

function MapTile:mousereleased(x, y, button)
end

function MapTile:keypressed(key, unicode)
end

function MapTile:keyreleased(key, unicode)
end

function MapTile:joystickpressed(joystick, button)
  print(joystick, button)
end

function MapTile:joystickreleased(joystick, button)
  print(joystick, button)
end

function MapTile:focus(has_focus)
end

function MapTile:quit()
end
