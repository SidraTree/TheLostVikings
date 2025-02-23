function loadPlayerData (player)
    player.x = 800
    player.y = 300
    player.speed = 500
    player.width = 126
    player.height = 113
    player.sprite = love.graphics.newImage("game/png/viking.png")
    player.lives = 5
    player.iframeTimer = 0
    player.dmgOffsetX = 0
    player.dmgOffsetY = 0
    player.rof = 0.2
    player.fireTimer = 0
	player.debris = love.graphics.newImage("game/png/pDmg.png")
end

function drawPlayer(player)
    love.graphics.draw(player.sprite, player.x, player.y)

    if (player.iframeTimer > 0) then
        love.graphics.draw(player.debris, (player.x + player.dmgOffsetX), (player.y + player.dmgOffsetY))
    end

end

function shoot (player, dt)
	player.fireTimer = player.fireTimer + dt
	if player.fireTimer > player.rof then
		player.fireTimer = player.fireTimer - player.rof
		playerLaserSound:play()
		bullet = {x = (player.x + 65), y = (player.y - 5), size = 10, speed = 450}
		table.insert(bulletQueue,bullet)
	end
end