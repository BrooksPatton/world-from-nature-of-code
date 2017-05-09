local Vector = require('./vector')
local Food = require('./food-class')
local utility = require('./utility')
local RandomWalkCreature = require('./randomWalkCreature-class')

local foods = {}
local foodLastAdded
local randomWalkCreature

--TODO have the randomWalkCreature eat food and if doesn't find then big jump

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  foodLastAdded = love.timer.getTime()

  for i = 1, 10 do
    addFood()
  end

  local location = Vector.new(width/2, height/2)
  randomWalkCreature = RandomWalkCreature.new(location)
end

function love.draw()
  for i, food in ipairs(foods) do
    food:display()
  end

  randomWalkCreature:display()
end

function love.update(dt)
  if shouldAddFood() then
    addFood()
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

