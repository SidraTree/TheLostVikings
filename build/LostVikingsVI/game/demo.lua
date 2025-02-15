--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]
--Operation Skyhook: Phase 2                                                   
--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]


--[[---------------------------------------------------------------------------]]
--    LOAD       
--[[---------------------------------------------------------------------------]]
function love.load(args, unfilteredArgs)

    love.window.setTitle("The Lost Vikings VI")
	icon = love.image.newImageData("game/data/olaf.png")
	love.window.setIcon(icon)

    player = {}
    player.x = 400
    player.y = 300
    player.speed = 500
    player.width = 126
    player.height = 113
    player.sprite = love.graphics.newImage("game/data/viking.png")
    player.lives = 5
    player.iframeTimer = 0
    player.dmgOffsetX = 0
    player.dmgOffsetY = 0
    player.rof = 0.2
    player.fireTimer = 0

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    enemyDebris = love.graphics.newImage("game/data/eDmg.png")
    playerDebris = love.graphics.newImage("game/data/pDmg.png")

    gameOver = false
    threatLevel = 0
    bulletQueue = {}
    horde = {}
    debris = {}
    hordeBullets = {}
    spawntimer = 0;
    gameStart = false

    spawnRate = 1
    spawnLevel = 3

    lBorder = love.graphics.newImage("game/data/lbar.png")
    rBorder = love.graphics.newImage("game/data/rbar.png")

    threatBarSize = 0
    ltBar = love.graphics.newQuad(0, 0, 0, 0, lBorder)
    rtBar = love.graphics.newQuad(0, 0, 0, 0, rBorder)

    hbar = love.graphics.newImage("game/data/hbar5.png")
    p2bar = love.graphics.newImage("game/data/p2.png")

    score_file = io.open("game/data/hs.dat", "r")
    io.input(score_file)
    highScore = tonumber(io.read())
    io.close(score_file)

    startSound = love.audio.newSource("game/data/start.wav", "static")
    deathSound = love.audio.newSource("game/data/death.wav", "static")
    playerHitSound = love.audio.newSource("game/data/phit.wav", "static")
    enemyHitSound = love.audio.newSource("game/data/ehit.wav", "static")
    playerLaserSound = love.audio.newSource("game/data/plaser.wav", "static")
    enemyLaserSound = love.audio.newSource("game/data/elaser.wav", "static")
    music = love.audio.newSource("game/data/music.mp3", "stream")

    playerHitSound:setVolume(0.2)
    enemyHitSound:setVolume(0.2)
    playerLaserSound:setVolume(0.2)
    enemyLaserSound:setVolume(0.2)
    music:setVolume(0.2)

    borderSize = 66
    starfield = {}
    for i = 1,250,1 do
        table.insert(starfield, 
            {
                x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2)),
                y = math.random(love.graphics.getHeight()),
                speed = (math.random(300) + 200),
                size = (math.random(2))
            })
    end

    menu = love.graphics.newImage("game/data/menu.png")
    gameOverScreen = love.graphics.newImage("game/data/gameover.jpg")

end

--[[---------------------------------------------------------------------------]]
--    UPDATE                                                  
--[[---------------------------------------------------------------------------]]
function love.update(dt)
    if gameStart == true then

        if not music:isPlaying() then music:play() end

        spawntimer = spawntimer + dt;
        if spawntimer > spawnRate then
            for i=1,math.random(spawnLevel),1 do
                spawnEnemy(math.random(2),borderSize + 65 + math.random(love.graphics.getWidth() - 130 - (2 * borderSize)), -50)
                spawntimer = 0
            end
        end

        player.iframeTimer = player.iframeTimer - dt

        processPlayerBullets(dt)
        processEnemyBullets(dt)
        updateHorde(dt)
        processInput(dt)
        updateStars(dt)

        threatBarSize = ((love.graphics.getHeight()/100) * threatLevel)
        ltBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, lBorder)
        rtBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, rBorder)


        if (player.lives < 0) or (threatLevel >= 100) then

            if score > highScore then
                highScore = score
                score_file = io.open("game/data/hs.dat", "w")
                io.output(score_file)
                io.write(highScore)
                io.close(score_file)
            end
            love.load()
            gameOver = true
            deathSound:play()
        end

    elseif love.keyboard.isDown("return") then 
        startSound:play()
        gameStart = true 
		score = 0
        gameOver = false
    
	
	elseif joystick then
		if joystick:isGamepadDown("start") then 
			startSound:play()
			gameStart = true 
			score = 0
			gameOver = false
		end
	end
	
end


--[[---------------------------------------------------------------------------]]
--    DRAW                                                   
--[[---------------------------------------------------------------------------]]
function love.draw() 
    if gameStart == true then
        drawStars()
        love.graphics.print("Threat level: " .. threatLevel .. "% | Score: " .. score,borderSize,0)
        drawPlayer()
        drawHorde()
        drawEnemyBullets()
        drawBullets()
        love.graphics.setColor(255,255,255)
        love.graphics.draw(lBorder)
        love.graphics.draw(rBorder, love.graphics.getWidth() - borderSize, 0)
        love.graphics.draw(hbar, borderSize, love.graphics.getHeight() - 66)
        love.graphics.draw(p2bar, 618, 534)
        love.graphics.setColor(255,0,0)
        love.graphics.draw(lBorder, ltBar, 0, 0)
        love.graphics.draw(rBorder, rtBar, love.graphics.getWidth() - borderSize, 0)

    else
        if gameOver == true then

            love.graphics.setColor(255,255,255)
            love.graphics.draw(gameOverScreen)
            love.graphics.print("Your Score: " .. score, 160, 450, 0, 3, 3)
            love.graphics.print("High Score: " .. highScore, 160, 500, 0, 3, 3)
        else   
            love.graphics.setColor(255,255,255)
            love.graphics.draw(menu)
        end
    end
end

--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]


--[[---------------------------------------------------------------------------]]
--                        Supporting Functions                                 
--[[---------------------------------------------------------------------------]]

--[[---------------------------------------------------------------------------]]
--     INPUT
--[[---------------------------------------------------------------------------]]
function processInput (dt)

    --Movement (keyboard)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            player.y = player.y - (player.speed * dt) 
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        player.y = player.y + (player.speed * dt)
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.x = player.x - (player.speed * dt)
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + (player.speed * dt)
    end

	--Movement(Gamepad)
	if joystick then 
		if not (joystick:getGamepadAxis("lefty") == 0) then
				player.y = player.y + (player.speed * dt * joystick:getGamepadAxis("lefty"))
		end
		if not (joystick:getGamepadAxis("leftx") == 0) then
				player.x = player.x + (player.speed * dt * joystick:getGamepadAxis("leftx"))
		end
	end

    --Border Patrol
    if player.x < borderSize then player.x = borderSize  end
    if player.x > (love.graphics.getWidth() - player.width - borderSize) then 
        player.x = (love.graphics.getWidth() - player.width - borderSize)
    end

    if player.y < 0 then player.y = 0 end
    if player.y > (love.graphics.getHeight() - player.height) then 
        player.y = (love.graphics.getHeight() - player.height)
    end

    --Shoot Button
    if love.keyboard.isDown("space") then
        player.fireTimer = player.fireTimer + dt
        if player.fireTimer > player.rof then
            player.fireTimer = player.fireTimer - player.rof
            playerLaserSound:play()
            bullet = {x = (player.x + 65), y = (player.y - 5), size = 10, speed = 450}
            table.insert(bulletQueue,bullet)
        end
    end
	
	if joystick then
		if  joystick:isGamepadDown("a") then
			player.fireTimer = player.fireTimer + dt
			if player.fireTimer > player.rof then
				player.fireTimer = player.fireTimer - player.rof
				playerLaserSound:play()
				bullet = {x = (player.x + 65), y = (player.y - 5), size = 10, speed = 450}
				table.insert(bulletQueue,bullet)
			end
		end
	end
	
end

--[[---------------------------------------------------------------------------]]
--    SPAWN ENEMY                                                
--[[---------------------------------------------------------------------------]]
function spawnEnemy(type, x, y)
    if x == nil then x = 400 end
    if y == nil then y = -100 end

    local enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.alive = true

    --mutalisk
    if type == 1 then 
        enemy.sprite = love.graphics.newImage("game/data/mutalisk.png")
        enemy.width = 50
        enemy.height = 50
        enemy.speed = 250
        enemy.shotSpeed = 325
        enemy.threat = 5
        enemy.shotTimer = 0.8
        enemy.rof = 1
    --overlord
    elseif type == 2 then 
        enemy.sprite = love.graphics.newImage("game/data/overlord.png")
        enemy.width = 58
        enemy.height = 78
        enemy.speed = 300
        enemy.shotSpeed = 375
        enemy.threat = 10
        enemy.shotTimer = 0.5
        enemy.rof = 0.8
    end 

    table.insert(horde, enemy)
end

--[[---------------------------------------------------------------------------]]
--    UPDATE HORDE                                                
--[[---------------------------------------------------------------------------]]
function updateHorde(dt)
    --TODO: IMPLEMENT MOVEMENT PATTERNS

    for k,v in pairs(debris) do
        v.timer = v.timer - dt
        v.y = v.y + (v.speed * dt)
    end

    for k,v in pairs(horde) do
        if v.alive then
            v.y = v.y + (v.speed * dt)
            if v.y > love.graphics.getHeight() then
                v.alive = false
                threatLevel = threatLevel + v.threat
            end
        end

        v.shotTimer = v.shotTimer + dt
        if v.shotTimer > v.rof then
            enemyLaserSound:play()
            v.shotTimer = v.shotTimer - v.rof
            table.insert(hordeBullets, {x = v.x + (v.width/2), y = v.y + v.height, size = 8, speed = v.shotSpeed, alive = true})
        end
    end

end

--[[---------------------------------------------------------------------------]]
--    UPDATE STARS                                            
--[[---------------------------------------------------------------------------]]
function updateStars(dt)
    for k,v in pairs(starfield) do
        v.y = v.y + (v.speed * dt)
        if v.y > love.graphics.getHeight() then
                v.x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2))
                v.y = 0 - math.random(love.graphics.getHeight())
        end
    end
end

--[[---------------------------------------------------------------------------]]
--    HIT ENEMY                                            
--[[---------------------------------------------------------------------------]]
function hitEnemy(enemy)
    --TODO: REMOVE FROM HORDE TABLE ON DEATH
    enemy.alive = false
    enemyHitSound:play()
    table.insert(debris, {x = enemy.x, y = enemy.y, speed = enemy.speed, timer = 1})
    enemy.x = -100
    enemy.y = -100
    score = score + enemy.threat
end

--[[---------------------------------------------------------------------------]]
--    PROCESS PLAYER BULLETS                                                
--[[---------------------------------------------------------------------------]]
function processPlayerBullets(dt)

    --player bullets first
    local collisions = {}

    -- for each bullet
    for bulley_key, bullet in pairs(bulletQueue) do
        --check against each ship
         for enemy_key, enemy in pairs(horde) do
            --collision calculation
            if (bullet.x > enemy.x - bullet.size) and (bullet.x < (enemy.x + enemy.width + bullet.size)) and
                (bullet.y > enemy.y - bullet.size) and (bullet.y < (enemy.y + enemy.height + bullet.size)) then
                    hitEnemy(enemy)
                    bullet.x = -300 -- yeet this until time to remove it
            end
        end
        --update the bullet for the next pass
        bullet.y = bullet.y - (bullet.speed * dt)
    end

    --TODO: REMOVE OLD BULLETS
end

--[[---------------------------------------------------------------------------]]
--    PROCESS ENEMY BULLETS                                                
--[[---------------------------------------------------------------------------]]
function processEnemyBullets(dt)
    for k,v in pairs(hordeBullets) do
        v.y = v.y + (v.speed * dt)

            if (v.x > player.x - v.size) and (v.x < (player.x + player.width + v.size)) and
                (v.y > player.y - v.size + 40) and (v.y < (player.y + (player.height/2) + v.size)) then
                    if player.iframeTimer <= 0 then
                        player.lives = player.lives - 1
                        playerHitSound:play()
                        if player.lives >= 0 then 
                            hbar = love.graphics.newImage("game/data/hbar" .. player.lives ..".png") 
                        end
                        player.dmgOffsetX = v.x - player.x - 50
                        player.dmgOffsetY = v.y - player.y - 30
                        player.iframeTimer =  1
                        v.alive = false
                        v.x = -500 --yeet until I can dispose properly
                    end
            end
    end
end

--[[---------------------------------------------------------------------------]]
--    DRAW PLAYER                                                  
--[[---------------------------------------------------------------------------]]
function drawPlayer()
    love.graphics.draw(player.sprite, player.x, player.y)

    if (player.iframeTimer > 0) then
        love.graphics.draw(playerDebris, (player.x + player.dmgOffsetX), (player.y + player.dmgOffsetY))
    end

end

--[[---------------------------------------------------------------------------]]
--    DRAW HORDE                                                    
--[[---------------------------------------------------------------------------]]
function drawHorde()
    for k,v in pairs(horde) do
        if v.alive then
            love.graphics.draw(v.sprite, v.x, v.y)
        end
    end
    for k,v in pairs(debris) do
        if v.timer > 0 then
            love.graphics.draw(enemyDebris, v.x, v.y)
        end
    end

end

--[[---------------------------------------------------------------------------]]
--    DRAW BULLETS                                                    
--[[---------------------------------------------------------------------------]]
function drawBullets()
    love.graphics.setColor(0,100,255)
    for k,v in pairs(bulletQueue) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end

--[[---------------------------------------------------------------------------]]
--    DRAW ENEMY BULLETS                                                    
--[[---------------------------------------------------------------------------]]
function drawEnemyBullets()
    love.graphics.setColor(255,0,0)
    for k,v in pairs(hordeBullets) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end

--[[---------------------------------------------------------------------------]]
--    DRAW STARS                                                    
--[[---------------------------------------------------------------------------]]
function drawStars()
    love.graphics.setColor(255,255,255)
    for k,v in pairs(starfield) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end