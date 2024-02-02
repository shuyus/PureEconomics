-- peworldcontext.lua
-- Author: 勿言
-- LastEdit: 2024.2.1
-- Using:   item_data修改的数据由此组件通过RPC同步给客户端
--          玩家加入时，世界发生RPC到客户端更新
--          从世界 连接时 主世界 推送数据更新，该功能hook了Shard_UpdateWorldState，参见main/init.lua文件
--          任何一个世界改变物品信息会发RPC到其它世界，其它世界各自发送RPC到客户端

local item_data = _G.pe_item_data
local override_list = pe_context.overrides

local function OnPlayerJoined(world, player)
    local context = world.components.peworldcontext
    if context then
        context:SyncListToClient(player.userid)
    end
end

--[[

]]
local PEWorldContext = Class(function(self, world)
    self.inst = world
    self.changed = {} -- 储存物品修改信息的列表,由item_data元素的深拷贝得来
    self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)

    self:Init()

    self.inst:DoTaskInTime(.1,function()
        self:SyncListToClient()
        self:SyncListToShard()
    end)
end)

-- 组件初始化时先应用覆盖列表的信息，若是加载则再执行OnLoad，完成后再同步
function PEWorldContext:Init()
    for i, v in ipairs(override_list) do
        item_data:SetItemInfoWithoutSync(v)
        self.changed[v.name] = v
    end
end

-- 这个方法只应该由item_data调用
function PEWorldContext:AddChanged(tbl,shard_sync)
    assert(type(tbl) == "table", "[PEWorldContext:AddChanged]: tbl is not table")
    self.changed[tbl.name] = tbl
    self:SyncToClient(tbl.name)
    if shard_sync then
        self:SyncToShard(tbl.name)
    end
end

-- 这个方法只应该由item_data调用
function PEWorldContext:RemoveChanged(name,shard_sync)
    if self.changed[name] then
        self:SyncToClient(name)
        if shard_sync then
            self:SyncToShard(name)
        end
        self.changed[name] = nil
    end
end


function PEWorldContext:SyncToClient(name, userid)
    if ThePlayer and ThePlayer.userid == userid then return end  --不开洞的房主不需要给自己发
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
        SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsync"), shardid, DataDumper(info, nil, true))
    else
        SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsimplesync"), shardid, info.name, info.price,
            info.canbuy)
    end

    return true
end

function PEWorldContext:SyncListToClient(userid)
    if ThePlayer and ThePlayer.userid == userid then return end
    SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsyncall"), userid, DataDumper(self.changed, nil, true))
end

function PEWorldContext:SyncListToShard(shardid)
    SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsyncall"), shardid, DataDumper(self.changed, nil, true))
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
    end
end

return PEWorldContext
