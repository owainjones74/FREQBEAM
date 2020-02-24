-- Cache
local id = 0
local notes = {}
notes[1] = love.graphics.newImage("assets/note_1.png")
notes[2] = love.graphics.newImage("assets/note_2.png")
-- Have to wrap this in a function because duplicating metatables is being a bitch for some reason and i cba to debug it...
function CreateEnemy()
	local ENEMY = {}

	function ENEMY:Int()
		id = id + 1
		self.id = id

		self.wide = 50
		self.tall = 50
		self.x, self.y = love.graphics.getDimensions()
		self.x = self.x/2-self.wide/2
		self.y = self.y/2-self.tall/2
		self.speed = math.random(0.5, 1.5)
		self.startHealth = math.random(5, 10)
		self.health = self.startHealth
		self.lasthit = 0
		self.noteImg = notes[math.random(2)]

		hook.Add("think", "enemy"..id, function()
			self:Think()
		end)
		hook.Add("draw", "enemy"..id, function(w, h)
			self:Draw()
		end)
	end
	
	function ENEMY:Think()	
	end
	
	function ENEMY:Draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.noteImg, self.x, self.y, 0, 0.1, 0.1)

		if not (self.health == self.startHealth) then
			love.graphics.setColor(200, 200, 200)
			love.graphics.rectangle("fill", self.x, self.y-7, self.wide, 5)
			love.graphics.setColor(200, 0, 0)
			love.graphics.rectangle("fill", self.x, self.y-7, self.wide*self.health/self.startHealth, 5)
		end

--		love.graphics.setColor(0, 255, 0)
--		love.graphics.rectangle("line", self.x, self.y, self.wide, self.tall)
	end
	
	function ENEMY:SetSize(w, h)
		self.wide, self.tall = w, h
	end
	
	function ENEMY:GetSize()
		return self.wide, self.tall
	end
	
	function ENEMY:SetPos(x, y)
		self.x, self.y = x, y
	end
	
	function ENEMY:GetPos()
		return self.x, self.y
	end
	
	function ENEMY:Remove()
		print("removing", self.id)
		hook.Remove("think", "enemy"..self.id)
		hook.Remove("draw", "enemy"..self.id)
	end


	ENEMY:Int()

	return ENEMY
end

