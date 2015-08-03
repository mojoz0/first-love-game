--[[
  @file dbg.lua
  @brief Defines functions for debugging
  @author Francisco Rojo (mojoz0101@gmail.com)
--]]

dbg = true
time_step = 0

-- Turn on to show tile lines
DBG_SHOW_TILE_LINES = dbg

function dbgprint (...)
  if dbg then print(string.format(...)) end
end

function FATAL(...)
  print(string.format(...))
  assert(false)
end

