WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

function love.load()
  -- Filtering to make images sharp on pixel scale
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Setup Font
  smallFont = love.graphics.newFont('04B_03__.TTF', 8)
  love.graphics.setFont(smallFont)

  -- Initialize Vitrual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  -- start rendeting at virtual res
  push:apply('start')

  -- Background color
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255)
  
  -- Draw ball
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)
  
  -- Draw paddles
  love.graphics.rectangle('fill', 5, 20, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

  -- Message
  love.graphics.printf( "Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
  
  -- end rendeting at virtual res
  push:apply('end')
end