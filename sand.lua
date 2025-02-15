--[[-----------------------------------------------------
THE LOST VIKINGS
------------------------------------------------------]]--

require "sprite"

function love.load(args, unfilteredArgs)
	
	love.window.setTitle("Lost Vikings")
	sViking = createSprite("data/viking.png",400,300,300)
	
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
	

end

function love.update(dt)
	
	
	if love.keyboard.isDown("up") then
		moveSprite(sViking, facing.north, dt)
	end
	
	if love.keyboard.isDown("down") then
		moveSprite(sViking, facing.south, dt)
	end
	
	if love.keyboard.isDown("left") then
		moveSprite(sViking, facing.west, dt)
	end
	
	if love.keyboard.isDown("right") then
		moveSprite(sViking, facing.east, dt)
	end
	
	
	if not (joystick:getGamepadAxis("lefty") == 0) then
		moveSprite(sViking, facing.north, dt * joystick:getGamepadAxis("lefty") * -1)
	end
	
	
	if not (joystick:getGamepadAxis("leftx") == 0) then
		moveSprite(sViking, facing.west, dt * joystick:getGamepadAxis("leftx") * -1)
	end

	
end

function love.draw() 
	drawSprite(sViking)
end