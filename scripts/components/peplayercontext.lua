local item_data = _G.pe_item_data

local remove_worly_suffix = _G.pe_context.remove_worly_suffix
local iscoin = _G.pe_context.iscoin

local function oncashchanged(self,cash,old_cash)
	self.inst.replica.peplayercontext:SetCash(cash)
end

local function ondepositchanged(self,cash,old_cash)
	self.inst.replica.peplayercontext:SetDeposit(cash)
end

local PEPlayerContext = Class(function(self, inst)
    self.inst = inst
    self.cash = 0
    self.deposit = 0
    self.multiple = {}
    self.discount = 0
end,
nil,
{
	["cash"]=oncashchanged,
	["deposit"]=ondepositchanged,
})

function PEPlayerContext:SetCash(cash)
	self.cash = cash
end

function PEPlayerContext:GetCash()
	return self.cash
end

function PEPlayerContext:DoDelta(delta)
	self.cash = self.cash + delta
	return self.cash
end

-- 返回值：返回总价，-1代表钱不够，nil代表此物品不出售
function PEPlayerContext:TryBuy(name,num)
	if not num then num = 1 end
	if item_data:IsItemCanBuy(name) then
		local single_price = item_data:GetItemPrice(name)
		if single_price then
			local total_price = single_price * num
			if total_price > self.cash then
				return -1
			else
				self:DoDelta(-total_price)
				return total_price
			end
		end
	end
	return nil
end

function PEPlayerContext:SellByInstArray(insts)
	local total_price = 0 
	for i,inst in ipairs(insts) do
		local stack_size = inst.components.stackable and inst.components.stackable.stacksize or 1
		local name = remove_worly_suffix(inst.prefab)
		local single_price = item_data:GetItemPrice(name) or 1
		local multiple = TUNING.PUREECOMOMICS.BASE_MULTIPLE

		if iscoin(inst.prefab) then
			multiple = 1
		elseif item_data:GetItemFilter(inst.prefab) == "precious" then 
			multiple = TUNING.PUREECOMOMICS.PRECIOUS_MULTIPLE
		end

		total_price = total_price + single_price * stack_size * multiple
		inst:Remove()
	end
	total_price = math.floor(total_price)
	self:DoDelta(total_price)
	return total_price
end

function PEPlayerContext:OnSave()
    local data = {}
    data.cash = self.cash
    data.deposit = self.deposit
    return data
end

function PEPlayerContext:OnLoad(data)
	if data then
		self.cash = data.cash
		self.deposit = data.deposit
	end
end


return PEPlayerContext