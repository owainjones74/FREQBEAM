PLAYER = {}

function PLAYER:Int()
	self.wide = 10
	self.tall = 30
	self.x = 200
	self.y = 200

	hook.Add("think", "player", function()
		self:Think()
	end)
	hook.Add("draw", "player", function(w, h)
--		self:Draw()
	end)
end

function PLAYER:Think()
	print("Called every tick")
end

function PLAYER:Draw()
	love.graphics.setColor(1, 1, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.wide, self.tall)
end

function PLAYER:SetSize(w, h)
	self.wide, self.tall = w, h
end

function PLAYER:GetSize()
	return self.wide, self.tall
end