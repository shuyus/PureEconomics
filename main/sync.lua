-- peplayercontext.lua
-- Author: 勿言
-- LastEdit: 2024.2.2
-- Using: 定义了客户端和世界同步需要的RPC

-- 数据序列化可以使用DataDumper或json，本模组采用DataDumper(fastmode)
-- 使用PEitemlist.lua的数据经过本地测试得知，DataDumper(fastmode)+RunInSandbox的组合性能明显优于json.encode+json.decode
-- DataDumper(fastmode)在万次测试下的效率是json.encode的2倍
-- RunInSandbox在万次测试下的效率是json.decode的13.75倍

local function PEClientSyncAll(dumpdata)
	dprint("ClientSyncAll",dumpdata)
	if TheNet:GetIsServer() then return end  --不开洞的房主自己就是服务端，不需要执行
	local success, info_list = RunInSandbox(dumpdata)
	dprint(success,info_list)
	if success and string.len(dumpdata) > 0 then
		
		for name,info in pairs(info_list) do
			pe_item_data:SetItemInfo(info)
		end
	end
end


local function PEClientSimpleSync(name, price, canbuy)
	dprint("ClientSimpleSync",name,price,canbuy)
	if not TheNet:GetIsServer() and price then
		if canbuy == nil then canbuy =false end
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy})
	end
end

local function PEClientSync(dumpdata)
	dprint("Client Sync",dumpdata)
	if TheNet:GetIsServer() then return end
	local success, info = RunInSandbox(dumpdata)
	dprint(success,info)
	if success and string.len(dumpdata) > 0 then
		pe_item_data:SetItemInfo(info)
	end
end


local function PEClientPreciousSync(dumpdata)
	dprint("Client Precious Sync",dumpdata)
	if TheNet:GetIsServer() then return end
	local success, array = RunInSandbox(dumpdata)
	dprint(success,array)
	if success and string.len(dumpdata) > 0 then
		ThePlayer.replica.peplayercontext:SetPreciousArray(array) --TODO ThePlayer is nil
	end
end

local function PEShardSyncAll(id, dumpdata)
	dprint("===shard all sync",id,dumpdata)
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
	dprint("Shard simple Sync",id,name,price,canbuy)
	if price and id~=tonumber(TheShard:GetShardId()) then
		if canbuy == nil then canbuy =false end
		pe_item_data:SetItemInfo({name=name,price=price,canbuy=canbuy},false)
	end
end


local function PEShardSync(id, dumpdata)
	dprint("===shard sync",id,dumpdata)
	if dumpdata and id~=tonumber(TheShard:GetShardId()) then
		local success, info = RunInSandbox(dumpdata)
		if success and string.len(dumpdata) > 0 then
			pe_item_data:SetItemInfo(info,false)
		end
	end
end

AddClientModRPCHandler("PureEconomics", "PEclientsyncall", PEClientSyncAll) 
AddClientModRPCHandler("PureEconomics", "PEclientsimplesync", PEClientSimpleSync) 
AddClientModRPCHandler("PureEconomics", "PEclientsync", PEClientSync) 

AddClientModRPCHandler("PureEconomics", "PEclientprecioussync", PEClientPreciousSync) 

AddShardModRPCHandler("PureEconomics", "PEshardsyncall", PEShardSyncAll) 
AddShardModRPCHandler("PureEconomics", "PEshardsimplesync", PEShardSimpleSync) 
AddShardModRPCHandler("PureEconomics", "PEshardsync", PEShardSync) 




