require 'snail'

function love.load()
    -- Globals
    points = 0
    startTime = love.timer.getTime()
    speed = 1000

    -- Classes
    mySnail = Snail:new(0, 0, "/assets/images/snail_left.png")

    -- Backgroundimage
    myBackground = love.graphics.newImage("/assets/images/green.png")

    -- Backgroundsound
    myBackgroundSound = love.audio.newSource("/assets/music/sneaky_snitch.mp3", "stream")
    myBackgroundSound:setLooping(true)
    myBackgroundSound:play()

    -- Window
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
    -- Draw Backgroundimage
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
    love.graphics.print("Time: " .. string.format("%04d", math.floor(love.timer.getTime() - startTime)), love.graphics.getWidth()-150, 0)

    -- Draw Classes
    mySnail:draw()
end
