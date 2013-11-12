local Main = Game:addState('Main')

function Main:enteredState()
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  self.grid = Grid:new(25, 25)

  for x, y, _ in self.grid:each() do
    self.grid:set(x, y, "g")
  end
  -- self.grid:set(5, 5, "i")

  self.player = {x = 5, y = 5, letter = "@"}

  self.tile_width, self.tile_height = 15, 20

  self.controls = {
    keyboard = {
      update = {
        -- up = self.keyupdate_up,
        -- down = self.keyupdate_down,
        -- left = self.keyupdate_left,
        -- right = self.keyupdate_right
      },
      pressed = {
        up = self.keypressed_up,
        down = self.keypressed_down,
        left = self.keypressed_left,
        right = self.keypressed_right
      }
    }
  }
end

function Main:update(dt)

end

function Main:render()
  self.camera:set()

  for x, y, letter in self.grid:each() do
    if x == self.player.x and y == self.player.y then
      g.setColor(COLORS.red:rgb())
      g.print(self.player.letter, x * self.tile_width, y * self.tile_height)
    else
      g.setColor(COLORS.white:rgb())
      g.print(letter, x * self.tile_width, y * self.tile_height)
    end
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  local action = self.controls.keyboard.pressed[key]
  if is_func(action) then action(self) end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:keypressed_up()
  self.player.y = self.player.y - 1
end

function Main:keypressed_down()
  self.player.y = self.player.y + 1
end

function Main:keypressed_left()
  self.player.x = self.player.x - 1
end

function Main:keypressed_right()
  self.player.x = self.player.x + 1
end


function Main:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
