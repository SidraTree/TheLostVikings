function loadHighScore ()
	score_file = io.open("game/data/hs.dat", "r")
    io.input(score_file)
    highScore = tonumber(io.read())
    io.close(score_file)
end

function loadPlayerData (player)
    player.x = 400
    player.y = 300
    player.speed = 500
    player.width = 126
    player.height = 113
    player.sprite = love.graphics.newImage("game/data/viking.png")
    player.lives = 5
    player.iframeTimer = 0
    player.dmgOffsetX = 0
    player.dmgOffsetY = 0
    player.rof = 0.2
    player.fireTimer = 0
end

function loadSounds ()
	startSound = love.audio.newSource("game/data/start.wav", "static")
    deathSound = love.audio.newSource("game/data/death.wav", "static")
    playerHitSound = love.audio.newSource("game/data/phit.wav", "static")
    enemyHitSound = love.audio.newSource("game/data/ehit.wav", "static")
    playerLaserSound = love.audio.newSource("game/data/plaser.wav", "static")
    enemyLaserSound = love.audio.newSource("game/data/elaser.wav", "static")
    music = love.audio.newSource("game/data/music.mp3", "stream")

    playerHitSound:setVolume(0.2)
    enemyHitSound:setVolume(0.2)
    playerLaserSound:setVolume(0.2)
    enemyLaserSound:setVolume(0.2)
    music:setVolume(0.2)
end

function loadUIGraphics ()
	lBorder = love.graphics.newImage("game/data/lbar.png")
    rBorder = love.graphics.newImage("game/data/rbar.png")
	borderSize = 66
	
    threatBarSize = 0
    ltBar = love.graphics.newQuad(0, 0, 0, 0, lBorder)
    rtBar = love.graphics.newQuad(0, 0, 0, 0, rBorder)

    hbar = love.graphics.newImage("game/data/hbar5.png")
    p2bar = love.graphics.newImage("game/data/p2.png")

    menu = love.graphics.newImage("game/data/menu.png")
    gameOverScreen = love.graphics.newImage("game/data/gameover.jpg")
end

function loadStarfield ()
	starfield = {}
    for i = 1,250,1 do
        table.insert(starfield, 
            {
                x = borderSize + math.random(love.graphics.getWidth() - (borderSize * 2)),
                y = math.random(love.graphics.getHeight()),
                speed = (math.random(300) + 200),
                size = (math.random(2))
            })
    end
end