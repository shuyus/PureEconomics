local item_data = _G.pe_item_data


local PEPlayerContext = Class(function(self, inst)
    self.inst = inst
    self.cash = net_int(inst.GUID,"pecash","pe_cash_changed")
    self.deposit = net_int(inst.GUID,"pedeposit","pe_deposit_changed")
    self.precious = {}

    if not TheNet:IsDedicated() then
        local function _onchanged()
            if ThePlayer == inst then
                local current_screen = TheFrontEnd:GetActiveScreen()
                if current_screen and current_screen.name == "PEShopScreen" then
                    current_screen.main:UpdateCash()
                end 
            end
        end
        
    	self.inst:ListenForEvent("pe_cash_changed",_onchanged)
        self.inst:ListenForEvent("pe_deposit_changed",_onchanged)
	end
end)


function PEPlayerContext:SetCash(num)
	self.cash:set(num)
end

function PEPlayerContext:GetCash()
	return self.cash:value()
end

function PEPlayerContext:SetDeposit(num)
    self.deposit:set(num)
end

function PEPlayerContext:GetDeposit()
    return self.deposit:value()
end

function PEPlayerContext:IsItemInPreciousArray(name)
	return table.contains(self.precious,name)
end

function PEPlayerContext:GetPreciousArray()
    if TheWorld.ismastersim then
        return self.inst.components.peplayercontext:GetPreciousArray()
    end
	return self.precious
end

function PEPlayerContext:SetPreciousArray(array)
    if TheWorld.ismastersim then
        self.inst.components.peplayercontext:SetPreciousArray(array)
        return
    end
    self.precious = deepcopy(array)
end



return PEPlayerContext