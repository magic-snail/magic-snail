game = {}

require 'src.snail'
require 'src.enemy'
require 'src.element'

local joystick
local points
local startTime
local snailSpeed
local enemySpeed
local backgroundArray
local backgroundElementsArray
local mySnail
local chanceOfNewEnemy = 50
local isFirering = false
local enemyTypes = {
    {
        image = '/assets/images/enemies/golem.png',
        stoppableByObstacle = true,
        notKillableBy = "earth",
        points = 10,
        speed = 0.6
    },
    {
        image = '/assets/images/enemies/blackbird.png',
        stoppableByObstacle = false,
        notKillableBy = "air",
        points = 30,
        speed = 1
    },
    {
        image = '/assets/images/enemies/hedgehog.png',
        stoppableByObstacle = true,
        notKillableBy = "fire",
        points = 10,
        speed = 0.7
    },
    {
        image = '/assets/images/enemies/turtle.png',
        stoppableByObstacle = true,
        notKillableBy = "water",
        points = 10,
        speed = 0.5
    },
}
local enemyArray = {}
local obstacles
local obstacleImages = {
    '/assets/images/obstacles/wood.png',
    '/assets/images/obstacles/stone.png'
}
local magicStars
local elementImages = {
    "/assets/images/elements/fire.png",
    "/assets/images/elements/water.png",
    "/assets/images/elements/earth.png",
    "/assets/images/elements/air.png"
}
local currentElement
local hitGoodSound
local hitBadSound
local spellSound

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

    magicStars = newAnimation(love.graphics.newImage("/assets/images/snail/stars_sprite.png"), 128, 128, 1)

    -- base background image
    local myBackground = love.graphics.newImage("/assets/images/backgrounds/green.png")
    local myBackgroundWidth = myBackground:getWidth()
    local myBackgroundHeight = myBackground:getHeight()
    local myMagicBackground = love.graphics.newImage("/assets/images/backgrounds/green_stars.png")
    backgroundArray = {}
    for i = 0, love.graphics.getWidth() / myBackgroundWidth do
        for j = 0, love.graphics.getHeight() / myBackgroundHeight do
            local currentImage = myBackground
            if love.math.random(20) == 1 then
                currentImage = myMagicBackground
            end
            table.insert(backgroundArray, {
                image = currentImage,
                x = i * myBackgroundWidth,
                y = j * myBackgroundHeight
            })
        end
    end

    -- add background elements
    local myBackgroundGrass = love.graphics.newImage("/assets/images/backgrounds/grass.png")
    local myBackgroundMush= love.graphics.newImage("/assets/images/backgrounds/mushroom.png")
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

    -- add snail
    mySnail = Snail.new(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2
    )

    elements = {}
    currentElement = 1

    -- sound effects
    hitGoodSound = love.audio.newSource(
        '/assets/music/188564__deleted-user-3330286__enemydeath-thm-adventure.mp3', 'static'
    )
    hitBadSound = love.audio.newSource('/assets/music/hit.ogg', 'static')
    spellSound = love.audio.newSource('/assets/music/77691__joelaudio__sfx-magic-fireball-001.wav', 'static')
    for i, enemyType in ipairs(enemyTypes) do
        if enemyType.notKillableBy == 'earth' then
            enemyTypes[i].sound = love.audio.newSource('/assets/music/103575__ryansnook__growl3.wav', 'static')
        elseif enemyType.notKillableBy == 'air' then
            enemyTypes[i].sound = love.audio.newSource(
                '/assets/music/33548__reinsamba__miaowing-blackbird2.wav', 'static'
            )
        elseif enemyType.notKillableBy == 'water' then
            enemyTypes[i].sound = love.audio.newSource(
                '/assets/music/386884__connorm94__wading-through-water.wav', 'static'
            )
        elseif enemyType.notKillableBy == 'fire' then
            enemyTypes[i].sound = love.audio.newSource('/assets/music/106131__j1987__leafrustle.wav', 'static')
        end
    end
end

function game.update(dt)
    isFirering = false
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
            em = Element.new(mySnail.x + 50, mySnail.y + 50, mx, my,elementImages[currentElement], currentElement)
            table.insert(elements, {elm = em})
            love.audio.play(spellSound:clone())
        end
        isFirering = true
    end

    -- Stars Animation
    magicStars.currentTime = magicStars.currentTime + dt
    if magicStars.currentTime >= magicStars.duration then
        magicStars.currentTime = magicStars.currentTime - magicStars.duration
    end

    if love.keyboard.isDown("1") then
        currentElement = 1
        mySnail:setColor(currentElement)
    end
    if love.keyboard.isDown("2") then
        currentElement = 2
        mySnail:setColor(currentElement)
    end
    if love.keyboard.isDown("3") then
        currentElement = 3
        mySnail:setColor(currentElement)
    end
    if love.keyboard.isDown("4") then
        currentElement = 4
        mySnail:setColor(currentElement)
    end

    for i,em in ipairs(elements) do
        em.elm:update(1000 * dt)
        if em.elm.x > love.graphics.getWidth() or em.elm.x < 0 or
                em.elm.y > love.graphics.getHeight() or em.elm.y < 0 then
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
        love.audio.play(enemyType.sound:clone())
    end

    for enemyNum, enemy in pairs(enemyArray) do
        -- Check colliding with obstacle
        local currentEnemySpeed = (enemySpeed * dt) * enemy.speed
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

        if enemy.x < (mySnail.x + mySnail.snailWidth - 30)
                and mySnail.x < (enemy.x + eWidth - 30)
                and enemy.y < (mySnail.y + mySnail.snailHeight - 30)
                and mySnail.y < (enemy.y + eHeight - 30)
        then
            return "dead", points
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
                love.audio.play(hitGoodSound:clone())
            else
                love.audio.play(hitBadSound:clone())
            end
            table.remove(elements, colidedWith)
        end
    end

    return "game"
end

function game.advandeToNextElement()
    if currentElement == 4 then
        currentElement = 1
    else
        currentElement = currentElement + 1;
    end

    mySnail:setColor(currentElement)
end

function game.advandeToPreviousElement()
    if currentElement == 1 then
        currentElement = 4
    else
        currentElement = currentElement - 1;
    end

    mySnail:setColor(currentElement)
end

function game.draw()
    -- Draw background image
    for _, data in pairs(backgroundArray) do
        love.graphics.draw(data.image, data.x, data.y)
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

    -- print Infos
    love.graphics.setNewFont(30)
    love.graphics.print("Points: " .. string.format("%05d", points), 0, 0)
    love.graphics.print(
        "Time: " .. string.format("%04d", math.floor(love.timer.getTime() - startTime)),
        love.graphics.getWidth()-200,
        0
    )

    -- draw Animations
    if isFirering then
        local spriteNum = math.floor(magicStars.currentTime / magicStars.duration * #magicStars.quads) + 1
        love.graphics.draw(magicStars.spriteSheet, magicStars.quads[spriteNum], mySnail.x, mySnail.y - 110)
    end

    -- Draw Classes
    mySnail:draw()
    for _, enemy in pairs(enemyArray) do
        enemy:draw()
    end
end

function areColliding(enemy, obstaclesArray)
    eWidth, eHeight = enemy.image:getDimensions()

    for colNum, obstacle in pairs(obstaclesArray) do
        oWidth, oHeight = obstacle.image:getDimensions()

        if enemy.x < (obstacle.x + oWidth)
            and obstacle.x < (enemy.x + eWidth)
            and enemy.y < (obstacle.y + oHeight)
            and obstacle.y < (enemy.y + eHeight)
        then
            return true, colNum
        end
    end

    return false, -1
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

return game
