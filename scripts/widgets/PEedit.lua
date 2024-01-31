local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local TextEdit = require "widgets/textedit"
local TEMPLATES = require("widgets/redux/templates")

local item_data = _G.pe_item_data
local GetImage = require "3rd/PEgetimage"

local base_size = 128
local cell_size = 73
local icon_size = 20 / (cell_size/base_size)

local PEEdit = Class(Widget, function(self)
    Widget._ctor(self, "PEEdit")

    self.root = self:AddChild(Widget("edit-root"))
    self.back =  self.root:AddChild(ImageButton("images/quagmire_recipebook.xml", "cookbook_known.tex", "cookbook_known.tex", "cookbook_known.tex"))
	self.back:SetNormalScale(cell_size/base_size, cell_size/base_size)
    self.back:Disable()
    self.edit = self:AddChild(TextEdit(DEFAULTFONT, 25, ""))
    self.edit:SetCharacterFilter("1234567890")	
    self.edit:SetPosition(0,-100,0)
    self.edit:SetTextLengthLimit(6)
    self.edit:SetHAlign(ANCHOR_LEFT)
    self.edit:SetForceEdit(true)
    self.edit.OnTextEntered = function(str) end
    self.image = nil
    self.submit = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0}))
	self.submit:SetPosition(-80,-130,0)
	self.submit:SetText(STRINGS.PUREECOMOMICS.SUBMIT_BUTTON)
    self.submit:SetTextSize(30)
    self.submit:SetOnClick(function()
        self.edit:SetEditing(false)
        local str = self.edit:GetString()
        local new_price = tonumber(str)

        if isnum(new_price) then
            SendModRPCToServer(GetModRPC("PureEconomics","PEedit"), self.item_name, new_price,self.checkbox.checked)
            self:Hide()
            self:MoveToBack()
        else
            self.edit:SetString("")
            self.edit:SetEditing(true)
        end


    end)

    self.submit:SetPosition(100,0,0)

    self.recovery = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0}))
	self.recovery:SetPosition(80,-100,0)
	self.recovery:SetText(STRINGS.PUREECOMOMICS.RECOVERY_BUTTON)
    self.recovery:SetTextSize(30)
    self.recovery:SetOnClick(function()
        SendModRPCToServer(GetModRPC("PureEconomics","PErecovery"), self.item_name)
    end)
    self.recovery:Hide()
    self.recovery:Disable()


    local checkbox = TEMPLATES.LabelCheckbox(function(checkbox)
        checkbox.checked = not checkbox.checked
        checkbox:Refresh()
    end,false,STRINGS.PUREECOMOMICS.CHECKBOX_LABEL)


        


    self.checkbox = self:AddChild(checkbox)
    self.checkbox:SetPosition(180,0,0)

    
end)

function PEEdit:SetItem(name)
    local info = item_data:GetItemInfo(name)

    if not info then return end
    local price = info.price
    local checked = info.canbuy

    if not isnum(price) or not isbool(checked) then return end

    self.item_name = name

    local xml,tex = GetImage(name)

    if self.image then
        self.image:Kill()
    end

    if xml and tex then
        self.image = self.back.image:AddChild(Image(xml,tex))
    end

    self.edit:SetString(tostring(price))	
    self.checkbox.checked = checked
    self.checkbox:Refresh()

    if info.origin then
        self.recovery:Show()
        self.recovery:Enable()
    else
        self.recovery:Hide()
        self.recovery:Disable()
    end


end
return PEEdit