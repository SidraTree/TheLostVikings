function drawPlayer()
    love.graphics.draw(player.sprite, player.x, player.y)

    if (player.iframeTimer > 0) then
        love.graphics.draw(playerDebris, (player.x + player.dmgOffsetX), (player.y + player.dmgOffsetY))
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

function drawStars()
    love.graphics.setColor(255,255,255)
    for k,v in pairs(starfield) do
        love.graphics.circle("fill", v.x, v.y, v.size)
    end
end

function drawUI ()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(lBorder)
	love.graphics.draw(rBorder, love.graphics.getWidth() - borderSize, 0)
	love.graphics.draw(hbar, borderSize, love.graphics.getHeight() - 66)
	love.graphics.draw(p2bar, 618, 534)
	love.graphics.setColor(255,0,0)
	love.graphics.draw(lBorder, ltBar, 0, 0)
	love.graphics.draw(rBorder, rtBar, love.graphics.getWidth() - borderSize, 0)
end

function drawGameOver ()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(gameOverScreen)
	love.graphics.print("Your Score: " .. score, 160, 450, 0, 3, 3)
	love.graphics.print("High Score: " .. highScore, 160, 500, 0, 3, 3)
end

function drawStartScreen ()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(menu)
end