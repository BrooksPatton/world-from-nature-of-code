local Vector = require('./vector')

local Predator = {}
Predator.__index = Predator

function Predator.new(location)
  local t = {}
  setmetatable(t, Predator)

  t.location = location
  t.searchcolor = {255, 150, 150}
  t.huntcolor = {255, 10, 10}
  t.health = 30
  t.mass = 50
  t.radius = 15

  t.acceleration = Vector.new(0, 0)
  t.velocity = Vector.new(0, 0)

  t.lastAteAt = love.timer.getTime()
  t.sightRange = 100
  t.searchspeed = 30
  t.huntspeed = 100

  t.randomLoc = nil

  return t
end

function Predator:display()
  if self.target then
    love.graphics.setColor(self.huntcolor)
  else
    love.graphics.setColor(self.searchcolor)
  end

  love.graphics.circle('fill', self.location.x, self.location.y, self.radius)
  --love.graphics.setColor(255, 255, 255)
  --love.graphics.circle('line', self.location.x, self.location.y, self.sightRange)
end

function Predator:searchForFood(foods)
  if not self.target then
    for i, food in ipairs(foods) do
      local distance = (self.location - food.location):len()
      if distance < self.sightRange then
        self.target = food
        break
      end
    end
  end

  if not self.target and not self.randomLoc then
    local x = love.math.random(0, width)
    local y = love.math.random(0, height)

    self.randomLoc = Vector.new(x, y)
  end
end

function Predator:move(dt)
  local acc
  local direction

  if self.target and self.target.dead then
    self.target = nil
  end

  if self.target then
    direction = self.target.location - self.location
  elseif self.randomLoc then
    direction = self.randomLoc - self.location
  end

  if direction then
    direction:normalizeInplace()
    local s 
    if self.target then
      s = self.huntspeed * dt
    else
      s = self.searchspeed * dt
    end
    acc = direction * s
    self:applyForce(acc)
  end
end

function Predator:applyForce(force)
  local f = force / self.mass
  self.acceleration = self.acceleration + f
end

function Predator:update()
  self.velocity = self.velocity + self.acceleration
  self.location = self.location + self.velocity
  self.acceleration = self.acceleration * 0

  if self.randomLoc then
    local distanceToRandom = (self.location - self.randomLoc):len()
    if distanceToRandom <= 1 then
      self:resetTargets()
    end
  end
end

function Predator:starve()
  local t = love.timer.getTime()
  
  if(t - self.lastAteAt > 1) then
    self.health = self.health - 1
    self.lastAteAt = t
  end

  if self.health <= 0 then
    self.dead = true
  end

end

function Predator:eat()
  if self.target.type == 'prey' and not self.target.dead then
    local distance = (self.location - self.target.location):len()

    if distance < self.radius then
      self.health = self.health + self.target.health
      self.target.dead = true
      self.target = nil
    end
  elseif self.target.type == 'food' and self.target.dead then
    self.target = nil
  end
end

function Predator:resetTargets()
  self.target = nil
  self.randomLoc = nil
end

return Predator
