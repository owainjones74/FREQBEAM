BEAM = {}

function BEAM:Int()
	self.active = false
	self.onCooldown = true
	self.timer = 1.5
	self.stats = {
		cooldown = 2,
		blastLength = 1,
		damage = 1
	}
	self.statsMax = {
		cooldown = 0.5,
		blastLength = 4,
		damage = 3,
	}
	self.statsSteps = {
		cooldown = -0.25,
		blastLength = 1,
		damage = 1,
	}

	hook.Add("think", "beam", function(dt)
		self:Think(dt)
	end)
	hook.Add("draw", "beam", function(w, h)
		self:Draw()
	end)
end

function BEAM:Think(dt)
	if self.active then
		self.timer = self.timer + dt
		if self.timer >= self.stats.blastLength then
			self:FireStop()
		end

		local curTime = love.timer.getTime()
		for i=1, #beamLine, 2 do
			local x, y = beamLine[i], beamLine[i+1]
			for k, v in pairs(ENEMIES) do
				if v.lasthit+0.1 < curTime then
					if ((v.x < x) and (v.x + v.wide > x)) and ((v.y < y) and (v.y + v.tall > y)) then
						v.lasthit = curTime
						v.health = v.health - self.stats.damage
						if v.health <= 0 then
							v:Remove()
							table.remove(ENEMIES, k)
							if (GAME.thisRound.totalEnemiesToEnd == GAME.thisRound.totalEnemies) and (#ENEMIES == 0) then
								EndRound()
							end
						end
					end
				end
			end
		end
	end
	if self.onCooldown then
		self.timer = self.timer + dt
		if self.timer >= self.stats.cooldown then
			self.onCooldown = false
			self.timer = 0
		end
	end
end

function BEAM:Draw()
	if not self.active then return end
	local currentSample = sound:tell("samples")
	for i=1, #beamLine, 2 do
		beamLine[i] = beamLine[i]+(8*self.stats.damage*sampleIndex[currentSample+i])
	end

	love.graphics.setColor(1, 0, 0)
	love.graphics.setLineWidth(2)
	love.graphics.line(beamLine)
end

function BEAM:Fire()
	self.active = true
end

function BEAM:FireStop()
	self.active = false
	self.timer = 0
	self.onCooldown = true
end