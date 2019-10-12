start = {}

local logoImage

function start.load()
    love.graphics.setBackgroundColor(255, 255, 255)
    logoImage = love.graphics.newImage('/assets/images/snail_icon.png')
end

function start.update()
    if love.keyboard.isDown("space") then
        return "game"
    else
        return "start"
    end
end

function start.draw()
    local windowWidth, windowHeight, _
    local logoX, logoY
    windowWidth, windowHeight, _ = love.window.getMode()
    logoX = windowWidth / 2 - logoImage:getWidth() / 2
    logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)
end

return start
