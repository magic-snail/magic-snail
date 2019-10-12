start = {}

local startFont
local textColor
local coloredText
local logoImage

function start.load()
    startFont = love.graphics.setNewFont(25)
    textColor = {0, 0, 0}
    coloredText = {textColor, "Press SPACE to start!"}
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

    love.graphics.setFont(startFont)
    local textYPos = windowHeight / 2 + logoImage:getHeight() / 2 + 100
    love.graphics.printf(coloredText, 0, textYPos, windowWidth, "center")
end

return start
