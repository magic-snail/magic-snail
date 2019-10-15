Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, image, stoppableByObstacle, notKillableBy, points, speed)
    local en = {}
    setmetatable(en, Enemy)

    en.x = x
    en.y = y
    en.image = love.graphics.newImage(image)
    en.stoppableByObstacle = stoppableByObstacle
    en.notKillableBy = notKillableBy
    en.points = points
    en.speed = speed
    en.flipped = false

    return en
end

function Enemy:getNextCoordinates(speed, snailX, snailY)
    local directionVectorX = self.x - snailX
    local directionVectorY = self.y - snailY
    local distance = math.sqrt(directionVectorX ^ 2 + directionVectorY ^ 2)
    local sinAlpha = directionVectorY / distance
    local sinBeta = directionVectorX / distance

    local newX = self.x - sinBeta * speed
    local newY = self.y - sinAlpha * speed

    if newX > self.x then
        self.flipped = true
    else
        self.flipped = false
    end

    return {x = newX, y = newY}
end

function Enemy:move(x, y)
    self.x = x
    self.y = y
end

function Enemy:draw()
    if self.flipped then
        love.graphics.draw(self.image, self.x + self.image:getWidth(), self.y, 0, -1, 1)
    else
        love.graphics.draw(self.image, self.x, self.y)
    end
end
