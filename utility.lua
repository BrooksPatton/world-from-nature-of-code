function monteCarloRandom()
  while true do
    local r1 = love.math.random()
    local r2 = love.math.random()

    if r2 < r1 then
      return r1
    end
  end
end

return {
  monteCarloRandom = monteCarloRandom
}
