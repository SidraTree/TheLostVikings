--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]
--Lost Vikings VI                                                  
--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]
require "draw"
require "load"
require "update"

function love.load(args, unfilteredArgs)

    love.window.setTitle("The Lost Vikings VI")
	icon = love.image.newImageData("game/png/olaf.png")
	love.window.setIcon(icon)
	
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
	
	loadHighScore()
	loadSounds()
	loadUIGraphics()
	loadStarfield()
	
    player = {}
	loadPlayerData(player)

    enemyDebris = love.graphics.newImage("game/png/eDmg.png")
    playerDebris = love.graphics.newImage("game/png/pDmg.png")

    gameOver = false
	gameStart = false
	
    bulletQueue = {}
    horde = {}
    debris = {}
    hordeBullets = {}
	
    spawnRate = 1
    spawnLevel = 3
	spawntimer = 0;
    threatLevel = 0

end

function love.update(dt)
    if gameStart == true then
		if not music:isPlaying() then music:play() end
		
		spawnEnemies(dt)
        processPlayerBullets(dt)
        processEnemyBullets(dt)
        updateHorde(dt)
        processInput(dt)
        updateStars(dt)
		updateThreatBar()
		checkPlayerHealth(dt)

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

function love.draw() 
    if gameStart == true then
        drawStars()
        drawPlayer()
        drawHorde()
        drawEnemyBullets()
        drawBullets()
        drawUI()
    else
        if gameOver == true then
			drawGameOver()
        else   
            drawStartScreen()
        end
    end
end