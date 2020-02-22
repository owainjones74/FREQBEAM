WORLD = {}

function WORLD:Int()
	love.physics.setMeter(64)
	hook.Add("think", "world", function()
		self:Think()
	end)
	hook.Add("draw", "world", function(w, h)
		self:Draw()
	end)
end