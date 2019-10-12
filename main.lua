require "start"
require "endgame"
require "game"

local gamestate
local newstate

function love.load()
    -- Backgroundsound
    local myBackgroundSound = love.audio.newSource("/assets/music/sneaky_snitch.mp3", "stream")
    myBackgroundSound:setLooping(true)
    myBackgroundSound:play()

    love.graphics.setNewFont(25)
    gamestate = "start"
    start.load()
end

function love.update(dt)
    if gamestate == "start" then
        newstate = start.update()
    elseif gamestate == "game" then
        newstate, points = game.update(dt)
    end

    if gamestate ~= newstate then
        gamestate = newstate
        if newstate == "start" then
            start.load()
        elseif newstate == "game" then
            game.load()
        elseif newstate == "dead" then
            endgame.load(points)
        end
    end
end

function love.draw()
    if gamestate == "start" then
        start.draw()
    elseif gamestate == "game" then
        game.draw()
    elseif gamestate == "dead" then
        endgame.draw()
    end
end

function love.keypressed(key, _, isrepeat)
    if not isrepeat and key == "escape" then
        if gamestate == "start" then
            love.event.quit()
        elseif gamestate == "game" then
            gamestate = "start"
            start.load()
        elseif gamestate == "dead" then
            gamestate = "start"
            start.load()
        end
    end
end
