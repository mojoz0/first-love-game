
require('game_board')
require('collision')

Entity = {}
Entity.__index = Entity

-- Entity Constants
STD_SIZE = 26
HERO_WIDTH = 64
HERO_HEIGHT = 64
X_DIR = 10
Y_DIR = 20
DIR_RIGHT = 1
DIR_LEFT = -1
DIR_DOWN = 2
DIR_UP = -2

-- Entity will be a base class for things that are not static on screen
-- TODO: Only let Entity.new take x_pos, y_pos and size 
function Entity.new(args) 
  return setmetatable({x_pos = args.x_pos or 0, 
                       y_pos = args.y_pos or 0,
                       x_vel = args.x_vel or 0,
                       y_vel = args.y_vel or 0,
                       x_acc = args.x_acc or 0,
                       y_acc = args.y_acc or 0,
                       x_len = args.size or STD_SIZE,
                       y_len = args.size or STD_SIZE}, Entity)
end

setmetatable(Entity, { __call = function(_, ...) return Entity.new(...) end })


function Entity:DistNatural(pos, vel, time_delta)
  return vel*time_delta
end

-- TODO: Function to scan for objects in path of entity
-- Params: gameboard, hero
function Entity:DistClosestStaticObj(gameboard, dir, entity)
  -- Determine direction that entity is going in specified direction
  -- we're gonna assume we're asking for Y direction

  -- TODO: Maybe unpack all these functions and make this a monster
  -- function for performance reasons (only have to check dir once)

  -- Coordinate of forward facing edge
  local forward_facing_edge, travel_dir = entity:ForwardFacingEdge(dir)
  dbgprint(string.format("DCSO: travel_dir=%d, ffe=%d", travel_dir,
                         forward_facing_edge))
  local edge_line = CoordToTileLine(forward_facing_edge)

  -- Tile paths that entity intersects with
  local low_bound, high_bound = entity:IntersectedTilePaths(dir)

  local coord_closest_obj = ClosestSolidTileOnPaths(
                                travel_dir, edge_line,
                                low_bound, high_bound, gameboard)
  local pos_closest_obj =  ClosestPhysEdge(coord_closest_obj, travel_dir)


  return math.abs(forward_facing_edge - pos_closest_obj)

end




function Entity:ForwardFacingEdge(dir)
  dbgprint("FFE: dir=", dir)
  if (dir == X_DIR) then
    if (self.x_vel >= 0) then 
      return self.x_pos + self.x_len/2, DIR_RIGHT
    else 
      return self.x_pos - self.x_len/2, DIR_LEFT
    end
  elseif (dir == Y_DIR) then
    if (self.y_vel >= 0) then 
      return self.y_pos + self.y_len/2, DIR_DOWN
    else 
      return self.y_pos - self.y_len/2, DIR_UP
    end
  else
    FATAL("dir not valid") 
  end
end

-- Returns high and low "column"/"row" of intersecting tile paths
function Entity:IntersectedTilePaths(dir)
  local low_bound, high_bound
  if (dir == X_DIR) then
    low_bound = CoordToTileLine(self.y_pos - self.y_len/2)
    high_bound = CoordToTileLine(self.y_pos + self.y_len/2 - 1)
  else 
    low_bound = CoordToTileLine(self.x_pos - self.x_len/2)
    high_bound = CoordToTileLine(self.x_pos + self.x_len/2 - 1)
  end 

  return low_bound, high_bound
end

function Entity:GetNewPos(pos, vel, dist_obj, time_delta)
  -- Natural distance to move if no objects in the way
  local dist_nat = self:DistNatural(pos, vel, time_delta)
  dbgprint("GNP: dist_nat=", dist_nat)

  -- Final position change.  
  local pos_delta = math.min(dist_obj, dist_nat) 
  dbgprint("GNP: pos_delta=", pos_delta)

  -- TODO: Insert logic to detect collisions here?

  return pos + pos_delta 
end


function Entity:UpdatePos(time_delta)
  -- Distance to closest static object
  local dist_obj_x = self:DistClosestStaticObj(game_board, X_DIR, self)
  local dist_obj_y = self:DistClosestStaticObj(game_board, Y_DIR, self)
  dbgprint("dist_obj_x=", dist_obj_x)
  dbgprint("dist_obj_y=", dist_obj_y)
  


  -- TESTING BEGIN
  local test_forward_facing_y, tdir_y = self:ForwardFacingEdge(Y_DIR)
  local edge_line = CoordToTileLine(test_forward_facing_y)
  local low_boundy, high_boundy = self:IntersectedTilePaths(X_DIR)
  local tile_intersect = IntersectSolidTile(edge_line,
                                            low_boundy, high_boundy,
                                            game_board, tdir_y)
  dbgprint("tile_intersect=", tile_intersect)
  -- TESTING END
  

--[[
self:DistClosestStaticObj(
                         self.x_pos, self.x_vel, X_DIR, time_delta)
  local dist_obj_y = self:DistClosestStaticObj(
                         self.y_pos, self.y_vel, Y_DIR, time_delta)

  -- TODO: delete when done testing
  local test_forward_facing_x, tdir_x = self:ForwardFacingEdge(X_DIR)
  local test_forward_facing_y, tdir_y = self:ForwardFacingEdge(Y_DIR)
  dbgprint("test_forward_facing_x=", test_forward_facing_x, tdir_x)
  dbgprint("test_forward_facing_y=", test_forward_facing_y, tdir_y) 
  local low_boundx, high_boundx = self:IntersectedTilePaths(Y_DIR)
  local low_boundy, high_boundy = self:IntersectedTilePaths(X_DIR)
  dbgprint("low_boundx, high_boundx=", low_boundx, high_boundx)
  dbgprint("low_boundy, high_boundy=", low_boundy, high_boundy)
]]
 

  -- Final new position in each direction
  self.x_pos = self:GetNewPos(self.x_pos, self.x_vel, dist_obj_x, time_delta)
  self.y_pos = self:GetNewPos(self.y_pos, self.y_vel, dist_obj_y, time_delta)


end


function Entity:Update(time_delta)

  dbgprint(string.format("=== Time Step %d ===", time_step))
  time_step = time_step + 1
  self:UpdatePos(time_delta)


  -- TODO: Package this into Entity:UpdateVel()
  -- (or Entity:Acc()?)
  self.x_vel = self.x_vel + self.x_acc*time_delta
  self.y_vel = self.y_vel + self.y_acc*time_delta
end

function Entity:Draw()
  love.graphics.setColor(CLR_YLW)
  -- FIXME: This causes trouble for odd-numbered sizes. problem?
  love.graphics.circle("fill", self.x_pos, self.y_pos, self.x_len/2)
  love.graphics.setColor(CLR_BLK)
  love.graphics.circle(
      "fill", self.x_pos - self.x_len/4, self.y_pos - self.y_len/6, 
      self.x_len/12)
  love.graphics.circle(
      "fill", self.x_pos + self.x_len/4, self.y_pos - self.y_len/6, 
      self.x_len/12)
  love.graphics.arc("fill", self.x_pos, self.y_pos, self.x_len/4,
                     0, math.pi)



--[[  love.graphics.rectangle(
      "fill", self.x_pos - self.x_len/2, self.y_pos - self.y_len/2,
      self.x_len, self.y_len)
]]
end



