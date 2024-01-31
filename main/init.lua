GLOBAL.isstr = function(vla) return type(vla) == "string" end
GLOBAL.isnum = function(vla) return type(vla) == "number" end
GLOBAL.isnil = function(vla) return type(vla) == "nil" end
GLOBAL.isbool = function(vla) return type(vla) == "boolean" end
GLOBAL.istbl = function(vla) return type(vla) == "table" end
GLOBAL.isfnn = function(vla) return type(vla) == "function" end
GLOBAL.isuser = function(vla) return type(vla) == "userdata" end



--从世界连接时，让主世界同步信息到从世界
if TheNet:GetIsServer() and TheShard:IsMaster() then

    local old_Shard_UpdateWorldState = GLOBAL.Shard_UpdateWorldState

    GLOBAL.Shard_UpdateWorldState = function(world_id, state, tags, world_data)
        local ready = state == REMOTESHARDSTATE.READY

        if ready then
            TheWorld.components.peworldcontext:SyncListToShard(world_id)
        end
        old_Shard_UpdateWorldState(world_id, state, tags, world_data)
    end

end