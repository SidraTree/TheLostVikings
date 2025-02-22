function loadSounds ()
	startSound = love.audio.newSource("game/sound/start.wav", "static")
    deathSound = love.audio.newSource("game/sound/death.wav", "static")
    playerHitSound = love.audio.newSource("game/sound/phit.wav", "static")
    enemyHitSound = love.audio.newSource("game/sound/ehit.wav", "static")
    playerLaserSound = love.audio.newSource("game/sound/plaser.wav", "static")
    enemyLaserSound = love.audio.newSource("game/sound/elaser.wav", "static")
    music = love.audio.newSource("game/sound/music.mp3", "stream")

    playerHitSound:setVolume(0.2)
    enemyHitSound:setVolume(0.2)
    playerLaserSound:setVolume(0.2)
    enemyLaserSound:setVolume(0.2)
    music:setVolume(0.2)
end

function saveGame()
	gameDatafile = io.open("game/data/game.dat", "w")
	io.output(gameDatafile)
	io.write(highScore, "\n")
	if isFullscreen then io.write("fullscreen") else io.write("window") end
	io.close(gameDatafile)
end

function loadGame ()
	score_file = io.open("game/data/game.dat", "r")
    io.input(score_file)
    highScore = tonumber(io.read())
	if io.read() == "fullscreen" then isFullscreen = true else isFullscreen = false end
	love.window.setFullscreen(isFullscreen)
    io.close(score_file)
end