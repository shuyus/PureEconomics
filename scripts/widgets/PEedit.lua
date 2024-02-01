-- PEedit.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 修改物品信息的小面板
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local TextEdit = require "widgets/textedit"
local TEMPLATES = require("widgets/redux/templates")

local item_data = _G.pe_item_data
local GetImage = require "3rd/PEgetimage"

local base_size = 128
local cell_size = 73
local icon_size = 20 / (cell_size / base_size)

local PEEdit = Class(Widget, function(self)
    Widget._ctor(self, "PEEdit")

    self.root = self:AddChild(Widget("edit-root"))

    self.back = self.root:AddChild(ImageButton("images/quagmire_recipebook.xml", "cookbook_known.tex",
        "cookbook_known.tex", "cookbook_known.tex"))
    self.back:SetNormalScale(cell_size / base_size, cell_size / base_size)
    self.back:Disable()

    self.edit_bg = self:AddChild(Image("images/global_redux.xml", "textbox3_gold_normal.tex"))
    self.edit_bg:SetPosition(10, -100, 0)
    self.edit_bg:ScaleToSize(100, 40)
    self.edit_bg.OnControl = function(bg, control, down)
        if control == CONTROL_ACCEPT then
            if down then
                self.edit:SetEditing(true)
            end
            return true
        end
    end

    self.edit = self:AddChild(TextEdit(DEFAULTFONT, 25, ""))
    self.edit:SetPosition(0, -100, 0)
    self.edit:SetCharacterFilter("1234567890")
    self.edit:SetTextLengthLimit(6)
    self.edit:SetHAlign(ANCHOR_LEFT)
    self.edit:SetForceEdit(true)
    self.edit:EnableWordWrap(false)
    self.edit.OnTextEntered = function(str)
    end

    self.image = nil

    self.submit = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex",
        "button_small_disabled.tex", nil, nil, {1, 1}, {0, 0}))
    self.submit:SetPosition(-80, -130, 0)
    self.submit:SetText(STRINGS.PUREECOMOMICS.SUBMIT_BUTTON)
    self.submit:SetNormalScale(cell_size / base_size * 1.3, cell_size / base_size * 1.3)
    self.submit:SetTextSize(25)
    self.submit:SetPosition(100, 0, 0)
    self.submit:SetOnClick(function()
        self.edit:SetEditing(false)
        local str = self.edit:GetString()
        local new_price = tonumber(str)
        local canbuy = self.checkbox.checked

        if isnum(new_price) then
            SendModRPCToServer(GetModRPC("PureEconomics", "PEedit"), self.item_name, new_price, canbuy)
            self:Hide()
            self:MoveToBack()
            if self.submit_callback then
                self.submit_callback(new_price, canbuy)
            end
        else
            self.edit:SetString("")
            self.edit:SetEditing(true)
        end

    end)
    
    self.recovery = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex",
        "button_small_disabled.tex", nil, nil, {1, 1}, {0, 0}))
    self.recovery:SetPosition(100, -100, 0)
    self.recovery:SetText(STRINGS.PUREECOMOMICS.RECOVERY_BUTTON)
    self.recovery:SetNormalScale(cell_size / base_size * 1.3, cell_size / base_size * 1.3)
    self.recovery:SetTextSize(30)
    self.recovery:SetOnClick(function()
        SendModRPCToServer(GetModRPC("PureEconomics", "PErecovery"), self.item_name)
        if self.submit_callback then
            self.submit_callback(self.orign_price, self.orign_canbuy)
        end
        self:Hide()
        self:MoveToBack()
    end)
    self.recovery:Hide()
    self.recovery:Disable()

    local checkbox = TEMPLATES.LabelCheckbox(function(checkbox)
        checkbox.checked = not checkbox.checked
        checkbox:Refresh()
    end, false, STRINGS.PUREECOMOMICS.CHECKBOX_LABEL)
    self.checkbox = self:AddChild(checkbox)
    self.checkbox:SetPosition(180, 0, 0)
end)

function PEEdit:SetItem(name)
    local info = item_data:GetItemInfo(name)

    if not info then
        return
    end
    local price = info.price
    local checked = info.canbuy

    if not isnum(price) or not isbool(checked) then
        return
    end

    self.item_name = name

    local xml, tex = GetImage(name)

    if self.image then
        self.image:Kill()
    end

    if xml and tex then
        self.image = self.back.image:AddChild(Image(xml, tex))
    end

    self.edit:SetString(tostring(price))
    self.checkbox.checked = checked
    self.checkbox:Refresh()

    if info.origin then
        self.orign_price = info.origin.price
        self.orign_canbuy = info.origin.canbuy
        self.recovery:Show()
        self.recovery:Enable()
    else
        self.recovery:Hide()
        self.recovery:Disable()
    end

end

function PEEdit:SetSubmitCallBack(fn)
    assert(isfn(fn), "[PEEdit:SetSubmitCallBack] : fn must be lua closure")
    self.submit_callback = fn

end
return PEEdit
