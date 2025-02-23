function saveConfig()
	gameDatafile = io.open("game/data/game.dat", "w")
	io.output(gameDatafile)
	io.write(highScore, "\n")
	if isFullscreen then io.write("fullscreen") else io.write("window") end
	io.close(gameDatafile)
end

function loadConfig ()
	score_file = io.open("game/data/game.dat", "r")
    io.input(score_file)
    highScore = tonumber(io.read())
	if io.read() == "fullscreen" then isFullscreen = true else isFullscreen = false end
	love.window.setFullscreen(isFullscreen, "exclusive")
    io.close(score_file)
end