Element = {}
Element .__index = Element

function Element.new(x, y, directionX, directionY, image)
    local em = {}
    setmetatable(em, Element)

    em.x = x
    em.y = y
    em.mx = directionX
    em.dy = directionY
    em.image = love.graphics.newImage(image)

    dir = math.atan2(x-directionX,y-directionY)
    em.ax = math.sin(dir)
    em.ay = math.cos(dir)

    return em
end

function Element:fire(p)
    self.x = self.x - em.ax * p
    self.y = self.y - em.ay * p
end

function Element:draw()
    love.graphics.draw(self.image, self.x, self.y)
end