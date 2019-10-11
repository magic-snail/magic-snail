Element = {}
Element .__index = Element

function Element.new(x, y, directionX, directionY, speed, image)
    local em = {}
    setmetatable(em, Element)
    em.x = x
    em.y = y
    em.dx = directionX
    em.dy = directionY
    em.speed = speed
    em.image = love.graphics.newImage(image)

    return em
end

function Element:fire(p)
    dir = math.atan2(self.dx-self.x,self.dy-self.y)
    ax = p * math.cos(dir)
    by = p * math.sin(dir)
    self.x = self.x + by
    self.y = self.y + ax
end

function Element:draw()
    love.graphics.draw(self.image, self.x, self.y)
end