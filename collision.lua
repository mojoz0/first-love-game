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
function ClosestObjectOnPaths(travel_dir, edge_line,
                              low_bound, high_bound, gameboard)
  local line = edge_line
  while (not IntersectSolidTile(line, low_bound, high_bound,
                                gameboard, travel_dir)) do
    line = NextTileLine(line, travel_dir)
  end
   
  return line

end

-- Determines if there are any solid tiles on line within spec. bounds
function IntersectSolidTile(intersect_line, low, high, gameboard, tdir)

  -- Assume scan down
  -- TODO: implement scanning in all directions
  for i=low, high+1 do
    --dbgprint("IST: low, high =", low, high)
    local tile = gameboard:GetTileRC(intersect_line, i)
    if (tile:IsSolid()) then
      return true
    end
  end

  return false
end

function NextTileLine(line, tdir)
  -- Assume scan down
  -- TODO: implement scanning in all directions
  return line + 1
end 

