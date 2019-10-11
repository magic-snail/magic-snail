require 'snail'

function love.load()
    points = 0
    startTime = love.timer.getTime()
    speed = 1000
    mySnail = Snail:new(0, 0, "/assets/images/snail.png")
    myBackground = love.graphics.newImage("/assets/images/green.png")

    love.window.setFullscreen(true)
    love.window.setTitle('Magic Snail')
    snailIcon = love.image.newImageData('/assets/images/snail_left.png')
    love.window.setIcon(snailIcon)
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
    love.graphics.setNewFont(15)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 50)

    -- print Infos
    love.graphics.setNewFont(25)
    love.graphics.print("Points: " .. points, 0, 0)
    love.graphics.print("Time: " .. string.format("%03d", math.floor(love.timer.getTime() - startTime)), love.graphics.getWidth()-150, 0)

    mySnail:draw()
end
