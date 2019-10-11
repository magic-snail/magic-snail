require 'snail'

function love.load()
    speed = 1000
    mySnail = Snail:new(0, 0, "/assets/images/snail.png")
    myBackground = love.graphics.newImage("/assets/images/green.png")

    love.window.setFullscreen(true)
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") then
        mySnail:moveY(speed * dt)
    end
    if love.keyboard.isDown("up") then
        mySnail:moveY(- speed * dt)
    end
    if love.keyboard.isDown("left") then
        mySnail:moveX(- speed * dt)
    end
    if love.keyboard.isDown("right") then
        mySnail:moveX(speed * dt)
    end
end

function love.draw()
    for i = 0, love.graphics.getWidth() / myBackground:getWidth() do
        for j = 0, love.graphics.getHeight() / myBackground:getHeight() do
            love.graphics.draw(myBackground, i * myBackground:getWidth(), j * myBackground:getHeight())
        end
    end

    -- print FPS
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)

    mySnail:draw()
end
