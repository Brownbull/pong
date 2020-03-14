WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'

function love.load()
  -- Filtering to make images sharp on pixel scale
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Setup Font
  smallFont = love.graphics.newFont('04B_03__.TTF', 8)
  scoreFont = love.graphics.newFont('04B_03__.TTF', 32)

  -- Initialize vars
  player1Score = 0
  player2Score = 0

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 40

  -- Initialize Vitrual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

function love.update(dt)
  -- Player 1 paddle
  if love.keyboard.isDown('w') then
    player1Y = player1Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    player1Y = player1Y + PADDLE_SPEED * dt
  end

  -- Player 2 paddle
  if love.keyboard.isDown('up') then
    player2Y = player2Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') then
    player2Y = player2Y + PADDLE_SPEED * dt
  end
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
  love.graphics.rectangle('fill', 5, player1Y, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- Scores
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  -- Message
  love.graphics.setFont(smallFont)
  love.graphics.printf( "Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
  
  -- end rendeting at virtual res
  push:apply('end')
end