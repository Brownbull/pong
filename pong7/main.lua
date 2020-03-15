WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
PADDLE_SIZE = 20

BALL_SPEED = 100
Class = require 'Class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
  math.randomseed(os.time())
  -- Filtering to make images sharp on pixel scale
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Setup Font
  smallFont = love.graphics.newFont('04B_03__.TTF', 8)
  scoreFont = love.graphics.newFont('04B_03__.TTF', 32)

  -- Initialize Vitrual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  -- Initialize vars
  player1Score = 0
  player2Score = 0

  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH /2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  gameState = 'start'

end

function love.update(dt)
  if ball:collides(paddle1) then 
    ball.dx = -ball.dx
  end

  if ball:collides(paddle2) then 
    ball.dx = -ball.dx
  end

  if ball.y <= 0 then
    ball.dy = -ball.dy
    ball.y = 0
  end

  if ball.y >= VIRTUAL_HEIGHT - 4 then
    ball.dy = -ball.dy
    ball.y = VIRTUAL_HEIGHT - 4
  end

  -- Player 1 movement paddle
  paddle1:update(dt)
  if love.keyboard.isDown('w') then
    paddle1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    paddle1.dy = PADDLE_SPEED
  else
    paddle1.dy = 0
  end

  -- Player 1 movement paddle
  paddle2:update(dt)
  if love.keyboard.isDown('up') then
    paddle2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    paddle2.dy = PADDLE_SPEED
  else
    paddle2.dy = 0
  end

  -- Begin Game
  if gameState == 'play' then
    ball:update(dt)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'
      ball:reset()

      -- in C this is : ballDX = math.random(2) == 1 ? -BALL_SPEED : BALL_SPEED
      ballDX = math.random(2) == 1 and -100 or 100
      ballDY = math.random(-50, 50)
    end
  end
end

function love.draw()
  -- start rendeting at virtual res
  push:apply('start')

  -- Background color
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255)
  
  -- Scores
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  -- Message
  love.graphics.setFont(smallFont)
  if gameState == 'start' then 
    love.graphics.printf( "Hello Pong Start!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then 
    love.graphics.printf( "Hello Pong Play!", 0, 20, VIRTUAL_WIDTH, 'center')
  end
  
  -- Draw paddles
  paddle1:render()
  paddle2:render()
  
  -- Draw ball
  ball:render()

  -- FPS
  displayFPS()

  -- end rendeting at virtual res
  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 40, 20)
  love.graphics.setColor(1, 1, 1, 1)
end