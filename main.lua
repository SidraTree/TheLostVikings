--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]
--Lost Vikings VI                                                  
--[[---------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------]]
require "bullets"
require "config"
require "enemy"
require "input"
require "player"
require "sounds"
require "starfield"
require "ui"

function love.load(args, unfilteredArgs)
    love.window.setTitle("The Lost Vikings VI")
	icon = love.image.newImageData("game/png/olaf.png")
	love.window.setIcon(icon)
	
	gameOver = false
	gameStart = false
	threatLevel = 0
	
    player = {}
	horde = {}
	loadPlayerData(player)
	loadEnemyData ()
	
	--bullets
    hordeBullets = {}
    bulletQueue = {}
	
	loadConfig()
	loadInputConfig ()
	loadSounds()
	loadUI()
	loadStarfield()
	
end

function love.update(dt)
    if gameStart == true then
		if not music:isPlaying() then music:play() end
		
		spawnEnemies(dt)
        processPlayerBullets(dt)
        processEnemyBullets(dt)
        updateHorde(dt)
        processInput(dt)
        updateStarfield(dt)
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
        drawStarfield()
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