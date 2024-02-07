-- PEshopplain.lua
-- Author: 勿言
-- LastEdit: 2024.2.2
-- Using: 商店页面的主面板

local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Grid = require "widgets/PEgrid"
local GridLevel = require "widgets/PEgridlevel"
local GridLevelManager = require "widgets/PEgridlevelmanager"
local Edit = require "widgets/PEedit"

local item_data = _G.pe_item_data
local arr_filter = require "PEfilterlist"
local GetImage = require "3rd/PEgetimage"

local SINGLE_PAGE_NUM = 22

local back_width = 945
local back_height = 577.5
local single_tab_width = math.floor(back_width*0.9/#arr_filter)
local base_size = 128
local cell_size = 73
local icon_size = 20 / (cell_size/base_size)


local player_oncontrol = function(self, control, down)--参考自简单经济学
	if not self:IsEnabled() or not self.focus or self:IsSelected() then return end

	local name = self.item_name
	if control == CONTROL_ACCEPT or control == CONTROL_SECONDARY then
		if down then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self.o_pos = self:GetLocalPosition()
			self:SetPosition(self.o_pos + self.clickoffset)
			self.down = true
			if self.whiledown then
				self:StartUpdating()
			end
			if self.ondown then
				self.ondown()
			end
		else
			if self.down then
				self.down = false
				self:SetPosition(self.o_pos)
				if control == CONTROL_ACCEPT then
					SendModRPCToServer(GetModRPC("PureEconomics","PEbuy"), name, false, Profile:GetLastUsedSkinForItem(name))
				elseif control == CONTROL_SECONDARY then
					SendModRPCToServer(GetModRPC("PureEconomics","PEbuy"), name, true, Profile:GetLastUsedSkinForItem(name))
				end
				self:StopUpdating()
			end
		end
		return true
	end
end

local edit_oncontrol = function(self, control, down)
	if not self:IsEnabled() or not self.focus or self:IsSelected() then return end

	local name = self.item_name
	if control == CONTROL_ACCEPT or control == CONTROL_SECONDARY then
		if down then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self.o_pos = self:GetLocalPosition()
			self:SetPosition(self.o_pos + self.clickoffset)
			self.down = true
			if self.whiledown then
				self:StartUpdating()
			end
			if self.ondown then
				self.ondown()
			end
		else
			if self.down then
				self.down = false
				self:SetPosition(self.o_pos)
				if control == CONTROL_ACCEPT then
					self.main.current_edit_cell = self.parent
					self.main.edit_plain:SetItem(self.item_name)
					self.main.edit_plain:Show()
					self.main.edit_plain:MoveToFront()
					self.main.edit_plain.edit:SetEditing(true)
				end
				self:StopUpdating()
			end
		end
		return true
	end
end

-- 生成商品格子容器
-- 
local function CellWidgetsCtor(info, isedit, main)
	if isedit == nil then isedit = false end
	local name = info.name
    local w = Widget("item-cell-".. name)
	--w:Hide()
	----------------
	w.back = w:AddChild(ImageButton("images/quagmire_recipebook.xml", "cookbook_known.tex", "cookbook_known_selected.tex"))
	w.back:SetFocusScale(cell_size/base_size + .05, cell_size/base_size + .05)
	w.back:SetNormalScale(cell_size/base_size, cell_size/base_size)
	w.back.ongainfocusfn = function() end
	w.back.main = main
	w.back.item_name = name
	w.back.canbuy = info.canbuy
	--w.focus_forward = w.back 

	w.info = w:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small.tex", "button_small.tex", nil, nil, {1,1}, {0,0}))
	w.info:SetPosition(1,-50)
	w.info:SetNormalScale(cell_size/base_size*1.4, cell_size/base_size*1.4)
	local show_price = item_data:GetItemPrice(name) or "undfined"
	w.info:SetText(show_price.."G")
	w.info:SetTextSize(30)
	w.info:Disable()
	----------------
	w.pic_root = w.back.image:AddChild(Widget("pic_root"))

    local xml,tex = GetImage(name)
    if xml and tex then
    	 w.item_img = w.pic_root:AddChild(Image(xml,tex))
    else
    	 w.item_img = w.pic_root:AddChild(Image("images/global.xml", "square.tex"))
    end

	if isedit and TheNet:GetIsServerAdmin() then
		w.back.OnControl = edit_oncontrol
	else 
		w.back.OnControl = player_oncontrol
	end

	
	w.back:SetHoverText(STRINGS.PUREECOMOMICS.SELLRATE_INFO_1..tostring(item_data:GetItemSellRate(name)*100).."%")	

	return w
end

local function GetItemListProxy(filter,current_mode)
	if current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE then return item_data:GetItemsOfFilter(filter) end

	if filter == "precious" then
		if TUNING.PUREECOMOMICS.UNLOCK_PRECIOUS then return item_data:GetItemsOfFilter(filter) end
		local array = ThePlayer.replica.peplayercontext:GetPreciousArray()
		return item_data:GetItemsByNameArray(array)
	else
		return item_data:GetItemsOfFilter(filter)
	end
end

local PEShopPlain = Class(Widget, function(self, owner)
    Widget._ctor(self, "PEShopPlain")
    self.owner = owner
    self.root = self:AddChild(Widget("root"))

    self.backdrop = self.root:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_menu_bg.tex"))
    self.backdrop:ScaleToSize(back_width, back_height)

	self.current_mode = TUNING.PUREECOMOMICS.USER_MODE
	self.level_manager = self.root:AddChild(GridLevelManager())
	self.level_manager:SetPosition(0,-20)
	-- self.level_manager:SetDisplayFilterFn(function(cell_widget)
	-- 	return self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE or cell_widget.back.canbuy
	-- end)
	
	self.isinit = true
    self.tabs = {}
	self:_MakeButton()
	self:_MakeInfo()
	self:SwitchMode(TUNING.PUREECOMOMICS.USER_MODE)

	if TheNet:GetIsServerAdmin() then
		self.current_edit_cell = nil
		local edit_button = self.root:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0}))
		self.edit_button = edit_button
		edit_button:SetText(STRINGS.PUREECOMOMICS.EDIT_BUTTON)
		edit_button:SetPosition(-400,250,0)
		edit_button:SetNormalScale(cell_size/base_size*1.3, cell_size/base_size*1.3)
		edit_button:SetTextSize(25)
		edit_button:SetOnClick(function()
			self:SwitchMode()
			if self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE then 
				edit_button:SetText(STRINGS.PUREECOMOMICS.FINISH_EDIT_BUTTON)
			else
				edit_button:SetText(STRINGS.PUREECOMOMICS.EDIT_BUTTON)
			end
			
			self.edit_plain:Hide()
			self.edit_plain:MoveToBack()
		end)
		local edit_plain = self.root:AddChild(Edit())
		self.edit_plain = edit_plain
		edit_plain:SetPosition(150,80,0)
		edit_plain:SetSubmitCallBack(function(new_price,canbuy)
			self.current_edit_cell.info:SetText(new_price.."G")
			self.current_edit_cell.back.canbuy=canbuy
		end)
		edit_plain:Hide()
		edit_plain:MoveToBack()
	end

end)

function PEShopPlain:UpdateCash()
	self.info.cash_num:SetString(ThePlayer.replica.peplayercontext:GetCash())
end

function PEShopPlain:_PositionTabs(w, y)
	local offset = #self.tabs / 2
	for i = 1, #self.tabs do
		local x = (i - offset - 0.5) * w
		self.tabs[i]:SetPosition(x, y)
	end
end

function PEShopPlain:_MakeSpecial()
	local all_cells = {}

	if self.special then
		self.special:Kill()
		self.special = nil
	end

	local isedit = self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE

	for i,t in ipairs(item_data:GetItemsOfFilter("special")) do
		if self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE or t.canbuy then
    		table.insert(all_cells,CellWidgetsCtor(t,isedit,self))
		end
    end
	
	self.special = self.root:AddChild(Grid("special"))
	self.special:InitGrid(4, 80, 110, all_cells)
	self.special:SetPosition(150,-150,0)
	self.special:Show()
	self.special:MoveToFront()
end

function PEShopPlain:_MakeInfo()
	self.info = self.root:AddChild(Widget("info"))
	self.info.textcolour = {0,0,0,1}
	self.info.pre = self.info:AddChild(Text(NEWFONT,40,STRINGS.PUREECOMOMICS.REAMIN_INFO))
	self.info.cash_num = self.info:AddChild(Text(NEWFONT,40,ThePlayer.replica.peplayercontext:GetCash()))

	self.info.pre:SetColour(self.info.textcolour)
	self.info.cash_num:SetColour(self.info.textcolour)

	self.info:SetPosition(180,200,0)
	self.info.cash_num:SetPosition(100,0,0)
end


function PEShopPlain:_MakeButton()
	local last_page_button = ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0})
	local next_page_button = ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0})
    self.root.last_page_button = self:AddChild(last_page_button)
    self.root.next_page_button = self:AddChild(next_page_button)

	last_page_button:SetText(STRINGS.PUREECOMOMICS.LAST_BUTTON)
	last_page_button:SetPosition(-80,-130,0)
	last_page_button:SetNormalScale(cell_size/base_size*1.3, cell_size/base_size*1.3)
	last_page_button:SetTextSize(30)
	next_page_button:SetText(STRINGS.PUREECOMOMICS.NEXT_BUTTON)
    next_page_button:SetPosition(0,-130,0)
    next_page_button:SetNormalScale(cell_size/base_size*1.3, cell_size/base_size*1.3)
    next_page_button:SetTextSize(30)

    self.level_manager:SetLastNextButton(last_page_button, next_page_button)
end

function PEShopPlain:_MakeSingleTab(name, index)
	local tab = ImageButton("images/quagmire_recipebook.xml", "quagmire_recipe_tab_inactive.tex", nil, nil, nil, "quagmire_recipe_tab_active.tex")
	tab.filter = name
	local w,h = tab:GetSize()
	tab:SetFocusScale(single_tab_width/w, .7)
	tab:SetNormalScale(single_tab_width/w, .7)
	tab:SetText(STRINGS.PUREECOMOMICS.FILTERS[name])
	tab:SetTextSize(22)
	tab:SetFont(HEADERFONT)
	tab:SetTextColour(UICOLOURS.GOLD)
	tab:SetTextFocusColour(UICOLOURS.GOLD)
	tab:SetTextSelectedColour(UICOLOURS.GOLD)
	tab.text:SetPosition(0, -2)
	tab.clickoffset = Vector3(0,5,0)
	tab:SetOnClick(function()
		self.last_selected:Unselect()
		self.last_selected = tab
		tab:Select()
		tab:MoveToFront()
		self.level_manager:ChooseLevel(name)
	end)
	tab._tabindex = index - 1

	return tab
end


function PEShopPlain:_MakeTabs()
	local _index = 1
	for i,t in pairs(arr_filter) do
		local filter = t.id
		if not item_data.special_filters[filter] then
			table.insert(self.tabs, self.root:AddChild(self:_MakeSingleTab(filter,_index)))
			_index = _index + 1
		end
	end
end


function PEShopPlain:_AddSingleLevel(filter)
    local all_cells = {}
	local isedit = self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE


    for i,t in ipairs(GetItemListProxy(filter,self.current_mode)) do
		if self.current_mode==TUNING.PUREECOMOMICS.ADMIN_MODE or t.canbuy then -- 这里过滤不可买的物品
    		table.insert(all_cells,CellWidgetsCtor(t,isedit,self))
		end
    end

    self.level_manager:AddLevel(filter, all_cells, 22, 6, 80, 110)

end

function PEShopPlain:_AddLevels()
	for i,t in pairs(arr_filter) do
		local filter = t.id
		if not item_data.special_filters[filter] then
			self:_AddSingleLevel(filter)
		end
	end
end


function PEShopPlain:SwitchMode(mode)
	self.level_manager:ClearAllLevels()

	if mode == nil then
		self.current_mode = self.current_mode == TUNING.PUREECOMOMICS.ADMIN_MODE and 
							TUNING.PUREECOMOMICS.USER_MODE or TUNING.PUREECOMOMICS.ADMIN_MODE
	else
		self.current_mode = mode
	end

	if self.isinit then
		self:_MakeTabs()
		dprint("single_tab_width",single_tab_width)
		self:_PositionTabs(single_tab_width, 310)
		self.last_selected = self.tabs[1]
		self.isinit = false
	end
	
	self:_AddLevels()
	self.level_manager:AdjustLevelPosition(-400, 200)
	self.level_manager:ChooseLevel(self.last_selected.filter)

	self:_MakeSpecial()

	self.last_selected:Select()
	self.last_selected:MoveToFront()

end


return PEShopPlain