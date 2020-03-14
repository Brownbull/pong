WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
PADDLE_SIZE = 20

BALL_SPEED = 100

push = require 'push'

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

  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 40

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  -- in C this is : ballDX = math.random(2) == 1 ? -BALL_SPEED : BALL_SPEED
  ballDX = math.random(2) == 1 and -100 or 100
  ballDY = math.random(-50, 50)

  gameState = 'start'

end

function love.update(dt)
  -- Player 1 movement paddle
  if love.keyboard.isDown('w') then
    player1Y = math.max(player1Y - PADDLE_SPEED * dt, 0)
  elseif love.keyboard.isDown('s') then
    player1Y = math.min(player1Y + PADDLE_SPEED * dt, VIRTUAL_HEIGHT - PADDLE_SIZE)
  end

  -- Player 2 movement paddle
  if love.keyboard.isDown('up') then
    player2Y = math.max(player2Y - PADDLE_SPEED * dt, 0)
  elseif love.keyboard.isDown('down') then
    player2Y = math.min(player2Y + PADDLE_SPEED * dt, VIRTUAL_HEIGHT - PADDLE_SIZE)
  end

  -- Begin Game
  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
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
      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

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
  
  -- Draw ball
  love.graphics.rectangle('fill', ballX, ballY, 5, 5)
  
  -- Draw paddles
  love.graphics.rectangle('fill', 5, player1Y, 5, PADDLE_SIZE)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, PADDLE_SIZE)

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
  
  -- end rendeting at virtual res
  push:apply('end')
end