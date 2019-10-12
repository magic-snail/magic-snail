endgame = {}

local endpoints
function endgame.load(points)
    love.graphics.setNewFont(25)
    love.graphics.setBackgroundColor(0, 0, 0)
    endpoints = points
end

function endgame.update()
end

function endgame.draw()
    love.graphics.print('YouLost, points: ' .. endpoints)
end

return endgame
