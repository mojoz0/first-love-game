--[[
  @file collision.lua
  @brief Contains logic for collision detecting
  @author Francisco Rojo (mojoz0101@gmail.com)
--]]

require("game_board")
require("dbg")

--[[
-- TODO: Function to scan for objects in path of entity
-- Params: gameboard, hero
function DistClosestStaticObj(gameboard, dir, entity)
  -- Determine direction that entity is going in specified direction
  -- we're gonna assume we're asking for Y direction

  -- TODO: Maybe unpack all these functions and make this a monster
  -- function for performance reasons (only have to check dir once)

  -- Coordinate of forward facing edge
  local forward_facing_edge, travel_dir = entity:ForwardFacingEdge(dir)
  local edge_line = CoordToTileLine(forward_facing_edge)

  -- Tile paths that entity intersects with
  local low_bound, high_bound = entity:IntersectedTilePaths(dir)

  local coord_closest_object = ClosestObjectOnPaths(
                                   dir, edge_line,
                                   low_bound, high_bound, gameboard)

  return math.abs(forward_facing_edge - coord_closest_obj)

end
]]


-- Scanning function
-- Returns column/row of closest obstacle in that path
function ClosestSolidTileOnPaths(travel_dir, edge_line,
                                 low_bound, high_bound, gameboard)
  local bound_line = gameboard:GetBoundLine(travel_dir)
  dbgprint(string.format("COOP: bound_line=%d", bound_line))
  local line = edge_line
  while (not (line == bound_line) and 
         not IntersectSolidTile(line, low_bound, high_bound,
                                gameboard, travel_dir)) do
    line = NextTileLine(line, travel_dir)
  end
   
  return line

end

function ClosestPhysEdge(coord, tdir)
  if (tdir == DIR_UP or tdir == DIR_LEFT) then
    return coord*(TILE_SIZE + 1)
  elseif (tdir == DIR_DOWN or tdir == DIR_RIGHT) then
    return coord*TILE_SIZE
  else
    FATAL("Specified nonexistant tdir")
  end

end

-- Determines if there are any solid tiles on line within spec. bounds
function IntersectSolidTile(intersect_line, low, high, gameboard, tdir)

  -- Assume scan down
  -- TODO: implement scanning in all directions
  for i=low, high do
    dbgprint(string.format("IST: tdir=%d", tdir))
    dbgprint("IST: low, high, int_line=", low, high, intersect_line)
    -- TODO: for efficiency: only check if statement once somehow?
    local row, col
    if (tdir == DIR_UP or tdir == DIR_DOWN) then
      row, col = intersect_line, i 
    elseif (tdir == DIR_RIGHT or tdir == DIR_LEFT) then
      row, col = i, intersect_line
    else
      -- FATAL error
      assert(false)
    end

    local tile = gameboard:GetTileRC(row, col)
     
    if (tile:IsSolid()) then
      dbgprint(string.format("IST: Solid tile at (%d, %d)", col, row))
      return true
    end
  end

  return false
end

function NextTileLine(line, tdir)
  -- Assume scan down
  -- TODO: implement scanning in all directions
  if (tdir == DIR_DOWN or tdir == DIR_RIGHT) then
    return line + 1
  elseif (tdir == DIR_UP or tdir == DIR_LEFT) then  
    return line - 1
  else
    -- FATAL error
    assert(false)
  end
end 

