start = {}

local startFont
local coloredText
local logoImage

function start.load()
    startFont = love.graphics.setNewFont(25)
    local textColor = {0, 0, 0}
    coloredText = {textColor, "Press SPACE to start!"}
    love.graphics.setBackgroundColor(255, 255, 255)
    logoImage = love.graphics.newImage('/assets/images/magic_snail_start_background.png')
end

function start.draw()
    local windowWidth, windowHeight = love.window.getMode()
    local logoX = windowWidth / 2 - logoImage:getWidth() / 2
    local logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)

    love.graphics.setFont(startFont)
    local textYPos = windowHeight / 2 + logoImage:getHeight() / 2 - 100
    love.graphics.printf(coloredText, 0, textYPos, windowWidth, "center")
end

return start
