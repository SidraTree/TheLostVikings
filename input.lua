function loadInputConfig ()
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
	menuKeyLagRate = 1
	menuKeyLagTimer = 0
end

function processInput (dt)

    --Movement (keyboard)
    if love.keyboard.isDown("up") then
            player.y = player.y - (player.speed * dt) 
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + (player.speed * dt)
    end
    if love.keyboard.isDown("left") then
        player.x = player.x - (player.speed * dt)
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + (player.speed * dt)
    end
	
	if isTwoPlayerMode then
		if love.keyboard.isDown("w") then
			playerTwo.y = playerTwo.y - (playerTwo.speed * dt) 
		end
		if love.keyboard.isDown("s") then
			playerTwo.y = playerTwo.y + (playerTwo.speed * dt)
		end
		if love.keyboard.isDown("a") then
			playerTwo.x = playerTwo.x - (playerTwo.speed * dt)
		end
		if love.keyboard.isDown("d") then
			playerTwo.x = playerTwo.x + (playerTwo.speed * dt)
		end
	end

	--Menu
	menuKeyLagTimer = menuKeyLagTimer + dt 
    if love.keyboard.isDown("escape") then
        os.exit()
    end
    if love.keyboard.isDown("1") and (menuKeyLagTimer >= menuKeyLagRate) then
		menuKeyLagTimer = menuKeyLagTimer - menuKeyLagRate
        isFullscreen = not isFullscreen
		love.window.setFullscreen(isFullscreen)
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
	keepPlayerInBounds(player)
	if isTwoPlayerMode then keepPlayerInBounds(playerTwo) end

    --Shoot Button
    if love.keyboard.isDown("space") then shoot(player, dt)
	elseif joystick then
		if joystick:isGamepadDown("a") then shoot(player, dt) end 
	end
	
	if isTwoPlayerMode then 
		if love.keyboard.isDown("lctrl") then shoot(playerTwo, dt) end
		--elseif joystick then
			--if joystick:isGamepadDown("a") then shoot(player, dt) end 
		--end	
	end
	
end

function keepPlayerInBounds(player) 
	if player.x < borderSize then player.x = borderSize  end
	if player.x > (love.graphics.getWidth() - player.width - borderSize) then 
		player.x = (love.graphics.getWidth() - player.width - borderSize)
	end
    if player.y < 0 then player.y = 0 end
    if player.y > (love.graphics.getHeight() - player.height) then 
        player.y = (love.graphics.getHeight() - player.height)
    end
end