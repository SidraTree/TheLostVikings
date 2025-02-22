function updateThreatBar()
        threatBarSize = ((love.graphics.getHeight()/100) * threatLevel)
        ltBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, lBorder)
        rtBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, rBorder)
end

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
    if love.keyboard.isDown("space") then shoot(dt)
	elseif joystick then
		if joystick:isGamepadDown("a") then shoot(dt) end 
	end
	
end

function shoot (dt)
	player.fireTimer = player.fireTimer + dt
	if player.fireTimer > player.rof then
		player.fireTimer = player.fireTimer - player.rof
		playerLaserSound:play()
		bullet = {x = (player.x + 65), y = (player.y - 5), size = 10, speed = 450}
		table.insert(bulletQueue,bullet)
	end
end

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

function spawnEnemies(dt)
	spawntimer = spawntimer + dt;
	if spawntimer > spawnRate then
		for i=1,math.random(spawnLevel),1 do
			spawnEnemy(math.random(2),borderSize + 65 + math.random(love.graphics.getWidth() - 130 - (2 * borderSize)), -50)
			spawntimer = 0
		end
	end
end

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

function updateStars(dt)
    for k,v in pairs(starfield) do
        v.y = v.y + (v.speed * dt)
        if v.y > love.graphics.getHeight() then
                v.x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2))
                v.y = 0 - math.random(love.graphics.getHeight())
        end
    end
end

function hitEnemy(enemy)
    --TODO: REMOVE FROM HORDE TABLE ON DEATH
    enemy.alive = false
    enemyHitSound:play()
    table.insert(debris, {x = enemy.x, y = enemy.y, speed = enemy.speed, timer = 1})
    enemy.x = -100
    enemy.y = -100
    score = score + enemy.threat
end

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

function checkPlayerHealth (dt)
	player.iframeTimer = player.iframeTimer - dt
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
end