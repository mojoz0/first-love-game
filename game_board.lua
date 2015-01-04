
require('dbg')
require('tile')


DFLT_GB_SIZE = 8

Gameboard = {}
Gameboard.__index = Gameboard

function Gameboard.new(args)
  assert (args.num_tiles_wide > 0)
  assert (args.num_tiles_high > 0)

  local num_tiles_wide = args.num_tiles_wide or DFLT_GB_LEN
  local num_tiles_high = args.num_tiles_high or DFLT_GB_LEN
  local num_total_tiles = num_tiles_wide*num_tiles_high

  local tile_arr = {}
  
  -- Initialize array of blank tiles
  for i=1, num_total_tiles+1 do
    dbgprint("init i=", i)
    tile_arr[i] = Tile({}) 
  end

  return setmetatable({num_tiles_wide = num_tiles_wide,
                       num_tiles_high = num_tiles_high,
                       num_total_tiles = num_total_tiles,
                       tile_arr = tile_arr},
                      Gameboard)
end

setmetatable(Gameboard, { __call = function(_, ...) return Gameboard.new(...) end })


function init_game_board()
  local num_tiles_wide = math.floor(screen_width / TILE_SIZE)
  local num_tiles_high = math.floor(screen_height / TILE_SIZE)

  local game_board = Gameboard{num_tiles_wide=num_tiles_wide,
                               num_tiles_high=num_tiles_high}

  -- FIXME: This is just for testing/development now

  local pltfm_height = 6
  local pltfm_tile_start = 
     game_board.num_total_tiles - (game_board.num_tiles_wide*pltfm_height) + 1

  dbgprint("num_tiles_wide=", num_tiles_wide)
  dbgprint("pltfm_tile_start=", pltfm_tile_start)
  dbgprint("num_total_tiles=", game_board.num_total_tiles)

  -- Make the bottom lines solid black
  for i=pltfm_tile_start, game_board.num_total_tiles+1 do
    dbgprint("color i=", i)
    game_board.tile_arr[i].color = CLR_BLK
    game_board.tile_arr[i].tile_type = TILE_SOLID
  end 

  return game_board

end

-- Util function that coonverts raw coordinate to tile line number
function CoordToTileLine(coord)
  return math.floor(coord / TILE_SIZE)
end

function Gameboard:Draw(canvas)
  --dbgprint("num_total_tiles=", num_total_tiles)
  for i=1, self.num_total_tiles+1 do
    local tile = self.tile_arr[i] 
    local x_pos = ((i-1) % self.num_tiles_wide) * TILE_SIZE
    local y_pos = (math.floor((i-1) / self.num_tiles_wide)) * TILE_SIZE 
    tile:Draw(x_pos, y_pos)
    --dbgprint("i, y_pos=", i, y_pos)
  end
end

function Gameboard:GetTileRC(row, col)
  local idx = row*self.num_tiles_wide + col
  --dbgprint("GTRC: idx, row, col =", idx, row, col)
  assert(idx < self.num_total_tiles)
  return self.tile_arr[idx]
end


