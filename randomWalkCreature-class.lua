local Vector = require('./vector')

local RandomWalkCreature = {}
RandomWalkCreature.__index = RandomWalkCreature

function RandomWalkCreature.new(location)
  local t = {}
  setmetatable(t, RandomWalkCreature)

  t.location = location
  t.color = {150, 150, 255}
  t.mass = 5

  t.acceleration = Vector.new(0, 0)
  t.velocity = Vector.new(0, 0)

  return t
end

function RandomWalkCreature:display()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.location.x, self.location.y, self.mass)
end

return RandomWalkCreature
