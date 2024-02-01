-- PEgridlevel.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 某一分类的格子的集合，包含多个Grid

local Widget = require "widgets/widget"
local Grid = require "widgets/PEgrid"

local GridLevel = Class(Widget, function(self,name)
    Widget._ctor(self, "GRIDLEVEL"..name)
    self.name = name
    self.grids = nil
    self.current_grid = nil
    self.level_num = 0
    self.last_button = nil
    self.next_button = nil
end)

--grids是一个Grid数组 { Grid(),Grid()}
function GridLevel:InitByGrids(grids)
	assert(#grids > 0, "grids num must be positive")
	self.grids = grids
	self.level_num = #grids
	self.current_grid = grids[1]

	for i,v in ipairs(grids) do
		v.index = i
		self:AddChild(v)
		v:Hide()
		v:MoveToBack()
	end
end

function GridLevel:ShowGrid(index)
	if not index then index = 1 end
	assert(index > 0 and index <= self.level_num, "Invaid Index")

	if self.current_grid then
		self.current_grid:Hide()
		self.current_grid:MoveToBack()
	end
	self.grids[index]:MoveToFront()
	self.grids[index]:Show()
	
	self.current_grid = self.grids[index]

	self:UpdateButtonStatus()
end

function GridLevel:CloseGrid(index)
	if not index then index = self.current_grid.index end
	assert(index and index > 0 and index <= self.level_num, "Invaid Index")

	self.grids[index]:Hide()
	self.grids[index]:MoveToBack()

end

function GridLevel:NextLevel()

	local current_index = self.current_grid.index
	if current_index >=  self.level_num then return end

	current_index = current_index + 1

	self:ShowGrid(current_index)

	if self.next_button and current_index >=  self.level_num then 
		self.next_button:Disable()
		self.next_button.image:SetTint(1,1,1,.5)
	end
	if self.last_button and not self.last_button:IsEnabled() then 
		self.last_button:Enable() 
		self.last_button.image:SetTint(1,1,1,1)
	end

end

function GridLevel:LastLevel()
	local current_index = self.current_grid.index
	if current_index < 2 then return end

	current_index = current_index - 1

	self:ShowGrid(current_index)

	if self.last_button and current_index <= 1 then 
		self.last_button:Disable() 
		self.last_button.image:SetTint(1,1,1,.5)
	end
	if self.next_button and not self.next_button:IsEnabled() then 
		self.next_button:Enable() 
		self.next_button.image:SetTint(1,1,1,1)
	end
end

function GridLevel:UpdateButtonStatus()
	local current_index = self.current_grid.index
	if self.last_button then
		self.last_button:Enable() 
		self.last_button.image:SetTint(1,1,1,1)
		if current_index <= 1 then
			self.last_button:Disable() 
			self.last_button.image:SetTint(1,1,1,.5)
		end
	end

	if self.next_button then
		self.next_button:Enable() 
		self.next_button.image:SetTint(1,1,1,1)
		if current_index >=  self.level_num then 
			self.next_button:Disable()
			self.next_button.image:SetTint(1,1,1,.5)
		end
	end
end

function GridLevel:SetLastNextButton(last_button, next_button)
    self.last_button = last_button
    self.next_button = next_button
end

function GridLevel:SetNextButton(next_button)
    self.next_button = next_button
end
function GridLevel:SetLastButton(last_button, next_button)
    self.last_button = last_button
end

return GridLevel