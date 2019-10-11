require 'snail'


function love.load()
    mysnail = Snail:new(0, 0, "/assets/images/snail.png")
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    if love.keyboard.isDown("down") then
        mysnail:movey(100 * dt)
    end
    if love.keyboard.isDown("up") then
        mysnail:movey(- 100 * dt)
    end
    if love.keyboard.isDown("left") then
        mysnail:movex(- 100 * dt)
    end
    if love.keyboard.isDown("right") then
        mysnail:movex(100 * dt)
    end
end

function love.draw()
    mysnail:draw()
end
