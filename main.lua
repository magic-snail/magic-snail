require 'snail'


function love.load()
    mySnail = Snail:new(0, 0, "/assets/images/snail.png")
    love.window.setFullscreen(true)
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") then
        mySnail:moveY(100 * dt)
    end
    if love.keyboard.isDown("up") then
        mySnail:moveY(- 100 * dt)
    end
    if love.keyboard.isDown("left") then
        mySnail:moveX(- 100 * dt)
    end
    if love.keyboard.isDown("right") then
        mySnail:moveX(100 * dt)
    end
end

function love.draw()
    mySnail:draw()
end
