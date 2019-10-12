require "start"
require "game"

local gamestate
local newstate

function love.load()
    gamestate = "start"
    start.load()
end

function love.update(dt)
    if gamestate == "start" then
        newstate = start.update()
    elseif gamestate == "game" then
        newstate = game.update(dt)
    end

    if gamestate ~= newstate then
        gamestate = newstate
        if newstate == "start" then
            start.load()
        elseif newstate == "game" then
            game.load()
        end
    end
end

function love.draw()
    if gamestate == "start" then
        start.draw()
    elseif gamestate == "game" then
        game.draw()
    end
end
