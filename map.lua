Map = class('Map', Base)

function Map:initialize(x, y, width, height, tile_width, tile_height)
  Base.initialize(self)
  assert(is_num(x) and is_num(y) and is_num(width) and is_num(height))
  assert(is_num(tile_width) and is_num(tile_width))

  self.x, self.y = x, y
  self.width, self.height = width, height
  self.tile_width, self.tile_height = tile_width, tile_height

  self.render_queue = Skiplist.new(self.width * self.height * 3)

  self.grid = Grid:new(self.width, self.height)
  for x,y,_ in self.grid:each() do
    self.grid[x][y] = MapTile:new(self, x, y)
  end

  -- map to grid proxy functions
  self.each = function(self, ...) return self.grid:each(...) end
  self.set = function(self, ...) return self.grid:set(...) end
  self.get = function(self, ...) return self.grid:get(...) end

  -- grid a* functions
  local function adjacency(tile)
    local adjacent = {}
    for x, y, neighbor in tile.parent.grid:each(tile.x - 1, tile.y - 1, 3, 3) do
      if not(x == tile.x and y == tile.y) then
        table.insert(adjacent, neighbor)
      end
    end
    return ipairs(adjacent)
  end

  local function cost(from, to)
    return to:cost_to_move_to()
  end

  local function distance(from, goal)
    return math.abs(goal.x - from.x) + math.abs(goal.y - from.y)
  end

  self.grid_astar = AStar:new(adjacency, cost, distance)
end

function Map:update(dt)
end

function Map:render()
  for x, y, tile in self.grid:each() do
    tile:render(self:grid_to_world_coords(x, y))
  end

  for index,entity in self.render_queue:ipairs() do
    entity:render()
  end
end

function Map:add_entity(entity)
  assert(instanceOf(MapEntity, entity))
  entity:insert_into_grid()
  self.render_queue:insert(entity)
end

function Map:grid_to_world_coords(x, y)
  return (x - 1) * self.tile_width + self.x, (y - 1) * self.tile_height + self.y
end

function Map:mousepressed(x, y, button)
end

function Map:mousereleased(x, y, button)
end

function Map:keypressed(key, unicode)
end

function Map:keyreleased(key, unicode)
end

function Map:joystickpressed(joystick, button)
end

function Map:joystickreleased(joystick, button)
end

function Map:focus(has_focus)
end

function Map:quit()
end
