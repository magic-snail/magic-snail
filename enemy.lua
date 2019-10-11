Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, image)
    local en = {}
    setmetatable(en, Enemy)
    en.x = x
    en.y = y
    en.image = love.graphics.newImage(image)
    en.width, en.Height = en.image:getDimensions()
    return en
end

-- TODO this doesn't work :(
function Enemy:move(speed, snailX, snailY)
    local directionVectorX = snailX - self.x
    local directionVectorY = snailY - self.y
    local distance = math.sqrt(directionVectorX ^ 2 + directionVectorY ^ 2)
    local newVectorX = self.x * (speed / distance)
    local newVectorY = self.y * (speed / distance)
    self.x = self.x - newVectorX
    self.y = self.y - newVectorY
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
