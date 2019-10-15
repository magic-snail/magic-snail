start = {}

local startFont
local smallFont
local coloredText
local descText1
local descText2
local descText3
local logoImage

function start.load()
    startFont = love.graphics.setNewFont(26)
    smallFont = love.graphics.setNewFont(20)

    local textColor = {0, 0, 0}
    coloredText = {textColor, "Press ENTER to start!"}
    descText1 = {textColor, "Just click with the mouse to summon a magic element."}
    descText2 = {textColor, "Change the element with the mousewheel."}
    descText3 = {textColor, "Not all elements can defeat all enemies."}

    local backgroundColor = {
        0.651,
        0.518,
        0.612
    }
    love.graphics.setBackgroundColor(backgroundColor)
    logoImage = love.graphics.newImage('/assets/images/backgrounds/startscene.png')
end

function start.draw()
    local windowWidth, windowHeight = love.window.getMode()
    local logoX = windowWidth / 2 - logoImage:getWidth() / 2
    local logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)

    local textYPos = windowHeight / 2 + logoImage:getHeight() / 4
    love.graphics.setFont(startFont)
    love.graphics.printf(coloredText, 0, textYPos, windowWidth, "center")

    love.graphics.setFont(smallFont)
    love.graphics.printf(descText1, 0, textYPos+40, windowWidth, "center")
    love.graphics.printf(descText2, 0, textYPos+65, windowWidth, "center")
    love.graphics.printf(descText3, 0, textYPos+90, windowWidth, "center")
end

return start
