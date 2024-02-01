local function PEClientSyncAll(dumpdata)
	print("ClientSyncAll",dumpdata)
	local success, info_list = RunInSandbox(dumpdata)
	print(success,info_list)
	if success and string.len(dumpdata) > 0 then
		
		for name,info in pairs(info_list) do
			pe_item_data:SetItemInfo(info)
		end
	end
end


local function PEClientSimpleSync(name, price, canbuy)
	print("ClientSimpleSync",name,price,canbuy)
	if price then
		if canbuy == nil then canbuy =false end
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy})
	end
end

local function PEClientSync(dumpdata)
	print("Client Sync",dumpdata)
	local success, info = RunInSandbox(dumpdata)
	print(success,info)
	if success and string.len(dumpdata) > 0 then
		pe_item_data:SetItemInfo(info)
	end
end

local function PEShardSyncAll(id, dumpdata)
	print("===shard all sync",id,dumpdata)
	if dumpdata and id~=tonumber(TheShard:GetShardId()) then
		
		local success, info_list = RunInSandbox(dumpdata)
		if success and string.len(dumpdata) > 0 then
			for name,info in pairs(info_list) do
				pe_item_data:SetItemInfo(info,false)
			end

			--TheWorld.components.peworldcontext:SyncListToClient()
		end
	end
end

local function PEShardSimpleSync(id, name, price, canbuy)
	print("Shard simple Sync",id,name,price,canbuy)
	if price and id~=tonumber(TheShard:GetShardId()) then
		if canbuy == nil then canbuy =false end
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy},false)
	end
end


local function PEShardSync(id, dumpdata)
	print("===shard sync",id,dumpdata)
	if dumpdata and id~=tonumber(TheShard:GetShardId()) then
		local success, info = RunInSandbox(dumpdata)
		if success and string.len(dumpdata) > 0 then
			pe_item_data:SetItemInfo(info,false)
		end
	end
end

AddShardModRPCHandler("PureEconomics", "PEshardsyncall", PEShardSyncAll) 
AddShardModRPCHandler("PureEconomics", "PEshardsimplesync", PEShardSimpleSync) 
AddShardModRPCHandler("PureEconomics", "PEshardsync", PEShardSync) 

AddClientModRPCHandler("PureEconomics", "PEclientsyncall", PEClientSyncAll) 
AddClientModRPCHandler("PureEconomics", "PEclientsimplesync", PEClientSimpleSync) 
AddClientModRPCHandler("PureEconomics", "PEclientsync", PEClientSync) 


