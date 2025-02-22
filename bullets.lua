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
                            hbar = love.graphics.newImage("game/png/hbar" .. player.lives ..".png") 
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

function drawBullets()
    love.graphics.setColor(0,100,255)
    for k,v in pairs(bulletQueue) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end

function drawEnemyBullets()
    love.graphics.setColor(255,0,0)
    for k,v in pairs(hordeBullets) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end