endgame = {}

function endgame.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function endgame.update()

end

function endgame.draw()
    love.graphics.print('YouLost!')
end

return endgame
