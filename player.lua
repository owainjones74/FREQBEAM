PLAYER = {}
local wid, hei
function PLAYER:Int()
	self.wide = 50
	self.tall = 50
	self.x, self.y = love.graphics.getDimensions()
	self.x = self.x/2-self.wide/2
	self.y = self.y-self.tall

	self.base_image = love.graphics.newImage("assets/turret_base.png")
	self.node_image = love.graphics.newImage("assets/turret_node.png")
	wid, hei = self.node_image:getWidth(), self.node_image:getHeight()
	hook.Add("think", "_player", function()
		self:Think()
	end)
	hook.Add("drawPly", "_player", function(w, h)
		self:Draw()
	end)
end

function PLAYER:Think()
	self:IsFiring()
end

function PLAYER:Draw()
	love.graphics.setColor(0.95, 0.95, 0.95)
	love.graphics.draw(self.node_image, self.x+((wid*0.1)*0.5), self.y+((hei*0.1)*0.5)+5, beamAngle+1.5, 0.4, 0.2, wid/2, hei/2)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.base_image, self.x, self.y, 0, 0.1, 0.1)
end

function PLAYER:SetSize(w, h)
	self.wide, self.tall = w, h
end

function PLAYER:GetSize()
	return self.wide, self.tall
end

function PLAYER:CanFire()
	if not (GAME.state == "active") then return end
	if BEAM.active then return false end
	if BEAM.onCooldown then return false end

	return true
end

function PLAYER:IsFiring()
	if not PLAYER:CanFire() then return end

	if love.mouse.isDown(1) then
		BEAM:Fire()
	end
end