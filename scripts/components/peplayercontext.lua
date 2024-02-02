-- peplayercontext.lua
-- Author: 勿言
-- LastEdit: 2024.2.2
-- Using: 负责用户数据的管理和珍贵品列表构建和同步

local item_data = pe_item_data
local remove_worly_suffix = pe_context.remove_worly_suffix
local iscoin = pe_context.iscoin


local function oncashchanged(self,cash,old_cash)
	self.inst.replica.peplayercontext:SetCash(cash)
end

local function ondepositchanged(self,cash,old_cash)
	self.inst.replica.peplayercontext:SetDeposit(cash)
end

local function OnCyclesChanged(inst, cycles)
	local left = inst.components.peplayercontext.buildtime_left - 1
	if left<=0 then
		inst.components.peplayercontext:BuildPreciousArray()
		left = TUNING.PUREECOMOMICS.PRECIOUS_REFRESH_PERIOD
	end
	inst.components.peplayercontext.buildtime_left = left
end

local PEPlayerContext = Class(function(self, inst)
    self.inst = inst
    self.cash = 0
    self.deposit = 0
    self.multiple = {}
	self.precious = {}
	self.buildtime_left = TUNING.PUREECOMOMICS.PRECIOUS_REFRESH_PERIOD

	if TUNING.PUREECOMOMICS.UNLOCK_PRECIOUS then return end

	self.loaded_flag = false
	self.inst:DoTaskInTime(.1,function() 			-- 在初始化时不能发送RPC，Invalid RPC sender list
		dprint("loaded flag",self.loaded_flag)		-- OnLoad发送RPC，客户端收到时，ThePlayer还不存在
		if not self.loaded_flag then
			self:BuildPreciousArray()
		else
			self:SyncPreciousToClient()
		end
	end)

	self.inst:WatchWorldState("cycles", OnCyclesChanged)
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
		if item_data:GetItemFilter(name) == "precious" and not self:IsItemInPreciousArray(name) then
			return nil
		end
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

function PEPlayerContext:IsItemInPreciousArray(name)
	return not TUNING.PUREECOMOMICS.UNLOCK_PRECIOUS or table.contains(self.precious,name)
end

function PEPlayerContext:GetPreciousArray()
	if #self.precious == 0 then
		self:BuildPreciousArray()
	end
	return deepcopy(self.precious)
end

function PEPlayerContext:SetPreciousArray(array)
    self.precious = deepcopy(array)
	if #self.precious>0 then self:SyncPreciousToClient() end
end

function PEPlayerContext:BuildPreciousArray(sync)
	local precious_list = item_data:GetItemsOfFilter("precious")
	local num = TUNING.PUREECOMOMICS.PRECIOUS_SLOT_NUM

	local pool = {}
    for i, info in ipairs(precious_list) do
        if info.canbuy then
            table.insert(pool, info.name)
        end
    end
    num = #pool <= num and #pool or num
	self.precious = PickSome(num, pool)

	if sync == nil then sync = true end
	if #self.precious>0 and sync then self:SyncPreciousToClient() end
end

function PEPlayerContext:SyncPreciousToClient()
	dprint("PEPlayerContext:SyncPreciousToClient",ThePlayer,self.inst)
	if ThePlayer and ThePlayer.userid == self.inst.userid then return end
	SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientprecioussync"), self.inst.userid, DataDumper(self.precious, nil, true))
end


function PEPlayerContext:OnSave()
	dprint("PEPlayerContext:OnSave")
    local data = {}
    data.cash = self.cash
    data.deposit = self.deposit

	if TUNING.PUREECOMOMICS.UNLOCK_PRECIOUS then return data end

	data.precious = self.precious
	data.buildtime_left = self.buildtime_left
    return data
end

function PEPlayerContext:OnLoad(data)
	dprint("PEPlayerContext:OnLoad",data)
	if data then
		self.cash = data.cash or 0
		self.deposit = data.deposit or 0

		if TUNING.PUREECOMOMICS.UNLOCK_PRECIOUS then return end

		self.precious = data.precious or {}
		self.buildtime_left = data.buildtime_left or TUNING.PUREECOMOMICS.PRECIOUS_REFRESH_PERIOD
		self.loaded_flag = true
	end
	
end


return PEPlayerContext