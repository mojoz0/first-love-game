
require('game_board')


Entity = {}
Entity.__index = Entity

-- Entity Constants
STD_SIZE = 26
HERO_WIDTH = 64
HERO_HEIGHT = 64
X_DIR = 10
Y_DIR = 20
DIR_EAST = 1
DIR_WEST = -1
DIR_SOUTH = 2
DIR_NORTH = -2

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

-- TODO: this
function Entity:DistClosestStaticObj(pos, vel, time_delta)

  return 10000000

end

function Entity:ForwardFacingEdge(dir)
  if (dir == X_DIR) then
    if (self.x_vel > 0) then 
      return self.x_pos + self.x_len/2, DIR_EAST
    else 
      return self.x_pos - self.x_len/2, DIR_WEST
    end
  else -- if (dir == Y_DIR)
    if (self.y_vel > 0) then 
      return self.y_pos + self.y_len/2, DIR_SOUTH
    else 
      return self.y_pos - self.y_len/2, DIR_NORTH
    end
  end
end

-- Returns high and low "column"/"row" of intersecting tile paths
function Entity:IntersectedTilePaths(dir)
  local low_bound, high_bound
  if (dir == X_DIR) then
    low_bound = CoordToTileLine(self.y_pos - self.y_len/2)
    high_bound = CoordToTileLine(self.y_pos + self.y_len/2)
  else 
    low_bound = CoordToTileLine(self.x_pos - self.x_len/2)
    high_bound = CoordToTileLine(self.x_pos + self.x_len/2)
  end 

  return low_bound, high_bound
end

function Entity:GetNewPos(pos, vel, dist_obj, time_delta)
  -- Natural distance to move if no objects in the way
  local dist_nat = self:DistNatural(pos, vel, time_delta)

  -- Final position change.  
  local pos_delta = math.min(dist_obj, dist_nat) 

  -- TODO: Insert logic to detect collisions here?

  return pos + pos_delta 
end


function Entity:UpdatePos(time_delta)
  -- Distance to closest static object
  local dist_obj_x = self:DistClosestStaticObj(
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

 

  -- Final new position in each direction
  self.x_pos = self:GetNewPos(self.x_pos, self.x_vel, dist_obj_x, time_delta)
  self.y_pos = self:GetNewPos(self.y_pos, self.y_vel, dist_obj_y, time_delta)
  -- dbgprint("new y_pos = ", self.y_pos)


end


function Entity:Update(time_delta)
  self:UpdatePos(time_delta)

  self.x_vel = self.x_vel + self.x_acc*time_delta
  self.y_vel = self.y_vel + self.y_acc*time_delta
end

function Entity:Draw()
  love.graphics.setColor(CLR_PRL)
  -- FIXME: This causes trouble for odd-numbered sizes. problem?
  love.graphics.rectangle(
      "fill", self.x_pos - self.x_len/2, self.y_pos - self.y_len/2,
      self.x_len, self.y_len)
end



