--[[
  @file dbg.lua
  @brief Defines functions for debugging
  @author Francisco Rojo (mojoz0101@gmail.com)
--]]

dbg = 0
time_step = 0

-- Turn on to show tile lines
DBG_SHOW_TILE_LINES = false

function dbgprint (...)
  if dbg then print(...) end
end

function FATAL(s)
  print(s)
  assert(false)
end

