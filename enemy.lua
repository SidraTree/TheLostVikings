function loadEnemyData ()
	spawnRate = 1
    spawnLevel = 3
	spawntimer = 0
	threatLevel = 0
	enemyDebris = love.graphics.newImage("game/png/eDmg.png")
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
        enemy.sprite = love.graphics.newImage("game/png/mutalisk.png")
        enemy.width = 50
        enemy.height = 50
        enemy.speed = 250
        enemy.shotSpeed = 325
        enemy.threat = 5
        enemy.shotTimer = 0.8
        enemy.rof = 1
    --overlord
    elseif type == 2 then 
        enemy.sprite = love.graphics.newImage("game/png/overlord.png")
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

function hitEnemy(enemy)
    enemy.alive = false
    enemyHitSound:play()
    table.insert(debris, {x = enemy.x, y = enemy.y, speed = enemy.speed, timer = 1})
    enemy.x = -100
    enemy.y = -100
    score = score + enemy.threat
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

function updateHorde(dt)
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