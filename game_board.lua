
require('dbg')
require('tile')

game_board = {}

function init_game_board()
  num_tiles_wide = math.floor(screen_width / TILE_SIZE)
  num_tiles_high = math.floor(screen_height / TILE_SIZE)
  num_total_tiles = num_tiles_wide*num_tiles_high

  -- Initialize array of blank tiles
  for i=1, num_total_tiles+1 do
    dbgprint("init i=", i)
    game_board[i] = Tile({}) 
  end

  -- FIXME: This is just for testing/development now

  local pltfm_height = 6
  local pltfm_tile_start = num_total_tiles - (num_tiles_wide*pltfm_height) + 1

  dbgprint("num_tiles_wide=", num_tiles_wide)
  dbgprint("pltfm_tile_start=", pltfm_tile_start)
  dbgprint("num_total_tiles=", num_total_tiles)

  -- Make the bottom lines solid black
  for i=pltfm_tile_start, num_total_tiles+1 do
    dbgprint("color i=", i)
    game_board[i].color = CLR_BLK
    game_board[i].tile_type = TILE_SOLID
  end 
end


function game_board_draw(canvas)
  dbgprint("num_total_tiles=", num_total_tiles)
  for i=1,num_total_tiles+1 do
    local x_pos = ((i-1) % num_tiles_wide) * TILE_SIZE
    local y_pos = (math.floor((i-1) / num_tiles_wide)) * TILE_SIZE 
    dbgprint("i, y_pos=", i, y_pos)
    love.graphics.setColor(game_board[i].color)
    love.graphics.rectangle("fill", x_pos, y_pos, TILE_SIZE, TILE_SIZE)
  end
end






