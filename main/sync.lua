local function PEClientSyncAll(dumpdata)
	local success, info_list = RunInSandbox(dumpdata)
	if success and string.len(dumpdata) > 0 then
		for name,info in pairs(info_list) do
			pe_item_data:SetItemInfo(info)
		end
	end
end

local function PEShardSyncAll(id, dumpdata)
	if dumpdata and id~=TheShard:GetShardId() then
		local success, info_list = RunInSandbox(dumpdata)
		if success and string.len(dumpdata) > 0 then
			for name,info in pairs(info_list) do
				pe_item_data:SetItemInfo(info)
			end
		end
	end
end

local function PEClientSimpleSync(name, price, canbuy)
	if price then
		
		if canbuy == nil then canbuy =false end
		print("ClientSync",name,price,canbuy)
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy})
	end
end

local function PEShardSimpleSync(id, name, price, canbuy)
	if price and id~=TheShard:GetShardId() then
		
		if canbuy == nil then canbuy =false end
		print("ShardSync",name,price,canbuy)
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy})
		TheWorld.components.peworldcontext:SyncToClient(name)
	end
end

local function PEClientSync(dumpdata)
	local success, info = RunInSandbox(dumpdata)
	if success and string.len(dumpdata) > 0 then
		pe_item_data:SetItemInfo(info)
	end
end

local function PEShardSync(id, dumpdata)
	if dumpdata and id~=TheShard:GetShardId() then
		local success, info = RunInSandbox(dumpdata)
		if success and string.len(dumpdata) > 0 then
			pe_item_data:SetItemInfo(info)
		end
	end
end

AddClientModRPCHandler("PureEconomics", "PEclientsyncall", PEClientSyncAll) 
AddShardModRPCHandler("PureEconomics", "PEshardsyncall", PEShardSyncAll) 
AddClientModRPCHandler("PureEconomics", "PEclientsimplesync", PEClientSimpleSync) 
AddShardModRPCHandler("PureEconomics", "PEshardsimplesync", PEShardSimpleSync) 
AddClientModRPCHandler("PureEconomics", "PEclientsync", PEClientSync) 
AddShardModRPCHandler("PureEconomics", "PEshardsync", PEShardSync) 
