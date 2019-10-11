Snail = {}
Snail.__index = Snail

function Snail:new(x, y, image)
    local sn = {}
    setmetatable(sn, Snail)
    sn.x = x
    sn.y = y
    sn.image = love.graphics.newImage(image)
    return sn
end

function Snail:moveX(p)
    self.x = self.x + p
end

function Snail:moveY(p)
    self.y = self.y + p
end

function Snail:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
