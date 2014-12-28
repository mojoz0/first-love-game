--[[
  @file dbg.lua
  @brief Defines functions for debugging
  @author Francisco Rojo (mojoz0101@gmail.com)
--]]

dbg = 0

function dbgprint (...)
  if dbg then print(...) end
end


