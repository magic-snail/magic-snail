Element = {}
Element .__index = Element

function Element.new(x, y, directionX, directionY, image, type)
    local em = {}
    setmetatable(em, Element)

    em.x = x
    em.y = y
    em.image = love.graphics.newImage(image)
    if type == 1 then em.type = "fire" end
    if type == 2 then em.type = "water" end
    if type == 3 then em.type = "earth" end
    if type == 4 then em.type = "air" end

    local dir = math.atan2(x-directionX,y-directionY)
    em.ax = math.sin(dir)
    em.ay = math.cos(dir)

    return em
end

function Element:fire(p)
    self.x = self.x - self.ax * p
    self.y = self.y - self.ay * p
end

function Element:draw()
    love.graphics.draw(self.image, self.x, self.y)
end