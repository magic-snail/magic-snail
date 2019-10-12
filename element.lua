Element = {}
Element .__index = Element

function Element.new(x, y, directionX, directionY, image, type)
    local em = {}
    setmetatable(em, Element)

    em.x = x
    em.y = y
    em.image = love.graphics.newImage(image)
    local types = {
        "fire",
        "water",
        "earth",
        "air"
    }
    em.type = types[type]

    local dir = math.atan2(x-directionX,y-directionY)
    em.ax = math.sin(dir)
    em.ay = math.cos(dir)

    return em
end

function Element:update(dt)
    self.x = self.x - self.ax * dt
    self.y = self.y - self.ay * dt
end

function Element:draw()
    love.graphics.draw(self.image, self.x, self.y)
end