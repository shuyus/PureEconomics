-- PEservice.lua
-- Author: 勿言
-- LastEdit: 2024.2.10
-- Using: context和data之间的中间层,item_data不应该直接调用context方法

local item_data =  pe_context.pe_item_data
local remove_worly_suffix  = pe_context.remove_worly_suffix
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

local PEService= Class(function(self)
    self.wait_to_commit = {}
end)

--[[
    info格式举例：
    {
        name = "log",
        price = 100,
        canbuy = false,
        filter = "resource",
        origin = { 
            name = "log",
            price = 7,
            canbuy = true,
            filter = "resource",
        },
    }
]]

function PEService:SetItemInfoWithoutSync(info)
    local name = info.name
    name = remove_worly_suffix(name)

    local item = item_data:GetItem(name)

    if not item then --增加物品
        local res = item_data:AddItem(info)
        if not res then return false end
    else --修改物品
        if IsServer and not info.origin then
            local origin = item.origin or deepcopy(item) --只保留最第一次的修改信息
            info.origin = origin
        else
            item.origin = info.origin --如果是恢复物品初始信息，服务端发送的info不含origin,但要清除掉客户端信息的origin
        end

        if info.canbuy and info.canbuy ~= item.canbuy then
            self:ChangeCanBuy(name)
        end
    
        for k, v in pairs(info) do
            item[k] = v  --只修改info里有的项目
        end
    end

    return true
end

function PEService:SetItemInfo(info,shard_sync)
    local name = info.name
    name = remove_worly_suffix(name)
    local res = self:SetItemInfoWithoutSync(info)

    if res and IsServer then
        if shard_sync==nil then shard_sync = true end
        local _info = deepcopy(item_data:GetItem(name))
        if TheWorld then
            TheWorld.components.peworldcontext:AddChanged(_info,shard_sync)
        else 
            dprint("PEItemData:SetItemInfo no TheWorld") --丢掉也可以吧......
            self.wait_to_commit[_info.name] = _info
        end
    end

    return res
end

-- 返回值为设置失败的物品数目
function PEService:SetItemInfoWithList(infos,shard_sync)
    local res = 0
    for k,info in pairs(infos) do
        local name = info.name
        name = remove_worly_suffix(name)
        if not self:SetItemInfoWithoutSync(info) then
            res = res + 1
        end
    end

    if IsServer then
        if shard_sync==nil then shard_sync = true end
        local _infos = deepcopy(infos)
        if TheWorld then
            TheWorld.components.peworldcontext:AddChangedWithList(_infos,shard_sync)
        else
            dprint("PEItemData:SetItemInfoWithList no TheWorld") --丢掉也可以吧......
            for k,v in pairs(_infos) do
                self.wait_to_commit[v.name] = v
            end
        end
        return res
    end

    return res
end


function PEService:ClearItemChange(name)
    name = remove_worly_suffix(name)
    dprint("PEService:ClearItemChange",name)
    local item = item_data:GetItem(name)

    if not item or not item.origin then
        dprint("no origin",name)
        return false
    end
    local origin = item.origin

    for k, _ in pairs(item) do
        item[k] = nil
    end

    for k, v in pairs(origin) do
        item[k] = v
    end

    if IsServer then
        TheWorld.components.peworldcontext:RemoveChanged(name,true)
    end

    return true
end


function PEService:GetWaitList()
    return self.wait_to_commit
end

function PEService:ResetWaitList()
    self.wait_to_commit = {}
    return true
end

return PEService