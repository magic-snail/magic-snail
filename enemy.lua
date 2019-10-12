Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, image)
    local en = {}
    setmetatable(en, Enemy)
    en.x = x
    en.y = y
    en.image = love.graphics.newImage(image)

    return en
end

function Enemy:getNextCoordinates(speed, snailX, snailY)
    local directionVectorX = self.x - snailX
    local directionVectorY = self.y - snailY
    local distance = math.sqrt(directionVectorX ^ 2 + directionVectorY ^ 2)
    local sinAlpha = directionVectorY / distance
    local sinBeta = directionVectorX / distance

    return {
        x = self.x - sinBeta * speed,
        y = self.y - sinAlpha * speed
    }
end

function Enemy:move(x, y)
    self.x = x
    self.y = y
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
