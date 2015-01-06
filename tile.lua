--[[
- @file tile.lua
- @brief Describes Tile class
--]]

require("dbg")

-- Constants
TILE_SIZE = 32
TILE_PASS_THROUGH = 1
TILE_SOLID = 2
TILE_ONE_WAY = 3
COORD_SCALE_FACTOR = (1/TILE_SIZE)*20

Tile = {}
Tile.__index = Tile

function Tile.new(args)
  return setmetatable({color = args.color or CLR_WHT,
                       tile_type = args.tile_type or TILE_PASS_THROUGH},
                       Tile)
end

setmetatable(Tile, { __call = function(_, ...) return Tile.new(...) end })

function Tile:IsSolid()
  return (self.tile_type == TILE_SOLID)
end


-- Draws tile at tile position (x_pos, y_pos)
function Tile:Draw(x_pos, y_pos)    
  love.graphics.setColor(self.color) 
  love.graphics.rectangle("fill", x_pos, y_pos, TILE_SIZE, TILE_SIZE)
  --dbgprint("DBG_SHOW_TILE_LINES=", DBG_SHOW_TILE_LINES)
  if (DBG_SHOW_TILE_LINES) then
    dbgprint("in the if statetment...= ", DBG_SHOW_TILE_LINES)
    self:DrawDebugLines(x_pos, y_pos)
  end
end

function Tile:DrawDebugLines(x_pos, y_pos)

  if (self.tile_type == TILE_PASS_THROUGH) then
    love.graphics.setColor(CLR_GRN)
  else
    love.graphics.setColor(CLR_RED)
  end

  -- Draw right-side line
  local tl_x = x_pos
  local tl_y = y_pos 
  local bl_x = tl_x
  local bl_y = y_pos + TILE_SIZE - 1 
  love.graphics.line(tl_x, tl_y, bl_x, bl_y)

  -- Draw bottom line
  local br_x = x_pos + TILE_SIZE - 1
  local br_y = bl_y
  love.graphics.line(bl_x, bl_y, br_x, br_y)

  -- Draw coordinates
  local x_coord = math.floor(x_pos/TILE_SIZE)
  local y_coord = math.floor(y_pos/TILE_SIZE)
  local coord_string = string.format("(%d, %d)", x_coord, y_coord)
  love.graphics.print(coord_string, x_pos, y_pos, 0, COORD_SCALE_FACTOR)

end



