local http = require("socket.http")

endgame = {}

local endpoints
function endgame.load(points)
    love.graphics.setNewFont(25)
    love.graphics.setBackgroundColor(0, 0, 0)
    endpoints = points

    http.request("http://tclinux.de/snailscore.php?password=Geix7ei3oZey3reiJi6c&mode=set&score=" .. points)
    highscores, b, c = http.request("http://tclinux.de/snailscore.php?password=Geix7ei3oZey3reiJi6c&mode=get")
end

function endgame.update()
end

function endgame.draw()
    love.graphics.print('You have been eaten! Your points: ' .. endpoints, 0, 0)

    love.graphics.print('WORLDWIDE HIGHSCORES: ', 0, 50)
    i = 1
    for k, v in string.gmatch(highscores, "(%w+);(%w+)") do
        love.graphics.print(k, 0, 0 + (100*i))
        love.graphics.print(v, 0, 50 + (100*i))
        i = i + 1
    end
end

return endgame

