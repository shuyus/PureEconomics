-- ui.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 添加主界面UI

local Button = require("widgets/button")
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local PEShopScreen = require "screens/PEshopscreen"

local function open_shop()
	TheFrontEnd:PushScreen(PEShopScreen(ThePlayer))
end

local function AddShopButton(self)
	local pe_shop_button = ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0})
	pe_shop_button:SetOnClick(open_shop)
	pe_shop_button:SetText(STRINGS.PUREECOMOMICS.SHOP_BUTTON)
    self.pe_shop_button = self:AddChild(pe_shop_button)
    self.pe_shop_button:SetHAnchor(ANCHOR_MIDDLE)
    self.pe_shop_button:SetVAnchor(ANCHOR_TOP) 
    self.pe_shop_button:SetPosition(70,-50,0)
end

AddClassPostConstruct("widgets/controls", AddShopButton)