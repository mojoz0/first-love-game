--[[
- @file tile.lua
- @brief Describes Tile class
--]]


-- Constants
TILE_PASS_THROUGH = 1
TILE_SOLID = 2
TILE_ONE_WAY = 3

Tile = {}
Tile.__index = Tile

function Tile.new(args)
  return setmetatable({color = args.color or CLR_WHT,
                       tile_type = args.tile_type or TILE_PASS_THROUGH},
                       Tile)
end

setmetatable(Tile, { __call = function(_, ...) return Tile.new(...) end })

