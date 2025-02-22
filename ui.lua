function loadUI ()
	lBorder = love.graphics.newImage("game/png/lbar.png")
    rBorder = love.graphics.newImage("game/png/rbar.png")
	borderSize = 66
		
	font = love.graphics.setNewFont(40)
	
	debris = {}
	enemyDebris = love.graphics.newImage("game/png/eDmg.png")
    playerDebris = love.graphics.newImage("game/png/pDmg.png")
	
    threatBarSize = 0
    ltBar = love.graphics.newQuad(0, 0, 0, 0, lBorder)
    rtBar = love.graphics.newQuad(0, 0, 0, 0, rBorder)

    hbar = love.graphics.newImage("game/png/hbar5.png")
    p2bar = love.graphics.newImage("game/png/p2.png")

    menu = love.graphics.newImage("game/png/menu.png")
    gameOverScreen = love.graphics.newImage("game/png/gameover.png")
end

function updateThreatBar()
	threatBarSize = ((love.graphics.getHeight()/100) * threatLevel)
	ltBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, lBorder)
	rtBar = love.graphics.newQuad(0, 0, borderSize, threatBarSize, rBorder)
end

function drawUI ()
	local borderWidth, borderHeight = rBorder:getDimensions()
	local p2barWidth, p2barHeight = p2bar:getDimensions()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(lBorder,0,0,0,1,love.graphics.getHeight()/borderHeight)
	love.graphics.draw(rBorder, love.graphics.getWidth() - borderSize, 0, 0, 1, love.graphics.getHeight()/borderHeight)
	love.graphics.draw(hbar, borderSize, love.graphics.getHeight() - borderSize)
	love.graphics.draw(p2bar,love.graphics.getWidth() - borderSize - p2barWidth, love.graphics.getHeight() - borderSize)
	love.graphics.setColor(255,0,0)
	love.graphics.draw(lBorder, ltBar, 0, 0)
	love.graphics.draw(rBorder, rtBar, love.graphics.getWidth() - borderSize, 0)
end

function drawGameOver ()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(gameOverScreen)
	love.graphics.print("Your Score: " .. score, 160, 450, 0)
	love.graphics.print("High Score: " .. highScore, 160, 500, 0)
end

function drawStartScreen ()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(menu)
end