
require('entity')

-- Constants
TILE_SIZE = 32
CLR_BLK = {0, 0, 0, 255}
CLR_WHT = {255, 255, 255, 255}
CLR_SKY_BLU = {135, 206, 250, 255}
CLR_DRT_BRN = {139, 69, 19, 255}
CLR_GRS_GRN = {34, 139, 34, 255}
CLR_PRL = {153, 0, 153, 255}

function love.load()
  canvas = love.graphics.newCanvas()

  love.graphics.setCanvas(canvas)
	screen_width, screen_height = canvas:getDimensions()
	-- canvas.clear()
        hero = Entity{x_pos=screen_width/2, y_pos=screen_height/2, y_acc=100, size=40}
	love.graphics.setBackgroundColor(CLR_SKY_BLU)
	love.graphics.setColor(CLR_DRT_BRN)
	love.graphics.rectangle("fill", 0, screen_height*.6, screen_width, screen_height*.4)
	love.graphics.setColor(CLR_GRS_GRN)
	love.graphics.rectangle("fill", 0, screen_height*.6, screen_width, screen_height*.05)

	love.graphics.print('Hello World!', screen_width*.2, screen_height*.3, 0, 4)
  love.graphics.setCanvas()
end


function love.update(dt)
  hero:Update(dt)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  print(screen_width)
  love.graphics.draw(canvas)
  hero.Draw(hero, canvas)

end




