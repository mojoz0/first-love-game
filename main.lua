
require('entity')

function love.load()
  canvas = love.graphics.newCanvas()

  love.graphics.setCanvas(canvas)
	width, height = canvas:getDimensions()
	-- canvas.clear()
        hero = Entity(width/2, height/2, 0, 0, 0, 100, 40)
	
        sky_blue = {135, 206, 250, 255}
	love.graphics.setBackgroundColor(sky_blue)
	dirt_brown = {139, 69, 19, 255}
	love.graphics.setColor(dirt_brown)
	love.graphics.rectangle("fill", 0, height*.6, width, height*.4)
	grass_green = {34, 139, 34, 255}
	love.graphics.setColor(grass_green)
	love.graphics.rectangle("fill", 0, height*.6, width, height*.05)



	love.graphics.print('Hello World!', width*.2, height*.3, 0, 4)
  love.graphics.setCanvas()
end


function love.update(dt)
  hero:Update(dt)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  print(width)
  love.graphics.draw(canvas)
  hero.Draw(hero, canvas)

end




