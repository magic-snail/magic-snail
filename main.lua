snailxpos = 0
snailypos = 0

function love.load()
    love.window.setFullscreen(true)
    snail = love.graphics.newImage("/assets/images/snail.png")
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") then
        snailypos = snailypos + 1000 * dt -- this would increment num by 100 per second
    end
    if love.keyboard.isDown("up") then
        snailypos = snailypos - 1000 * dt
    end
    if love.keyboard.isDown("left") then
        snailxpos = snailxpos - 1000 * dt
    end
    if love.keyboard.isDown("right") then
        snailxpos = snailxpos + 1000 * dt
    end
end

function love.draw()
    snailwidth, snailheight = snail:getDimensions()

    -- Stop at borders
    if snailxpos < 0 then snailxpos = 0 end
    if (snailxpos + snailwidth) > love.graphics.getWidth() then snailxpos = love.graphics.getWidth() - snailwidth end
    if snailypos < 0 then snailypos = 0 end
    if (snailypos + snailheight) > love.graphics.getHeight() then snailypos = love.graphics.getHeight() - snailheight end

    -- draw snail
    love.graphics.draw(snail, snailxpos, snailypos)
end