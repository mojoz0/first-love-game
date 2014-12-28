--[[
  @file main.lua
  @brief Contains the main loops for the game
  @author Francisco Rojo (mojoz0101@gmail.com)
--]]

require('dbg')
require('debug')
require('entity')
require('game_board')

-- Constants
TILE_SIZE = 32
CLR_BLK = {0, 0, 0, 255}
CLR_WHT = {255, 255, 255, 255}
CLR_SKY_BLU = {135, 206, 250, 255}
CLR_DRT_BRN = {139, 69, 19, 255}
CLR_GRS_GRN = {34, 139, 34, 255}
CLR_PRL = {153, 0, 153, 255}

function love.load()
  print("Loading game")
  canvas = love.graphics.newCanvas()
  screen_width, screen_height = canvas:getDimensions()
  init_game_board()

  love.graphics.setCanvas(canvas)
	-- canvas.clear()
        hero = Entity({x_pos=screen_width/2, y_pos=screen_height/2, y_acc=100, size=40})
	love.graphics.setBackgroundColor(CLR_SKY_BLU)
	love.graphics.setColor(CLR_DRT_BRN)
	love.graphics.rectangle("fill", 0, screen_height*.6, screen_width, screen_height*.4)
	love.graphics.setColor(CLR_GRS_GRN)
	love.graphics.rectangle("fill", 0, screen_height*.6, screen_width, screen_height*.05)

        game_board_draw(canvas)

	love.graphics.print('Hello World!', screen_width*.2, screen_height*.3, 0, 4)
  love.graphics.setCanvas()
end


function love.update(dt)
  hero:Update(dt)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  dbgprint(screen_width)
  love.graphics.draw(canvas)
  hero:Draw(hero, canvas)

end




