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
	
	if not setRes then
		setRes = true
		love.window.setMode(1280,720)
		gameOver = false
	end
	
	gameStart = false
	
	isTwoPlayerMode = true
	
    player = {}
	loadPlayerData(player)
	if isTwoPlayerMode then
		playerTwo = {}
		loadPlayerData(playerTwo)
		playerTwo.x = 400
	end
	
	horde = {}
	loadEnemyData ()
	
	--bullets
    hordeBullets = {}
    bulletQueue = {}
	
	debris = {}
	
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
		checkGameOver(player, dt)
		if isTwoPlayerMode then checkGameOver(playerTwo, dt) end

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
        drawPlayer(player)
		if isTwoPlayerMode then drawPlayer(playerTwo) end
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

--------------------------------------------------------------------------

function checkGameOver (player, dt)
	player.iframeTimer = player.iframeTimer - dt
	if (player.lives < 0) or (threatLevel >= 100) then
		if score > highScore then
			highScore = score
		end
		deathSound:play()
		saveConfig()
		gameOver = true
		love.load()
	end
end