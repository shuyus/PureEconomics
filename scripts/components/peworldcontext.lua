local item_data = _G.pe_item_data
local override_list = pe_context.overrides

local function OnPlayerJoined(world, player)
    local context = world.components.peworldcontext
    if context then
        context:SyncListToClient(player.userid)
    end
end

--[[
玩家加入时，世界发生RPC到客户端更新
从世界连接时发送RPC到主世界请求更新
任何一个改变物品信息的世界会发RPC到其它世界，其它世界各自发送RPC到客户端


]]
local PEWorldContext = Class(function(self, inst)
    self.inst = inst
    self.changed = {} -- 列表,item_data元素的深拷贝
    self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)

    self:Init()
end)

function PEWorldContext:Init()
    -- TODEL

    -- if not TheShard:IsMaster() then 
    -- 	SendModRPCToShard(GetShardModRPC("PureEconomics", "PEaskforsync"), SHARDID.MASTER)
    -- 	return 
    -- end

    for i, v in ipairs(override_list) do
        item_data:SetItemInfoWithoutSync(v)
        self.changed[v.name] = v
    end

    -- self:SyncChanged()

end

-- 这个方法只应该被item_data调用
function PEWorldContext:AddChanged(tbl)
    assert(type(tbl) == "table", "[PEWorldContext:AddChanged]: tbl is not table")
    self.changed[tbl.name] = tbl
    self:SyncToClient(tbl.name)
end

function PEWorldContext:RemoveChanged(name)
    if self.changed[name] then
        item_data:ClearItemChange(name)
        self:SyncToClient(name)
        self.changed[name] = nil
    end
end

-- 保证在item_data数据完成后
function PEWorldContext:SyncToClient(name, userid)
    local info = item_data:GetItemInfo(name)
    if not info then
        return false
    end
    local origin = info.origin
    if origin then
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsync"), userid, DataDumper(info, nil, true))
    else
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsimplesync"), userid, info.name, info.price,
            info.canbuy)
    end

    return true
end

function PEWorldContext:SyncToShard(name, shardid)
    local info = item_data:GetItemInfo(name)
    if not info then
        return false
    end
    local origin = info.origin
    if origin then
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEshardsync"), shardid, DataDumper(info, nil, true))
    else
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEshardsimplesync"), shardid, info.name, info.price,
            info.canbuy)
    end

    return true
end

function PEWorldContext:SyncListToClient(userid)
    SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsyncall"), userid, DataDumper(self.changed, nil, true))
end

function PEWorldContext:SyncListToShard(shardid)
    SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsyncall"), shardid, DataDumper(self.changed, nil, true))
end

function PEWorldContext:OnSave()
    local data = {}
    data.changed = self.changed
    return data
end

function PEWorldContext:OnLoad(data)
    if data then
        for k, v in pairs(data.changed) do
            item_data:SetItemInfoWithoutSync(v)
            self.changed[v.name] = v
        end
        self:SyncListToClient()
        self:SyncListToShard()
    end
end

return PEWorldContext
