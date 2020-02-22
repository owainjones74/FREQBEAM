-- Libs
require("hooks")

local sound
local soundData
local width
local height
local sampleIndex = {}
function love.load()
	-- Load window size
--	love.window.setMode(480, 800)
	sound = love.audio.newSource("songs/base.mp3", "stream")
	soundData = love.sound.newSoundData("songs/base.mp3")
	sound:setPitch(0.05)
	love.audio.play(sound)
	love.audio.setVolume(0.10)
	width, height = love.graphics.getDimensions()

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


hook.Add("draw", "debug", function(w, h)
	local currentSample = sound:tell("samples")

	love.graphics.setColor(1, 1, 255)
--	love.graphics.rectangle("fill", 0, h/2+(100*sampleIndex[currentSample]), w/2, 1)
	print(currentSample)
	local lines = {}
	for i=0, width do
		if i%2 == 0 then
			table.insert(lines, i)
			table.insert(lines, h/2+(100*sampleIndex[currentSample+i]))
		end
	end

	love.graphics.line(lines)
end)