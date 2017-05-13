local Vector = require('./vector')
local Food = require('./food-class')
local utility = require('./utility')
local RandomWalkCreature = require('./randomWalkCreature-class')

local foods = {}
local foodLastAdded
local randomWalkCreatures = {}

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  foodLastAdded = love.timer.getTime()

  for i = 1, 100 do
    addFood()
  end

  for i = 1, 10 do
    local x = love.math.random(0, width)
    local y = love.math.random(0, height)
    local location = Vector.new(x, y)

    table.insert(randomWalkCreatures, RandomWalkCreature.new(location))
  end
end

function love.draw()
  for i, food in ipairs(foods) do
    if food.dead then
      table.remove(foods, i)
    end
    food:display()
  end

  for i, randomWalkCreature in ipairs(randomWalkCreatures) do
    randomWalkCreature:display()
  end
end

function love.update(dt)
  if dt > 0.029 then dt = 0.029 end

  if shouldAddFood() then
    addFood()
  end

  removeDeadThings(foods)
  removeDeadThings(randomWalkCreatures)

  for i, randomWalkCreature in ipairs(randomWalkCreatures) do
    randomWalkCreature:searchForFood(foods)
    if randomWalkCreature.target then randomWalkCreature:eat() end
    randomWalkCreature:move(dt)
    applyFriction(randomWalkCreature)
    randomWalkCreature:starve()
    randomWalkCreature:update()
  end
end

function addFood()
  local rw = love.math.random(0, width)
  local rh = love.math.random(0, height)
  local location = Vector.new(rw, rh)

  table.insert(foods, Food.new(location))
end

function shouldAddFood()
  local r = utility.monteCarloRandom()

  if r < 0.1 then
    return true
  else
    return false
  end
end

function applyFriction(c)
  local v = c.velocity:normalized()
  v = v * -.3
  c:applyForce(v)
end

function removeDeadThings(tbl)
  for i, v in ipairs(tbl) do
    if v.dead then
      table.remove(tbl, i)
    end
  end
end
