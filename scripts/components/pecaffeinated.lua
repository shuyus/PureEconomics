-- pecaffeinated.lua
-- Author: 勿言
-- LastEdit: 2024.2.2
-- Using: 咖啡加速的组件

local PECaffeinated = Class(function(self, inst)
	self.inst = inst
	self.mult = 1
	self.duration = 0
	self.updating = false
end)

function PECaffeinated:Caffeinate(mult, duration)
	self.mult = mult
	self.duration = duration
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
		self.updating = true
	end
	self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "PECaffeinated", self.mult)
end

function PECaffeinated:ResetValues()
	self.duration = 0
	self.mult = 1
end

function PECaffeinated:WearOff()
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
	self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "PECaffeinated")
	self.updating = false
end

function PECaffeinated:OnUpdate(dt)
	self.duration = self.duration - dt
	if self.duration <= 0 then
		self:WearOff()
	end
end

function PECaffeinated:OnLoad(data)
	if data and data.mult and data.duration and data.duration > 0 and data.mult > 1 then
		self:Caffeinate(data.mult, data.duration)
	end
end

function PECaffeinated:OnSave()
	return {
		mult = self.mult,
		duration = self.duration,
	}
end

return PECaffeinated