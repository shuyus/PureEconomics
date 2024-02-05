G = {} --为了避免莫名其妙的strict限制
setmetatable(G,{
    ["__newindex"] = function(t, k, v)
        GLOBAL.global(k) 
        GLOBAL.rawset(GLOBAL, k, v)
    end,
    ["__index"] = function(t, k)
        return GLOBAL.rawget(GLOBAL,k)
    end
})

if G.pe_context == nil then
    pe_context = {} --本模组的上下文
    G.pe_context = pe_context
    G.pe_context.mods = {}
else
    G.pe_context.mods =  G.pe_context.mods or {}
    pe_context = G.pe_context
end
pe_context.G = G


pe_context.IsServer = IsServer

function remove_worly_suffix(prefab_str) -- 去除沃利调料后物品的后缀
	prefab_str=string.gsub(prefab_str,"_spice_chili","")
    prefab_str=string.gsub(prefab_str,"_spice_garlic","")
    prefab_str=string.gsub(prefab_str,"_spice_salt","")
    prefab_str=string.gsub(prefab_str,"_spice_sugar","")
    return prefab_str
end

function iscoin(prefab_str)
	return prefab_str == "oinc_yuan" or prefab_str == "oinc10_yuan" or prefab_str == "oinc100_yuan"
end

pe_context.remove_worly_suffix = remove_worly_suffix
pe_context.iscoin = iscoin

G.isstr = function(vla) return type(vla) == "string" end
G.isnum = function(vla) return type(vla) == "number" end
G.isnil = function(vla) return type(vla) == "nil" end
G.isbool = function(vla) return type(vla) == "boolean" end
G.istbl = function(vla) return type(vla) == "table" end
G.isfn = function(vla) return type(vla) == "function" end
G.isuser = function(vla) return type(vla) == "userdata" end



-- 从世界 连接时，让 主世界 同步信息到从世界
if IsServer and TheShard:IsMaster() then
    local old_Shard_UpdateWorldState = GLOBAL.Shard_UpdateWorldState
    GLOBAL.Shard_UpdateWorldState = function(world_id, state, tags, world_data)
        local ready = state == REMOTESHARDSTATE.READY
        if ready and TheWorld then  -- 从世界连接时，主世界可能没初始化完成，例如重置世界的时候
            local context = TheWorld.components.peworldcontext
            dprint("Shard_UpdateWorldState: Sync",world_id)
            context:SyncListToShard(context.changed, world_id) 
            context:SyncCanSellListToShard(world_id)
        end
        old_Shard_UpdateWorldState(world_id, state, tags, world_data)
    end
end

local pe_upvaluehelper = require("3rd/PEupvaluehelper")
G.pe_upvaluehelper = pe_upvaluehelper

local PEItemData = require("PEitemdata") --核心组件，储存所有商品信息，计算合成品价格
item_data = PEItemData()
G.pe_item_data = item_data