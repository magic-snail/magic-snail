Snail = {}
Snail.__index = Snail

function Snail:new(x, y, image)
    local sn = {}
    setmetatable(sn, Snail)
    sn.x = x
    sn.y = y
    sn.image = love.graphics.newImage(image)
    sn.snailWidth, sn.snailHeight = sn.image:getDimensions()
    return sn
end

function Snail:moveX(p)
    self.x = self.x + p

    -- Stop at borders
    if self.x < 0 then
        self.x = 0
    end
    if (self.x + self.snailWidth) > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.snailWidth
    end
end

function Snail:moveY(p)
    self.y = self.y + p

    -- Stop at borders
    if self.y < 0 then
        self.y = 0
    end
    if (self.y + self.snailHeight) > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.snailHeight
    end
end

function Snail:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
