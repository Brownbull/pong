WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
PADDLE_SIZE = 20

WIN_SCORE = 3

BALL_SPEED = 100
Class = require 'Class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
  math.randomseed(os.time())
  -- Filtering to make images sharp on pixel scale
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- title
  love.window.setTitle('Pong')
  
  -- Setup Font
  smallFont = love.graphics.newFont('04B_03__.TTF', 8)
  scoreFont = love.graphics.newFont('04B_03__.TTF', 32)
  victoryFont = love.graphics.newFont('04B_03__.TTF', 24)

  -- sounds
  sounds = {
    ['paddle_hit'] = love.audio.newSource('paddlehit.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('wallhit.wav', 'static'),
    ['point'] = love.audio.newSource('point.wav', 'static')
  }

  -- Initialize Vitrual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = true
  })

  -- Initialize vars
  player1Score = 0
  player2Score = 0

  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH /2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  servingPlayer = math.random(2) and 1 or 2
  winner = 0
  if servingPlayer == 1 then
    ball.dx = 100
  else
    ball.dx = -100
  end

  gameState = 'start'
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  -- Begin Game
  if gameState == 'play' then
    ball:update(dt)

    if ball.x <= 0 then
      player2Score = player2Score + 1
      servingPlayer = 1
      sounds['point']:play()
      ball:reset()
      if player2Score >= WIN_SCORE then
        gameState = 'victory'
        winner = 2
      else
        gameState = 'serve'
      end
      ball.dx = 100
    end

    if ball.x >= VIRTUAL_WIDTH - 4 then
      player1Score = player1Score + 1
      servingPlayer = 2
      sounds['point']:play()
      ball:reset()
      if player1Score >= WIN_SCORE then
        gameState = 'victory'
        winner = 1
      else
        gameState = 'serve'
      end
      ball.dx = -100
    end

    if ball:collides(paddle1) then 
      ball.dx = -ball.dx * 1.03 
      ball.x = paddle1.x + 5
      sounds['paddle_hit']:play()
    end

    if ball:collides(paddle2) then 
      ball.dx = -ball.dx * 1.03 
      ball.x = paddle2.x - 4
      sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
      ball.dy = -ball.dy
      ball.y = 0
      sounds['wall_hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.dy = -ball.dy
      ball.y = VIRTUAL_HEIGHT - 4
      sounds['wall_hit']:play()
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

  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'victory' then
      gameState = 'start'
      player1Score = 0
      player2Score = 0
    elseif gameState == 'serve' then
      gameState = 'play'
    end
  end
end

function love.draw()
  -- start rendeting at virtual res
  push:apply('start')

  -- Background color
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255)

  if gameState == 'start' then
    love.graphics.setFont(smallFont)
    love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    love.graphics.setFont(victoryFont)
    love.graphics.printf("Player" .. tostring(winner) .. " wins!",
      0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
  end
  -- Scores
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
  
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