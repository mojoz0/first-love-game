
Entity = {}
Entity.__index = Entity

-- Entity Constants
STD_SIZE = 25


-- Entity will be a base class for things that are not static on screen
-- TODO: Only let Entity.new take x_pos, y_pos and size 
function Entity.new(x_pos, y_pos, x_vel, y_vel, x_acc, y_acc, size)
  return setmetatable({x_pos = x_pos or 0, 
                       y_pos = y_pos or 0,
                       x_vel = x_vel or 0,
                       y_vel = y_vel or 0,
                       x_acc = x_acc or 0,
                       y_acc = y_acc or 0,
                       size = size or STD_SIZE}, Entity)
end

setmetatable(Entity, { __call = function(_, ...) return Entity.new(...) end })


function Entity:Update(time_delta)
  self.x_pos = self.x_pos + self.x_vel*time_delta
  self.y_pos = self.y_pos + self.y_vel*time_delta
  self.x_vel = self.x_vel + self.x_acc*time_delta
  self.y_vel = self.y_vel + self.y_acc*time_delta
end


