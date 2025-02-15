--[[-----------------------------------------------------
PROJCT VIKING
-Sprite
--Animatable Sprites
------------------------------------------------------]]--

facing = {
	north = {},
	northwest = {},
	northeast = {},
	south = {},
	southwest = {},
	southeast = {},
	east = {},
	west = {}
	}

function createSprite (aImage, aX, aY, aSpeed, aRotation)
	
	return {image = love.graphics.newImage(aImage), x = aX, y = aY, speed = aSpeed}
end

function drawSprite (sprite)
	love.graphics.draw(sprite.image, sprite.x, sprite.y)
end

function moveSprite(aSprite, aFacing, dt)
	if aFacing == facing.north then
		aSprite.y = aSprite.y - (aSprite.speed * dt)
	elseif aFacing == facing.northwest then
		aSprite.x = aSprite.x - (aSprite.speed * dt)
		aSprite.y = aSprite.y - (aSprite.speed * dt)
	elseif aFacing == facing.northeast then
		aSprite.x = aSprite.x + (aSprite.speed * dt)
		aSprite.y = aSprite.y - (aSprite.speed * dt)
	elseif aFacing == facing.south then
		aSprite.y = aSprite.y + (aSprite.speed * dt)
	elseif aFacing == facing.southwest then
		aSprite.x = aSprite.x - (aSprite.speed * dt)
		aSprite.y = aSprite.y + (aSprite.speed * dt)
	elseif aFacing == facing.southeast then
		aSprite.x = aSprite.x + (aSprite.speed * dt)
		aSprite.y = aSprite.y + (aSprite.speed * dt)
	elseif aFacing == facing.west then
		aSprite.x = aSprite.x - (aSprite.speed * dt)
	elseif aFacing == facing.east then
		aSprite.x = aSprite.x + (aSprite.speed * dt)
	end
	
end