function loadInputConfig ()
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
	menuKeyLagRate = 1
	menuKeyLagTimer = 0
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