Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  -- in C this is : ballDX = math.random(2) == 1 ? -BALL_SPEED : BALL_SPEED
  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50)
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  -- in C this is : ballDX = math.random(2) == 1 ? -BALL_SPEED : BALL_SPEED
  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50) * 1.5
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
  -- Draw ball
  love.graphics.rectangle('fill', self.x, self.y, 4, 4)
end