start = {}

function start.load()
end

function start.update()
    if love.keyboard.isDown("space") then
        return "game"
    else
        return "start"
    end
end

function start.draw()
    love.graphics.print('Hello World!')
end

return start
