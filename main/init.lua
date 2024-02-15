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
    pe_context = {} --本模组的上下文域
    G.pe_context = pe_context
    G.pe_context.mods = {}
else
    G.pe_context.mods =  G.pe_context.mods or {}
    pe_context = G.pe_context
end
pe_context.G = G
pe_context.L = L

pe_context.IsServer = IsServer
pe_context.IsDedicated = IsDedicated
pe_context.IsHost = IsHost
pe_context.IsMaster = IsMaster
pe_context.IsClientCodeArea = IsClientCodeArea

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

-- 有耐久度燃料值新鲜度的物品根据剩余百分比打折计算
function get_price_after_count_loss(inst,oriprice)
    local newprice = 0.6*oriprice

    local classified = inst.replica.inventoryitem and inst.replica.inventoryitem.classified or inst.inventoryitem_classified
    if classified then
        local percent = math.min(100,classified.percentused:value())
        newprice =  math.min(oriprice*percent,newprice)
        local percent = math.min(100,classified.perish:value())
        newprice =  math.min(oriprice*percent,newprice)
        local percent = math.min(100,classified.recharge:value())
        newprice =  math.min(oriprice*percent,newprice)
    end

    return newprice + oriprice*0.4
--[[

    local newprice = 0.6*oriprice
    if IsServer then
        if inst.components.finiteuses  then
            local percent = inst.components.finiteuses:GetPercent()
            newprice = math.min(oriprice*percent,newprice)
        end
        if inst.components.fueled  then
            local percent = inst.components.fueled:GetPercent()
            newprice = math.min(oriprice*percent,newprice)
        end
        if inst.components.armor and inst.components.armor.maxcondition > 0  then
            local percent = inst.components.armor:GetPercent()
            newprice = math.min(oriprice*percent,newprice)
        end
        if inst.components.rechargeable then
            local percent = inst.components.rechargeable:GetPercent()
            newprice = math.min(oriprice*percent,newprice)
        end
        if inst.components.perishable then
            local percent = inst.components.perishable:GetPercent()
            newprice = math.min(oriprice*percent,newprice)  
        end
    else
        local classified = inst.replica.inventoryitem and inst.replica.inventoryitem.classified or inst.inventoryitem_classified
        if classified then
            local percent = math.min(100,classified.percentused:value())
            newprice =  math.min(oriprice*percent,newprice)
            local percent = math.min(100,classified.perish:value())
            newprice =  math.min(oriprice*percent,newprice)
            local percent = math.min(100,classified.recharge:value())
            newprice =  math.min(oriprice*percent,newprice)
        end
    end

    return newprice + oriprice*0.4
]]

end

pe_context.remove_worly_suffix = remove_worly_suffix
pe_context.iscoin = iscoin
pe_context.get_price_after_count_loss = get_price_after_count_loss

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
local PEService = require("PEservice")
item_data = PEItemData()
pe_service = PEService()
G.pe_item_data = item_data
G.pe_service = pe_service


function Caculate_Sell_Price(inst)
    local stack_size = inst.components.stackable and inst.components.stackable.stacksize or 1
    local name = remove_worly_suffix(inst.prefab)
    local single_price = item_data:GetItemPrice(name) or 1
    single_price = get_price_after_count_loss(inst, single_price)
    local multiple = item_data:GetItemSellRate(name)
    return single_price * stack_size * multiple
end

pe_context.Caculate_Sell_Price = Caculate_Sell_Price