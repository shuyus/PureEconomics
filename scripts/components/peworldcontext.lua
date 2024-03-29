-- peworldcontext.lua
-- Author: 勿言
-- LastEdit: 2024.2.1
-- Using:   item_data修改的数据由此组件通过RPC同步给客户端
--          玩家加入时，世界发生RPC到客户端更新
--          从世界 连接时 主世界 推送数据更新，该功能hook了Shard_UpdateWorldState，参见main/init.lua文件
--          任何一个世界改变物品信息会发RPC到其它世界，其它世界各自发送RPC到客户端

local item_data = pe_item_data
local service = pe_service
local override_list = pe_context.overrides
local add_list = pe_context.additems
local filename = "mod_config_data/pe_game_change.lua"
local IsMaster = pe_context.IsMaster

local function OnPlayerJoined(world, player)
    local context = world.components.peworldcontext
    if context then
        context:SyncListToClient(context.changed,player.userid)
    end
end

local PEWorldContext = Class(function(self, world)
    self.inst = world
    self.file_changed = {}  -- overridelist修改
    self.game_changed = {} -- 储存游戏内物品修改信息的列表
    self.changed = {} -- 上面两个表的合并，game_changed会覆盖同样的设置
    self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, world)
    self:AddChangedWithList(service:GetWaitList(),false)
    service:ResetWaitList()

    if IsMaster then
        self:MasterInit()
        self.inst:DoTaskInTime(.1,function()--TODO 这里的逻辑可能会配合主动连接逻辑在重置世界时向所有世界发送两遍RPC
            self:SyncListToClient(self.changed)
            self:SyncListToShard(self.changed)
            self:SyncCanSellListToShard()
        end)
    end
end)

function PEWorldContext:MasterInit()
    dprint("PEWorldContext:MasterInit")
    for k,v in pairs(add_list) do
        service:SetItemInfoWithoutSync(v)
        local info = service:GetItemInfo(v.name)
        self.file_changed[v.name] = info
        self.changed[v.name] = info
    end

    for k, v in pairs(override_list) do
        service:SetItemInfoWithoutSync(v)
        local info = service:GetItemInfo(v.name)
        self.file_changed[v.name] = info
        self.changed[v.name] = info
    end
end

-- 这个方法只应该由service调用
function PEWorldContext:AddChanged(t,shard_sync)
    assert(type(t) == "table", "[PEWorldContext:AddChanged]: tbl is not table")
    self.game_changed[t.name] = t
    self.changed[t.name] = t
    self:SyncToClient(t.name)
    if shard_sync then
        self:SyncToShard(t.name)
    end
end

-- 这个方法只应该由service调用
function PEWorldContext:AddChangedWithList(tbls,shard_sync)
    for k,t in pairs(tbls) do
        assert(type(t) == "table", "[PEWorldContext:AddChanged]: tbl is not table")
        self.game_changed[t.name] = t
        self.changed[t.name] = t
    end

    self:SyncListToClient(tbls)
    if shard_sync then
        self:SyncListToShard(tbls)
    end
end

-- 这个方法只应该由service调用
function PEWorldContext:RemoveChanged(name,shard_sync)
    if self.changed[name] then
        self:SyncToClient(name)
        if shard_sync then
            self:SyncToShard(name)
        end
        self.file_changed[name] = nil
        self.game_changed[name] = nil
        self.changed[name] = nil
    end
end


function PEWorldContext:SyncToClient(name, userid)
    if ThePlayer and ThePlayer.userid == userid then return end  --不开洞的房主不需要给自己发
    local info = service:GetItemInfo(name)
    if not info then
        return false
    end
    local origin = info.origin
    if origin then
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsync"), userid, DataDumper(info, nil, true))
    else
        SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsimplesync"), userid, info.name, info.price,
            info.canbuy, info.sellrate)
    end

    return true
end

function PEWorldContext:SyncToShard(name, shardid)
    local info = service:GetItemInfo(name)
    if not info then
        return false
    end
    local origin = info.origin
    if origin then
        SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsync"), shardid, DataDumper(info, nil, true))
    else
        SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsimplesync"), shardid, info.name, info.price,
            info.canbuy, info.sellrate)
    end

    return true
end

function PEWorldContext:SyncListToClient(t, userid)
    if ThePlayer and ThePlayer.userid == userid then return end
    if t == nil then t = self.changed end
    SendModRPCToClient(GetClientModRPC("PureEconomics", "PEclientsyncall"), userid, DataDumper(t, nil, true))
end

function PEWorldContext:SyncListToShard(t, shardid)
    if t == nil then t = self.changed end
    SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardsyncall"), shardid, DataDumper(t, nil, true))
end

function PEWorldContext:SyncCanSellListToShard(shardid)
    SendModRPCToShard(GetShardModRPC("PureEconomics", "PEshardcansellsync"), shardid,
        DataDumper(item_data:GetCanSellList(), nil, true))
end

function PEWorldContext:PersistGameChange()
    if not IsMaster then return end

    local dumpdata = DataDumper(self.game_changed, nil, true)
    TheSim:SetPersistentString(filename, dumpdata)
end

function PEWorldContext:LoadPersistentGameChange()
    if not IsMaster then return end

    TheSim:GetPersistentString(filename, function(load_success, str)
        if load_success and string.len(str) > 0 then  
            local success, loaded = RunInSandbox(str)
            if success then
                self.game_changed = loaded
                for k,v in pairs(loaded) do
                    service:SetItemInfoWithoutSync(v)
                    self.changed[k] = v
                end

                self:SyncListToClient(self.changed)
                self:SyncListToShard(self.changed)
            end
        end
    end)
end


function PEWorldContext:OnSave()
    local data = {}
    if IsMaster then
        data.game_changed = self.game_changed
    end
    return data
end

function PEWorldContext:OnLoad(data)
    if not IsMaster then return end

    for k,v in pairs(self.file_changed) do
        self.changed[v.name] = v
    end

    if data then
        for k, v in pairs(data.game_changed) do
            service:SetItemInfoWithoutSync(v)
            self.game_changed[v.name] = v
            self.changed[v.name] = v
        end
    end

end

return PEWorldContext
