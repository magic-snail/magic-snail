game = {}

require 'snail'
require 'enemy'
require 'element'

local joystick
local points
local startTime
local snailSpeed
local enemySpeed
local myBackground
local backgroundElementsArray
local mySnail
local chanceOfNewEnemy = 100
local enemyImages = {
    "/assets/images/golem.png",
    "/assets/images/blackbird.png"
}
local enemyArray = {}
local obstacles

function game.load()
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
    local numObstacles = 3

    -- Backgroundsound
    local myBackgroundSound = love.audio.newSource("/assets/music/sneaky_snitch.mp3", "stream")
    myBackgroundSound:setLooping(true)
    myBackgroundSound:play()

    -- base background image
    myBackground = love.graphics.newImage("/assets/images/green.png")
    -- add background elements
    local myBackgroundGrass = love.graphics.newImage("/assets/images/green_grass_free.png")
    local myBackgroundMush= love.graphics.newImage("/assets/images/green_mushroom_free.png")
    backgroundElementsArray = {}
    for _ = 1, numGrass do
        table.insert(backgroundElementsArray, {
            image = myBackgroundGrass,
            x = love.math.random(love.graphics.getWidth()),
            y = love.math.random(love.graphics.getHeight())
        })
    end
    for _ = 1, numMushroom do
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

    -- add some obstacles
    obstacles = {}
    local obstacleImage = love.graphics.newImage("/assets/images/wood_free.png")
    for _ = 1, numObstacles do
        table.insert(obstacles, {
            image = obstacleImage,
            x = math.min(
                love.graphics.getWidth() - 300 - obstacleImage:getWidth(),
                math.max(300, love.math.random(love.graphics.getWidth()))
            ),
            y = math.min(
                love.graphics.getHeight() - 300 - obstacleImage:getHeight(),
                math.max(300, love.math.random(love.graphics.getHeight()))
            )
        })
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

function game.update(dt)
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

    if math.random(100 / dt) < (chanceOfNewEnemy + 1) then
        local x, y
        -- 1 = right, 2 = down, 3 = left, 4 = up
        startdir = math.max(1, math.floor(math.random(4)))
        if startdir == 1 then
            x = love.graphics.getWidth()
            y = math.random(love.graphics.getHeight())
        end
        if startdir == 2 then
            x = math.random(love.graphics.getWidth())
            y = love.graphics.getHeight()
        end
        if startdir == 3 then
            x = 0
            y = math.random(love.graphics.getHeight())
        end
        if startdir == 4 then
            x = math.random(love.graphics.getWidth())
            y = 0
        end

        local enemyImage = enemyImages[math.random(#enemyImages)]
        table.insert(enemyArray, Enemy.new(x, y, enemyImage))
    end

    for _, enemy in pairs(enemyArray) do
        local currentEnemySpeed = enemySpeed * dt
        local isColliding = true
        local nextEnemyCoordinates = enemy:getNextCoordinates(currentEnemySpeed, mySnail:getX(), mySnail:getY())
        for _ = 1, 5 do
            if (true == isColliding) then
                currentEnemySpeed = currentEnemySpeed / 2
                nextEnemyCoordinates = enemy:getNextCoordinates(currentEnemySpeed, mySnail:getX(), mySnail:getY())
                local enemyData = {
                    image = enemy.image,
                    x = nextEnemyCoordinates.x,
                    y = nextEnemyCoordinates.y
                }
                isColliding = areColliding(enemyData, obstacles)
            end
        end
        if (false == isColliding) then
            enemy:move(nextEnemyCoordinates.x, nextEnemyCoordinates.y)
        end
    end

    return "game"
end

function game.draw()
    -- Draw background image
    for i = 0, love.graphics.getWidth() / myBackground:getWidth() do
        for j = 0, love.graphics.getHeight() / myBackground:getHeight() do
            love.graphics.draw(myBackground, i * myBackground:getWidth(), j * myBackground:getHeight())
        end
    end

    -- Draw background elements
    for _, data in pairs(backgroundElementsArray) do
        love.graphics.draw(data.image, data.x, data.y)
    end

    -- Draw obstacles
    for _, data in pairs(obstacles) do
        love.graphics.draw(data.image, data.x, data.y)
    end

    for i,em in ipairs(elements) do
        em.elm:draw()
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

function areColliding(enemy, obstaclesArray)
    eWidth, eHeight = enemy.image:getDimensions()

    for _, obstacle in pairs(obstaclesArray) do
        oWidth, oHeight = obstacle.image:getDimensions()

        if enemy.x < (obstacle.x + oWidth)
                and obstacle.x < (enemy.x + eWidth)
                and enemy.y < (obstacle.y + oHeight)
                and obstacle.y < (enemy.y + eHeight)
        then
            return true
        end
    end

    return false
end

return game
