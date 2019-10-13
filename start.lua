start = {}

local startFont
local coloredText
local logoImage

function start.load()
    startFont = love.graphics.setNewFont(25)
    local textColor = {0, 0, 0}
    coloredText = {textColor, "Press SPACE to start!"}
    descText1 = {textColor, "Just click with the mouse to summon a magic element."}
    descText2 = {textColor, "Change the element with the mousewheel."}
    descText3 = {textColor, "Not all elements can defeat all enemies."}
    love.graphics.setBackgroundColor(255, 255, 255)
    logoImage = love.graphics.newImage('/assets/images/magic_snail_start_background.png')
end

function start.draw()
    local windowWidth, windowHeight = love.window.getMode()
    local logoX = windowWidth / 2 - logoImage:getWidth() / 2
    local logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)

    love.graphics.setFont(startFont)
    local textYPos = windowHeight / 2 + logoImage:getHeight() / 2 - 120
    love.graphics.printf(coloredText, 0, textYPos, windowWidth, "center")
    love.graphics.printf(descText1, 0, textYPos+40, windowWidth, "center")
    love.graphics.printf(descText2, 0, textYPos+65, windowWidth, "center")
    love.graphics.printf(descText3, 0, textYPos+90, windowWidth, "center")
end

return start
