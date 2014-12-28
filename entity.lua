
Entity = {}
Entity.__index = Entity

-- Entity Constants
STD_SIZE = 26
HERO_WIDTH = 64
HERO_HEIGHT = 64
X_DIR = 10
Y_DIR = 20

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


function Entity:DistNatural(dir, time_delta)
  local pos 
  if (dir == X_DIR) then
    pos = self.x_pos
    vel = self.x_vel
  else
    pos = self.y_pos
    vel = self.y_vel
  end

  return pos + vel*time_delta
end


-- TODO
function Entity:DistClosestStaticObj(dir, time_delta)

  return 10000000

end



function Entity:UpdatePos(dir, time_delta)
  -- Distance to closest static object
  local dist_obj = self:DistClosestStaticObj(dir, time_delta)      

  -- Natural distance to move if no objects in the way
  local dist_nat = self:DistNatural(dir, time_delta)
 
  pos_delta = math.min(dist_obj, dist_nat)
  --TODO: register the change!!
   
 

end


function Entity:Update(time_delta)
  self:UpdatePos(X_DIR, time_delta)
  self:UpdatePos(Y_DIR, time_delta)




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



