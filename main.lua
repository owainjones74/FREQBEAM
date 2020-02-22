-- Libs
require("hooks")

local sound
local soundData
local sampleIndex = {}
function love.load()
	-- Load window size
--	love.window.setMode(480, 800)
	sound = love.audio.newSource("songs/base.mp3", "stream")
	soundData = love.sound.newSoundData("songs/base.mp3")
--	sound:setPitch(2)
	love.audio.play(sound)
	love.audio.setVolume(0.1)

	for i=0, soundData:getSampleCount() do
		sampleIndex[i] = soundData:getSample(i)
	end
end

function love.update(dt)
	hook.Call("think")
end

function love.draw()
	local w, h = love.graphics.getDimensions()
	hook.Call("draw", w, h)
end


--hook.Add("draw", "debug", function(w, h)
--	local currentSample = sound:tell("samples")
--
--	love.graphics.setColor(1, 1, 255)
----	love.graphics.rectangle("fill", 0, h/2+(100*sampleIndex[currentSample]), w/2, 1)
--	print(currentSample)
--	local lines = {}
--	for i=0, w, 2 do
----		if i%2 == 0 then
--			table.insert(lines, w/2+(100*sampleIndex[currentSample+i]))
--			table.insert(lines, i)
----		end
--	end
--
--	love.graphics.setLineWidth(5)
--	love.graphics.line(lines)
--end)


--hook.Add("draw", "debug", function(w, h)
--	local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
--	print(mouseX, mouseY)
--
----	local lines = {
----		w/2, h,
----		mouseX, mouseY
----	}
----
----	love.graphics.line(lines)
--
--	local ang = math.atan2(mouseY - h, mouseX - w/2)
--	local vx, vy = math.cos(ang), math.sin(ang)
--	print(math.deg(ang), vx)
--
--
--	local lines = {w/2, h}
--	local lastposX = w/2
--	local lastposY = h
--	for i=1, 100 do
--		lastposX = lastposX + vx
--		lastposY = lastposY + vy
--		table.insert(lines, lastposX)
--		table.insert(lines, lastposY)
--	end
--
--	love.graphics.setColor(255, 0, 0)
--	love.graphics.line(lines)
--
----	for i=1, mouseY do
----		table.insert(lines, w/2+mouseX)
----		table.insert(lines, mouseY-i)
----	end
--end)


hook.Add("draw", "debug", function(w, h)
	local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
	print(mouseX, mouseY)

--	local lines = {
--		w/2, h,
--		mouseX, mouseY
--	}
--
--	love.graphics.line(lines)

	local ang = math.atan2(mouseY - h, mouseX - w/2)
	local vx, vy = math.cos(ang), math.sin(ang)
	print(math.deg(ang), vx)

	local currentSample = sound:tell("samples")

	local lines = {w*0.5, h}

	local lastposX = lines[1]
	local lastposY = lines[2]
	for i=0, h*1.5 do
		lastposX = lastposX + vx
		lastposY = lastposY + vy
		if i%16 == 0 then
			table.insert(lines, lastposX+(16*sampleIndex[currentSample+i]))
			table.insert(lines, lastposY)
		end
	end

--	love.graphics.setLineWidth(5)
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(lines)

--	for i=1, mouseY do
--		table.insert(lines, w/2+mouseX)
--		table.insert(lines, mouseY-i)
--	end
end)




hook.Add("draw", "info", function(w, h)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
end)