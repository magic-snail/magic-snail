snailxpos = 0
snailypos = 0

function love.load()
    snail = love.graphics.newImage("/assets/images/snail.png")
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    if love.keyboard.isDown("down") then
        snailypos = snailypos + 100 * dt -- this would increment num by 100 per second
    end
    if love.keyboard.isDown("up") then
        snailypos = snailypos - 100 * dt
    end
    if love.keyboard.isDown("left") then
        snailxpos = snailxpos - 100 * dt
    end
    if love.keyboard.isDown("right") then
        snailxpos = snailxpos + 100 * dt
    end
end

function love.draw()
    love.graphics.draw(snail, snailxpos, snailypos)
end