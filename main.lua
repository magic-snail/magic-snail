require 'snail'
require 'element'

local points
local startTime
local speed
local myBackground
local myBackgroundGrass
local backgroundGrassArray
local myBackgroundMush
local backgroundMushArray
local mySnail

function love.load()
    -- Globals
    points = 0
    startTime = love.timer.getTime()
    speed = 1000
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

    -- Backgroundimage
    myBackground = love.graphics.newImage("/assets/images/green.png")
    -- Array with grass
    myBackgroundGrass = love.graphics.newImage("/assets/images/green_grass.png")
    backgroundGrassArray = {}
    for i = 1, numGrass + 1 do
        backgroundGrassArray[i] = {}
        backgroundGrassArray[i]["x"] = love.math.random(love.graphics.getWidth())
        backgroundGrassArray[i]["y"] = love.math.random(love.graphics.getHeight())
    end

    -- Array with mushrooms
    myBackgroundMush= love.graphics.newImage("/assets/images/green_mushroom.png")
    backgroundMushArray = {}
    for i = 1, numMushroom + 1 do
        backgroundMushArray[i] = {}
        backgroundMushArray[i]["x"] = love.math.random(love.graphics.getWidth())
        backgroundMushArray[i]["y"] = love.math.random(love.graphics.getHeight())
    end

    -- Classes
    mySnail = Snail.new(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        "/assets/images/snail_left.png",
        "/assets/images/snail_right.png",
        "/assets/images/snail_back.png",
        "/assets/images/snail_front.png"
    )

    elements = {}
end

function love.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") then
        mySnail:moveY(speed * dt)
    end
    if love.keyboard.isDown("up") then
        mySnail:moveY(- speed * dt)
    end
    if love.keyboard.isDown("left") then
        mySnail:moveX(- speed * dt)
    end
    if love.keyboard.isDown("right") then
        mySnail:moveX(speed * dt)
    end
    if love.mouse.isDown(1) then
        ems = table.getn(elements)
        mx, my = love.mouse.getPosition()
        if ems == 0 then
            em = Element.new(mySnail.x, mySnail.y, mx, my,"/assets/images/fire_ball.png")
            table.insert(elements, {elm = em, time = os.time()})
        else
            time = os.time() - 0.2
            if elements[ems].time < time then
                em = Element.new(mySnail.x, mySnail.y, mx, my,"/assets/images/fire_ball.png")
                table.insert(elements, {elm = em, time = os.time()})
            end
        end
    end
    for i,em in ipairs(elements) do
        em.elm:fire(1000 * dt)
        time = os.time() - 1
        if em.time < time then
            table.remove(elements, i)
        end
    end
end

function love.draw()
    -- Draw Backgroundimage
    for i = 0, love.graphics.getWidth() / myBackground:getWidth() do
        for j = 0, love.graphics.getHeight() / myBackground:getHeight() do
            love.graphics.draw(myBackground, i * myBackground:getWidth(), j * myBackground:getHeight())
        end
    end

    -- Draw Grass
    for _, position in pairs(backgroundGrassArray) do
        love.graphics.draw(myBackgroundGrass, position["x"], position["y"])
    end

    -- Draw Mushrooms
    for _, position in pairs(backgroundMushArray) do
        love.graphics.draw(myBackgroundMush, position["x"], position["y"])
    end

    -- print FPS
    love.graphics.setNewFont(15)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 50)

    -- print Infos
    love.graphics.setNewFont(25)
    love.graphics.print("Points: " .. points, 0, 0)
    love.graphics.print(
        "Time: " .. string.format("%04d", math.floor(love.timer.getTime() - startTime)),
        love.graphics.getWidth()-150,
        0
    )

    -- Draw Classes
    mySnail:draw()

    for i,em in ipairs(elements) do
        em.elm:draw()
    end
end
