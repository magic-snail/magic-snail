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
local chanceOfNewEnemy = 50
local enemyTypes = {
    {
        image = '/assets/images/golem.png',
        stoppableByObstacle = true,
        notKillableBy = "earth",
        points = 10,
        speed = 0.5
    },
    {
        image = '/assets/images/blackbird.png',
        stoppableByObstacle = false,
        notKillableBy = "air",
        points = 30,
        speed = 1.5
    },
    {
        image = '/assets/images/fire_hedgehog.png',
        stoppableByObstacle = true,
        notKillableBy = "fire",
        points = 10,
        speed = 1
    },
    {
        image = '/assets/images/water_turtle.png',
        stoppableByObstacle = true,
        notKillableBy = "water",
        points = 10,
        speed = 0.5
    },
}
local enemyArray = {}
local obstacles
local obstacleImages = {
    '/assets/images/wood_free.png',
    '/assets/images/stone_free.png'
}

function game.load()
    -- Globals
    points = 0
    startTime = love.timer.getTime()
    snailSpeed = 1000
    enemySpeed = 300
    enemyArray = {}

    local joysticks = love.joystick.getJoysticks()
    if joysticks[1] then
        joystick = joysticks[1]
    end

    local numGrass = 10
    local numMushroom = 10
    local numObstacles = 3

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
    for _ = 1, numObstacles do
        local obstacleImage = love.graphics.newImage(obstacleImages[love.math.random(#obstacleImages)])
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
    elementImgs = {
        "/assets/images/fire_ball.png",
        "/assets/images/water_ball.png",
        "/assets/images/earth_ball.png",
        "/assets/images/air_ball.png"
    }
    currentElement = 1
end

function game.update(dt)
    -- react to key presses
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        mySnail:moveY(snailSpeed * dt)
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        mySnail:moveY(- snailSpeed * dt)
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        mySnail:moveX(- snailSpeed * dt)
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
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
            em = Element.new(mySnail.x, mySnail.y, mx, my,elementImgs[currentElement], currentElement)
            table.insert(elements, {elm = em, time = os.time()})
        else
            time = os.time() - 0.2
            if elements[ems].time < time then
                em = Element.new(mySnail.x, mySnail.y, mx, my,elementImgs[currentElement], currentElement)
                table.insert(elements, {elm = em, time = os.time()})
            end
        end
    end

    function love.wheelmoved(_, y)
        if y > 0 then
            if currentElement == 4 then
                currentElement = 1
            else
                currentElement = currentElement + 1;
            end
        elseif y < 0 then
            if currentElement == 1 then
                currentElement = 4
            else
                currentElement = currentElement - 1;
            end
        end
        mySnail:setColor(currentElement)
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
        startdir =math.random(4)
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

        local enemyType = enemyTypes[math.random(#enemyTypes)]
        table.insert(enemyArray, Enemy.new(
            x,
            y,
            enemyType.image,
            enemyType.stoppableByObstacle,
            enemyType.notKillableBy,
            enemyType.points,
            enemyType.speed
        ))
    end

    for enemyNum, enemy in pairs(enemyArray) do
        -- Check colliding with obstacle
        local currentEnemySpeed = enemySpeed * dt
        local isColliding = true
        local nextEnemyCoordinates = enemy:getNextCoordinates(currentEnemySpeed, mySnail:getX(), mySnail:getY())
        if false == enemy.stoppableByObstacle then
            isColliding = false
        else
            for _ = 1, 5 do
                if (true == isColliding) then
                    currentEnemySpeed = currentEnemySpeed / 2
                    nextEnemyCoordinates = enemy:getNextCoordinates(currentEnemySpeed, mySnail:getX(), mySnail:getY())
                    local enemyData = {
                        image = enemy.image,
                        x = nextEnemyCoordinates.x,
                        y = nextEnemyCoordinates.y
                    }
                    isColliding, _ = areColliding(enemyData, obstacles)
                end
            end
        end
        if (false == isColliding) then
            enemy:move(nextEnemyCoordinates.x, nextEnemyCoordinates.y)
        end

        -- Check colloding with snail
        eWidth, eHeight = enemy.image:getDimensions()

        if enemy.x < (mySnail.x + mySnail.snailWidth)
                and mySnail.x < (enemy.x + eWidth)
                and enemy.y < (mySnail.y + mySnail.snailHeight)
                and mySnail.y < (enemy.y + eHeight)
        then
            return "dead"
        end

        -- Check colliding with Element
        local enemyData = {
            image = enemy.image,
            x = nextEnemyCoordinates.x,
            y = nextEnemyCoordinates.y
        }
        local myElements = {}
        for elementNum, element in ipairs(elements) do
            table.insert(myElements, {
                num = elementNum,
                image = element.elm.image,
                x = element.elm.x,
                y = element.elm.y
            })
        end
        isColliding, colidedWith = areColliding(enemyData, myElements)

        if isColliding then
            if enemyArray[enemyNum].notKillableBy ~= elements[colidedWith].elm.type then
                points = points + enemy.points
                table.remove(enemyArray, enemyNum)
            end
            table.remove(elements, colidedWith)
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

    for _,em in ipairs(elements) do
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

    -- print current Element
    eimg = love.graphics.newImage(elementImgs[currentElement])
    love.graphics.draw(eimg, 0, 100)

    -- Draw Classes
    mySnail:draw()
    for _, enemy in pairs(enemyArray) do
        enemy:draw()
    end
end

function areColliding(enemy, obstaclesArray)
    eWidth, eHeight = enemy.image:getDimensions()

    for colnum, obstacle in pairs(obstaclesArray) do
        oWidth, oHeight = obstacle.image:getDimensions()

        if enemy.x < (obstacle.x + oWidth)
            and obstacle.x < (enemy.x + eWidth)
            and enemy.y < (obstacle.y + oHeight)
            and obstacle.y < (enemy.y + eHeight)
        then
            return true, colnum
        end
    end

    return false, -1
end

return game
