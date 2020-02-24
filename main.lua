-- There's probably not a single line of code in this game that I am proud of lol. Everything is rushed and messy and uncommented.
-- But that is the job of a jam I guess? Trying to read this is going to be a nightmare and I warn you now to not put yourself
-- through that pain. But if you decide to anything, I wish you luck my friend!
-- Cahce
local soundData
sampleIndex = {}
local vx, vy
ENEMIES = {}
local lastenemy = 0
fonts = {}
beamAngle = 0
ALLBUTTONS = {}

-- Libs
require("hooks")
require("player")
require("enemy")
require("beam")
require("button")

GAME = {}
GAME.credits = 0
GAME.lives = 5
GAME.round = 1
GAME.state = "menu"
GAME.thisRound = {
	maxEnemies = 5,
	totalEnemies = 0,
	totalEnemiesToEnd = 10,
	spawnRate = 3
}





function love.load()
	-- Load window size
--	love.window.setMode(480, 800)
	
	-- Load entities
	BEAM:Int()
	PLAYER:Int()

	-- Load sound info
	sound = love.audio.newSource("songs/base.mp3", "stream")
	sound:setLooping(true)
	love.audio.setVolume(0.1)
	sound:play()
	soundData = love.sound.newSoundData("songs/base.mp3")
--	sound:setPitch(2)
--	love.audio.play(sound)

	for i=0, soundData:getSampleCount() do
		sampleIndex[i] = soundData:getSample(i)
	end

	-- Other
	fonts.header = love.graphics.newFont("assets/bebas_neue.ttf", 140)
	fonts.button = love.graphics.newFont("assets/bebas_neue.ttf", 26)
	fonts.main = love.graphics.newFont("assets/bebas_neue.ttf", 20)
	love.graphics.setFont(fonts.main)


	local btn = CreateButton("Start Round", function()
		GAME.state = "active"
		BEAM.onCooldown = true
		BEAM.timer = 1.5
	end, "Menu")
	local w, h = love.graphics.getDimensions()
	btn.y = h - btn.tall - 10

	local i = 0
	for k, v in pairs(BEAM.stats) do
		i = i + 1
		local btn = CreateButton("+", function(self)
			if GAME.credits == 0 then return end

			GAME.credits = GAME.credits - 1
			BEAM.stats[k] = BEAM.stats[k] + BEAM.statsSteps[k]

			if BEAM.stats[k] == BEAM.statsMax[k] then 
				self:Remove()
			end
		end, "Menu")
		local w, h = love.graphics.getDimensions()
		btn.y = (h/2)+(20*i) + 1
		btn.x = w/2 + 5
		btn.wide, btn.tall = 18, 18
	end
	hook.Add("drawMenu", "stat_text", function(w, h)
		love.graphics.setColor(1, 1, 1)

		love.graphics.setFont(fonts.button)
		love.graphics.printf("Upgrade Beam", 0, (h/2)-5-fonts.button:getHeight(), w, "center", 0, 1)
		love.graphics.printf("Credits: "..GAME.credits, 0, (h/2)-10, w, "center", 0, 1)

		local i = 0
		love.graphics.setFont(fonts.main)
		for k, v in pairs(BEAM.stats) do
			i = i + 1
			love.graphics.printf(string.upper(k)..": "..v.."/"..BEAM.statsMax[k], 0, (h/2)+(20*i), w/2, "right", 0, 1)
		end
	end)
end

function love.update(dt)
	hook.Call("thinkMaster", dt)
	if GAME.state == "active" then
		hook.Call("think", dt)
	elseif GAME.state == "menu" then
		hook.Call("thinkMenu", dt)
	elseif GAME.state == "lost" then
		hook.Call("thinkLost", dt)
	end
end

function love.draw()
	local w, h = love.graphics.getDimensions()
	hook.Call("drawMaster", w, h)
	if GAME.state == "active" then
		hook.Call("draw", w, h)
		hook.Call("drawPly", w, h)
	elseif GAME.state == "menu" then
		hook.Call("drawMenu", w, h)
	elseif GAME.state == "lost" then
		hook.Call("drawLost", w, h)
	end
end

function EndRound()
	GAME.credits = GAME.credits + 1
	GAME.lives = 5
	GAME.round = GAME.round + 1
	GAME.state = "menu"
	GAME.thisRound = {
		maxEnemies = math.random(3, 6) + GAME.round,
		totalEnemies = 0,
		totalEnemiesToEnd = math.random(6, 8) + (math.random(1, 3) * GAME.round),
		spawnRate = 3 - (math.random(0.1, 0.2) * GAME.round)
	}
end

function ResetGame()
	GAME = {}
	GAME.credits = 0
	GAME.lives = 5
	GAME.round = 1
	GAME.state = "menu"
	GAME.thisRound = {
		maxEnemies = 5,
		totalEnemies = 0,
		totalEnemiesToEnd = 10,
		spawnRate = 3
	}

	BEAM:Int()
	PLAYER:Int()
end

function GameOver()
	print("You lost")
	GAME.state = "lost"
	for k, v in pairs(ENEMIES) do
		v:Remove()
		table.remove(ENEMIES, k)
	end

	local btn = CreateButton("Play again?", function()
		ResetGame()
	end, "Lost")
	btn.y = btn.y + (fonts.button:getHeight()*4)
	print(btn)
end

hook.Add("drawMenu", "mainMenu", function(w, h)
	-- Create the background frequency thingy
	local currentSample = sound:tell("samples")
	love.graphics.setColor(1, 1, 1)
	local lines = {}
	for i=0, w do
		if i%2 == 0 then
			table.insert(lines, i)
			table.insert(lines, h/6+(50*sampleIndex[currentSample+i]))
		end
	end
	love.graphics.setLineWidth(4)
	love.graphics.line(lines)

	-- Header text
	love.graphics.setFont(fonts.header)
	love.graphics.printf("FREQBEAM", 0, (h/6)-70, w, "center", 0, 1)
	--love.graphics.printf("FreqShooter", w/2, h/4, 100, "center", 0, 3)
end)

hook.Add("drawLost", "lostScreen", function(w, h)
	-- Create the background frequency thingy
	local currentSample = sound:tell("samples")
	love.graphics.setColor(1, 1, 1)
	local lines = {}
	for i=0, w do
		if i%2 == 0 then
			table.insert(lines, i)
			table.insert(lines, h/6+(50*sampleIndex[currentSample+i]))
		end
	end
	love.graphics.setLineWidth(4)
	love.graphics.line(lines)

	-- Header text
	love.graphics.setColor(1, 0, 0)
	love.graphics.setFont(fonts.header)
	love.graphics.printf("GAME OVER", 0, (h/6)-70, w, "center", 0, 1)
	love.graphics.setFont(fonts.button)
	love.graphics.printf("You survived "..GAME.round.." rounds!", 0, h/2, w, "center", 0, 1)
	--love.graphics.printf("FreqShooter", w/2, h/4, 100, "center", 0, 3)
end)

hook.Add("think", "cal_aim", function(w, h)
	local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
	local w, h = love.graphics.getDimensions()

	beamAngle = math.atan2(mouseY - h, mouseX - w/2)
	if beamAngle < -2.9 then
		beamAngle = -2.9
	elseif beamAngle > -0.2 then
		beamAngle = -0.1
	end
	vx, vy = math.cos(beamAngle), math.sin(beamAngle)

	beamLine = {w*0.5, h-26}
	local lastposX = beamLine[1]
	local lastposY = beamLine[2]

	for i=0, h*1.5 do
		lastposX = lastposX + vx
		lastposY = lastposY + vy
		if i%16 == 0 then
			table.insert(beamLine, lastposX)
			table.insert(beamLine, lastposY)
		end
	end
end)


hook.Add("think", "enemy_generate", function(w, h)
	if not (GAME.state == "active") then return end
	if GAME.thisRound.totalEnemies >= GAME.thisRound.totalEnemiesToEnd then return end
	if #ENEMIES >= GAME.thisRound.maxEnemies then return end
	if lastenemy + GAME.thisRound.spawnRate > love.timer.getTime() then return end
	lastenemy = love.timer.getTime()

	local enemy = CreateEnemy()
	table.insert(ENEMIES, enemy)
	GAME.thisRound.totalEnemies = GAME.thisRound.totalEnemies + 1

	local w, h = love.graphics.getDimensions()
	enemy:SetPos(math.random(0, w-enemy.wide), -enemy.tall)
end)

hook.Add("think", "enemy_fall", function(w, h)
	if GAME.state == "lost" then return end
	local w, h = love.graphics.getDimensions()
	for k, v in pairs(ENEMIES) do
		v:SetPos(v.x, v.y+v.speed+(math.random(0.1, 2)*GAME.round))
		if v.y + v.tall > h then
			GAME.lives = GAME.lives - 1
			if GAME.lives <= 0 then
				GameOver()
			end

			v:Remove()
			table.remove(ENEMIES, k)
		end
	end
end)


hook.Add("drawMaster", "debug_info", function(w, h)
	if true then return end
	love.graphics.setFont(fonts.main)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
	local i = 1
	for k, v in pairs(GAME) do
		if not (type(v) == "boolean") and not (type(v) == "table") then
			i = i + 1
			love.graphics.print(k..": "..v, 10, 15*i)
		elseif (type(v) == "boolean") then
		elseif (type(v) == "table") then
			i = i + 1
			love.graphics.print(k..": ", 10, 15*i)
			for n, m in pairs(v) do
				i = i + 1
				love.graphics.print("- "..n..": "..m, 10, 15*i)
			end
		end
	end
end)

local clickCursor = love.mouse.getSystemCursor("hand")
hook.Add("thinkMaster", "cursorClicker", function(w, h)
	love.mouse.setCursor()
	for k, v in pairs(ALLBUTTONS) do
		if v.isHovered then
			love.mouse.setCursor(clickCursor)
			break
		end
	end
end)