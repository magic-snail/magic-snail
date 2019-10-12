require 'snail'
require 'enemy'

local joystick
local points
local startTime
local snailSpeed
local enemySpeed
local myBackground
local backgroundElementsArray
local mySnail
local chanceOfNewEnemy = 100
local enemyArray = {}

function love.load()
    -- Globals
    points = 0
    startTime = love.timer.getTime()
    snailSpeed = 1000
    enemySpeed = 300

    local joysticks = love.joystick.getJoysticks()
    if joysticks[1] then
        joystick = joysticks[1]
    end

    local numGrass = 10
    local numMushroom = 10

    -- Backgroundsound
    local myBackgroundSound = love.audio.newSource("/assets/music/sneaky_snitch.mp3", "stream")
    myBackgroundSound:setLooping(true)
    myBackgroundSound:play()

    -- Window
    love.window.setFullscreen(true)
    love.window.setTitle('Magic Snail')
    local snailIcon = love.image.newImageData('/assets/images/snail_left.png')
    love.window.setIcon(snailIcon)

    -- base background image
    myBackground = love.graphics.newImage("/assets/images/green.png")
    -- add background elements
    local myBackgroundGrass = love.graphics.newImage("/assets/images/green_grass_free.png")
    local myBackgroundMush= love.graphics.newImage("/assets/images/green_mushroom_free.png")
    backgroundElementsArray = {}
    for _ = 1, numGrass + 1 do
        table.insert(backgroundElementsArray, {
            image = myBackgroundGrass,
            x = love.math.random(love.graphics.getWidth()),
            y = love.math.random(love.graphics.getHeight())
        })
    end
    for _ = 1, numMushroom + 1 do
        table.insert(backgroundElementsArray, {
            image = myBackgroundMush,
            x = love.math.random(love.graphics.getWidth()),
            y = love.math.random(love.graphics.getHeight())
        })
    end
    -- sort background elements by height
    table.sort(
        backgroundElementsArray,
        function(a, b) return a['y'] < b['y'] end
    )

    -- Classes
    mySnail = Snail.new(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        "/assets/images/snail_left.png",
        "/assets/images/snail_right.png",
        "/assets/images/snail_back.png",
        "/assets/images/snail_front.png"
    )
end

function love.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") then
        mySnail:moveY(snailSpeed * dt)
    end
    if love.keyboard.isDown("up") then
        mySnail:moveY(- snailSpeed * dt)
    end
    if love.keyboard.isDown("left") then
        mySnail:moveX(- snailSpeed * dt)
    end
    if love.keyboard.isDown("right") then
        mySnail:moveX(snailSpeed * dt)
    end

    if joystick then
        local x, y = joystick.getAxes(joystick)
        if x < 0 then
            mySnail:moveX(- snailSpeed * dt)
        end
        if x > 0 then
            mySnail:moveX(snailSpeed * dt)
        end
        if y < 0 then
            mySnail:moveY(- snailSpeed * dt)
        end
        if y > 0 then
            mySnail:moveY(snailSpeed * dt)
        end
    end
    
    if math.random(100 / dt) < (chanceOfNewEnemy + 1) then
        table.insert(enemyArray, Enemy.new(1000, 1000, "/assets/images/golem.png"))
    end

    for _, enemy in pairs(enemyArray) do
        enemy:move(enemySpeed * dt, mySnail:getX(), mySnail:getY())
    end
end

function love.draw()
    -- Draw background image
    for i = 0, love.graphics.getWidth() / myBackground:getWidth() do
        for j = 0, love.graphics.getHeight() / myBackground:getHeight() do
            love.graphics.draw(myBackground, i * myBackground:getWidth(), j * myBackground:getHeight())
        end
    end

    -- Draw background elements
    for _, data in pairs(backgroundElementsArray) do
        love.graphics.draw(data['image'], data['x'], data['y'])
    end

    -- print FPS
    love.graphics.setNewFont(15)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 50)

    -- print Infos
    love.graphics.setNewFont(25)
    love.graphics.print("Points: " .. string.format("%05d", points), 0, 0)
    love.graphics.print(
        "Time: " .. string.format("%04d", math.floor(love.timer.getTime() - startTime)),
        love.graphics.getWidth()-150,
        0
    )

    -- Draw Classes
    mySnail:draw()
    for _, enemy in pairs(enemyArray) do
        enemy:draw()
    end
end
