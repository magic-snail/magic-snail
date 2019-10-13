require "start"
require "endgame"
require "game"

local gameState
local newState

function love.load()
    -- Backgroundsound
    local myBackgroundSound = love.audio.newSource("/assets/music/sneaky_snitch.mp3", "stream")
    myBackgroundSound:setLooping(true)
    myBackgroundSound:play()

    love.graphics.setNewFont(25)
    gameState = 'start'
    newState = 'start'
    start.load()
end

function love.update(dt)
    if gameState == "game" and gameState == newState then
        newState, points = game.update(dt)
    end

    if gameState ~= newState then
        gameState = newState
        if newState == "start" then
            start.load()
        elseif newState == "game" then
            game.load()
        elseif newState == "dead" then
            endgame.load(points)
        end
    end
end

function love.draw()
    if gameState == "start" then
        start.draw()
    elseif gameState == "game" then
        game.draw()
    elseif gameState == "dead" then
        endgame.draw()
    end
end

function love.keypressed(key, _, isRepeat)
    if not isRepeat then
        if key == "escape" then
            if gameState == "start" then
                love.event.quit()
            elseif gameState == "game" then
                newState = "start"
            elseif gameState == "dead" then
                newState = "start"
            end
        end

        if key == 'space' then
            if gameState == 'game' then
                game.advandeCurrentElement()
            end
        end

        if key == 'return' then
            if gameState == 'start' or gameState == 'dead' then
                newState = 'game'
            end
        end
    end
end

function love.mousepressed(_, _, button)
    if button == 1 and (gameState == 'start' or gameState == 'dead') then
        newState = 'game'
    end
end
