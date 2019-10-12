local http = require("socket.http")
local logoImage

endgame = {}

local endpoints
function endgame.load(points)
    love.graphics.setNewFont(25)
    love.graphics.setBackgroundColor(0, 0, 0)
    logoImage = love.graphics.newImage('/assets/images/magic_snail_endscene.png')
    love.graphics.setBackgroundColor(255, 255, 255)
    endpoints = points

    place = http.request("http://tclinux.de/snailscore.php?password=Geix7ei3oZey3reiJi6c&mode=set&score=" .. points)
    highscores = http.request("http://tclinux.de/snailscore.php?password=Geix7ei3oZey3reiJi6c&mode=get")
end

function endgame.update()
end

function endgame.draw()
    local windowWidth, windowHeight, _
    local logoX, logoY
    windowWidth, windowHeight, _ = love.window.getMode()
    logoX = windowWidth / 2 - logoImage:getWidth() / 2
    logoY = windowHeight / 2 - logoImage:getHeight() / 2
    love.graphics.draw(logoImage, logoX, logoY)
    logoX = logoX + 20;

    love.graphics.print('You have been eaten! Your points: ' .. endpoints, logoX, logoY)

    love.graphics.print('WORLDWIDE HIGHSCORES: ', logoX, logoY + 50)
    i = 1
    for k, v in string.gmatch(highscores, "(%w+);(%w+)") do
        love.graphics.print(i .. ": ", logoX, logoY + 40 + (40*i))
        love.graphics.print(k, logoX + 50, logoY + 40 + (40*i))
        love.graphics.print(i+1 .. ": ", logoX, logoY + 80 + (40*i))
        love.graphics.print(v, logoX + 50, logoY + 80 + (40*i))
        i = i + 2
    end
    love.graphics.print('You are on place: ' .. place, logoX, logoY + 40 + (40*i))
end

return endgame

