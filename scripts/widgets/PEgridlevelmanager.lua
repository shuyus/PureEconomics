-- PEgridlevelmanager.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 用于生成并管理所有分类下物品格子的管理器，包含多个GridLevel

local Widget = require "widgets/widget"
local GridLevel = require "widgets/PEgridlevel"
local Grid = require "widgets/PEgrid"

--[[
分页函数 

all_cells : 所有元素的数组
cell_num_per_grid : 每页的元素数量
index : 第几页(从1开始)

return : 一个数组，包含所有第index页该显示的元素
]]
local function choose_cells(all_cells, cell_num_per_grid, index)
	local grids_num = math.ceil(#all_cells / cell_num_per_grid)
	local start_index = cell_num_per_grid * (index - 1) + 1
	local end_index = cell_num_per_grid * index
	if index == grids_num then
		end_index = #all_cells
	end

	local result = {}

	for i=start_index,end_index do
		table.insert(result, all_cells[i])
	end

	return result
end

local GridLevelManager = Class(Widget, function(self)
    Widget._ctor(self, "GridLevelManager")
    self.levels = {}
    self.current_level = nil
    self.last_button = nil
    self.next_button = nil
	self.display_filter = nil
end)

function GridLevelManager:AdjustLevelPosition(x,y)
	for k,v in pairs(self.levels) do
		v:SetPosition(x,y)
	end
end

function GridLevelManager:ClearAllLevels()
	self.current_level = nil

	for k,v in pairs(self.levels) do
		self.levels[k] = nil
		v:CloseGrid()
		v:Kill()
	end
end

function GridLevelManager:AddLevel(name, all_cells, cell_num_per_grid, num_columns, coffset, roffset)
	local level = GridLevel(name)
	local grids = {}

	if self.display_filter then

		local filter = self.display_filter

		for i = #all_cells,1,-1 do
			if not filter(all_cells[i]) then
				table.remove(all_cells,i)
				all_cells[i]:Kill()
			end
		end
	end

	local grids_num = math.ceil(#all_cells / cell_num_per_grid)

	for i=1,grids_num do
		local grid = Grid(i)
		local items = choose_cells(all_cells, cell_num_per_grid, i)
		grid:InitGrid(num_columns, coffset, roffset, items)
		table.insert(grids, grid)
	end

	if self.last_button then level:SetLastButton(self.last_button) end
	if self.next_button then level:SetNextButton(self.next_button) end

	level:InitByGrids(grids)
	self.levels[name] = self:AddChild(level)
end

function GridLevelManager:ChooseLevel(name)
	if self.current_level then
		self.current_level:CloseGrid()
		self.current_level:Hide()
		self.current_level:MoveToBack()
	end

	self.current_level = self.levels[name]
	self.current_level:MoveToFront()
	self.current_level:Show()
	self.current_level:ShowGrid(1)
end

function GridLevelManager:SetDisplayFilterFn(fn)
	assert(isfn(fn),"[GridLevelManager:SetDisplayFilterFn] : filter must be lua closure")
	self.display_filter = fn
end


function GridLevelManager:SetLastNextButton(last_button, next_button)
    self.last_button = last_button
    self.next_button = next_button
    for k,l in pairs(self.levels) do
    	l:SetLastNextButton(last_button, next_button)
    end

    last_button:SetOnClick(function()
		if self.current_level then
    		self.current_level:LastLevel()
		end
	end)

	next_button:SetOnClick(function()
		if self.current_level then
    		self.current_level:NextLevel()
		end
	end)
end

return GridLevelManager