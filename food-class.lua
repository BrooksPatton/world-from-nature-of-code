local Vector = require('./vector')
local utility = require('./utility')

local Food = {}
Food.__index = Food

function Food.new(location)
  local t = {}
  setmetatable(t, Food)

  t.location = location
  t:setType()
  t.radius = math.abs(t.value) * 2

  return t
end

function Food:setType()
  local r = utility.monteCarloRandom()

  if r > 0.5 then
    self.type = 'normal'
    self.color = {0, 255, 0}
    self.value = 1
  else 
    self.type = 'poison'
    self.color = {255, 0, 0}
    self.value = -1
  end
end

function Food:display()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.location.x, self.location.y, self.radius)
end

return Food
