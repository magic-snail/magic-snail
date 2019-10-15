local http = require("socket.http")
http.TIMEOUT = 5

endgame = {}

local logoImage
local endpoints
local highscores

function endgame.load(points)
    love.graphics.setNewFont(25)
    local backgroundColor = {
        0.651,
        0.518,
        0.612
    }
    love.graphics.setBackgroundColor(backgroundColor)
    logoImage = love.graphics.newImage('/assets/images/backgrounds/endscene.png')
    endpoints = points

    if points ~= 0 then
        place = http.request("http://tclinux.de/snailscore.php?mode=set&score=" .. points)
    end
    highscores = http.request("http://tclinux.de/snailscore.php?mode=get")
end

function endgame.update()
end

function endgame.draw()
    local windowWidth, windowHeight = love.window.getMode()
    local logoX = windowWidth / 2 - logoImage:getWidth() / 2
    local logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)
    logoX = logoX + 30;

    love.graphics.print('You have been eaten! Your points: ' .. endpoints, logoX, logoY + 20)

    local i = 1
    if highscores then
        love.graphics.print('WORLDWIDE HIGHSCORES: ', logoX, logoY + 70)
        for k, v in string.gmatch(highscores, "(%w+);(%w+)") do
            love.graphics.print(i .. ": ", logoX, logoY + 70 + (35*i))
            love.graphics.print(k, logoX + 50, logoY + 70 + (35*i))
            love.graphics.print(i+1 .. ": ", logoX, logoY + 105 + (35*i))
            love.graphics.print(v, logoX + 50, logoY + 105 + (35*i))
            i = i + 2
        end
    end
    if place then
        love.graphics.print('You are on place: ' .. place, logoX, logoY + 90 + (35*i))
    end
end

return endgame
