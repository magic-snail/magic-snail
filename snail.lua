Snail = {}
Snail.__index = Snail

function Snail.new(x, y, imageLeft, imageRight, imageUp, imageDown)
    local sn = {}
    setmetatable(sn, Snail)

    sn.x = x
    sn.y = y
    sn.imageLeft = love.graphics.newImage(imageLeft)
    sn.imageRight = love.graphics.newImage(imageRight)
    sn.imageUp = love.graphics.newImage(imageUp)
    sn.imageDown = love.graphics.newImage(imageDown)
    sn:setColor(1)

    -- 0 = right, 1 = down, 2 = left, 3 = up
    sn.facingDirection = 0
    sn.snailWidth, sn.snailHeight = sn:getCurrentImage():getDimensions()

    return sn
end

function Snail:getX()
    return self.x
end

function Snail:getY()
    return self.y
end

function Snail:moveX(p)
    -- 0 = right, 1 = down, 2 = left, 3 = up
    if p < 0 then
        self.facingDirection = 2
    else
        self.facingDirection = 0
    end

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
    -- 0 = right, 1 = down, 2 = left, 3 = up
    if p < 0 then
        self.facingDirection = 3
    else
        self.facingDirection = 1
    end

    self.y = self.y + p

    -- Stop at borders
    if self.y < 0 then
        self.y = 0
    end
    if (self.y + self.snailHeight) > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.snailHeight
    end
end

function Snail:getCurrentImage()
    -- 0 = right, 1 = down, 2 = left, 3 = up
    if self.facingDirection == 0 then
        return self.imageRight
    end
    if self.facingDirection == 1 then
        return self.imageDown
    end
    if self.facingDirection == 2 then
        return self.imageLeft
    end
    if self.facingDirection == 3 then
        return self.imageUp
    end
end

function Snail:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.draw(self:getCurrentImage(), self.x, self.y)
    love.graphics.reset()
    self.snailWidth, self.snailHeight = self:getCurrentImage():getDimensions()
end

function Snail:setColor(currentElement)
    local elementColors = {
        -- red
        {r = 30, g = 0, b = 0, a = 100},
        -- blue
        {r = 0, g = 102, b = 153, a = 100},
        -- grey
        {r = 0.5, g = 0.5, b = 0.5, a = 1},
        -- yellow
        {r = 255, g = 255, b = 0, a = 100}
    }

    self.color = elementColors[currentElement]
end