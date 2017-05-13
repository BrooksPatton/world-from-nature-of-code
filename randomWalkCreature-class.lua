local Vector = require('./vector')

local RandomWalkCreature = {}
RandomWalkCreature.__index = RandomWalkCreature

function RandomWalkCreature.new(location)
  local t = {}
  setmetatable(t, RandomWalkCreature)

  t.location = location
  t.color = {150, 150, 255}
  t.health = 10
  t.mass = t.health

  t.acceleration = Vector.new(0, 0)
  t.velocity = Vector.new(0, 0)

  t.lastAteAt = love.timer.getTime()
  t.sightRange = 50
  t.speed = 25

  t.randomLoc = nil

  return t
end

function RandomWalkCreature:display()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.location.x, self.location.y, self.health)
  --love.graphics.setColor(255, 255, 255)
  --love.graphics.circle('line', self.location.x, self.location.y, self.sightRange)
end

function RandomWalkCreature:searchForFood(foods)
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

function RandomWalkCreature:move(dt)
  local acc
  local direction

  if self.target then
    direction = self.target.location - self.location
  elseif self.randomLoc then
    direction = self.randomLoc - self.location
  end

  if direction then
    direction:normalizeInplace()
    local s = self.speed * dt
    acc = direction * s
    self:applyForce(acc)
  end
end

function RandomWalkCreature:applyForce(force)
  local f = force / self.mass
  self.acceleration = self.acceleration + f
end

function RandomWalkCreature:update()
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

function RandomWalkCreature:starve()
  local t = love.timer.getTime()
  
  if(t - self.lastAteAt > 5) then
    self.health = self.health - 1
    self.lastAteAt = t
  end

  if self.health <= 0 then
    self.dead = true
  end

end

function RandomWalkCreature:eat()
  if self.target.type == 'food' and not self.target.dead then
    local distance = (self.location - self.target.location):len()

    if distance < self.health then
      self.health = self.health + self.target.value
      self.target.dead = true
      self.target = nil
    end
  elseif self.target.type == 'food' and self.target.dead then
    self.target = nil
  end
end

function RandomWalkCreature:resetTargets()
  self.target = nil
  self.randomLoc = nil
end

return RandomWalkCreature
