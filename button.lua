-- Cache
local id = 0

function CreateButton(text, func, realm)
	local realm = realm or ""
	local BUTTON = {}

	function BUTTON:Int()
		id = id + 1
		self.id = id

		self.wide = 200
		self.tall = 50
		self.x, self.y = love.graphics.getDimensions()
		self.x = self.x/2-self.wide/2
		self.y = self.y/2-self.tall/2
		self.lastClick = 0
		self.text = text
		self.func = func
		self.realm = realm

		hook.Add("think"..realm, "button"..id, function()
			self:Think()
		end)
		hook.Add("draw"..realm, "button"..id, function(w, h)
			self:Draw()
		end)
		ALLBUTTONS[id] = self
	end
	
	function BUTTON:Think()
		if self.lastClick + 1 > love.timer.getTime() then return end

		local x, y = love.mouse.getX(), love.mouse.getY()
		if (x > self.x) and (x < self.x+self.wide) and (y > self.y) and (y < self.y+self.tall) then
			self.isHovered = true
			if love.mouse.isDown(1) then
				self.lastClick = love.timer.getTime()
				self:OnClick()
			end
		else
			self.isHovered = false
		end
	end
	
	function BUTTON:Draw()
		love.graphics.setColor(0.2, 0.25, 0.6)
		love.graphics.rectangle("fill", self.x, self.y, self.wide, self.tall)

		love.graphics.setColor(1, 1, 1)
		love.graphics.setFont(fonts.button)
		love.graphics.printf(self.text, self.x, self.y+(self.tall/2)-(fonts.button:getHeight()/2), self.wide, "center", 0, 1)
	end
	
	function BUTTON:OnClick()
		self.isHovered = false
		self.func(self)
	end

	function BUTTON:SetSize(w, h)
		self.wide, self.tall = w, h
	end
	
	function BUTTON:GetSize()
		return self.wide, self.tall
	end
	
	function BUTTON:SetPos(x, y)
		self.x, self.y = x, y
	end
	
	function BUTTON:GetPos()
		return self.x, self.y
	end
	
	function BUTTON:Remove()
		hook.Remove("think"..self.realm, "button"..self.id)
		hook.Remove("draw"..self.realm, "button"..self.id)
		ALLBUTTONS[id] = nil
	end


	BUTTON:Int()

	return BUTTON
end

