GLOBAL.isstr = function(vla) return type(vla) == "string" end
GLOBAL.isnum = function(vla) return type(vla) == "number" end
GLOBAL.isnil = function(vla) return type(vla) == "nil" end
GLOBAL.isbool = function(vla) return type(vla) == "boolean" end
GLOBAL.istbl = function(vla) return type(vla) == "table" end
GLOBAL.isfn = function(vla) return type(vla) == "function" end
GLOBAL.isuser = function(vla) return type(vla) == "userdata" end

-- 从世界 连接时，让 主世界 同步信息到从世界
if TheNet:GetIsServer() and TheShard:IsMaster() then
    local old_Shard_UpdateWorldState = GLOBAL.Shard_UpdateWorldState
    GLOBAL.Shard_UpdateWorldState = function(world_id, state, tags, world_data)
        local ready = state == REMOTESHARDSTATE.READY
        if ready and TheWorld then  -- 从世界连接时，主世界可能没初始化完成，例如重置世界的时候
            TheWorld.components.peworldcontext:SyncListToShard(world_id) 
        end
        old_Shard_UpdateWorldState(world_id, state, tags, world_data)
    end
end
