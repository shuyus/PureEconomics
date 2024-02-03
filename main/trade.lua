-- 去除沃利调料后物品的后缀
local function remove_worly_suffix(prefab_str)
	prefab_str=string.gsub(prefab_str,"_spice_chili","")
    prefab_str=string.gsub(prefab_str,"_spice_garlic","")
    prefab_str=string.gsub(prefab_str,"_spice_salt","")
    prefab_str=string.gsub(prefab_str,"_spice_sugar","")
    return prefab_str
end

local function iscoin(prefab_str)
	return prefab_str == "oinc_yuan" or prefab_str == "oinc10_yuan" or prefab_str == "oinc100_yuan"
end

GLOBAL.pe_context.remove_worly_suffix = remove_worly_suffix
GLOBAL.pe_context.iscoin = iscoin

if IsServer then

    -- 无视设置，绝对不可卖的物品列表
    local cannot_sell_items = {
        "chester_eyebone", --眼骨
        "glommerflower", --格罗姆花
        "hutch_fishbowl", --星空(哈奇鱼缸)
        "lucy",--露西斧(谁会卖老婆啊)
        "abigail_flower",--阿比盖尔花
        "atrium_key",--远古钥匙
        "messagebottle",--瓶中信
        "shadowheart",--暗影之心
        "moonrockseed",--天体宝球
        "terrarium",--盒中泰拉
    }

    for k,v in pairs(GLOBAL.pe_context.cantsell) do
        if isstr(v) and not table.contains(cannot_sell_items,v) then
            table.insert(cannot_sell_items,v)
        end
    end

    for i,name in pairs(cannot_sell_items) do
        item_data:SetItemCanSell(name,false)
    end

    local function cansell(inst)
        if  not inst:HasTag("nonpotatable") and 
            not inst:HasTag("irreplaceable") and 
            item_data:IsItemCanSell(remove_worly_suffix(inst.prefab)) then
            return true
        end

        return false
    end


    local function PESellFn(player, inst)
        local container = inst.components.container
        local context = player.components.peplayercontext
        local gotmoney = 0
        local inst_array = {}

        for i = 1, container:GetNumSlots() do
            local item = container:GetItemInSlot(i)
            if item~=nil then
                if cansell(item) then
                    table.insert(inst_array,item)
                end
            end
        end

        gotmoney = context:SellByInstArray(inst_array)
        if gotmoney ~=0 then
            player.components.talker:Say(STRINGS.PUREECOMOMICS.SELL_SUCCESS..gotmoney..STRINGS.PUREECOMOMICS.UNIT)
        end

    end

    AddModRPCHandler("PureEconomics", "PEsell", PESellFn)


    local function PEBuyFn(player, name, ismultiple, lastskin)
        local num = ismultiple and 10 or 1
        local context = player.components.peplayercontext
        local costs = context:TryBuy(name, num)

        if costs and costs>=0 then
            for i=1,num do
                local item = SpawnPrefab(name, lastskin, nil, player.userid)
                player.components.inventory:GiveItem(item, nil, player:GetPosition())
            end
        end
    end

    AddModRPCHandler("PureEconomics", "PEbuy", PEBuyFn)


    local function PEEdit(player, name, price, canbuy)
        if not player.Network:IsServerAdmin() then return end
        if canbuy == nil then canbuy =false end
        dprint("===PEEdit",name, price, canbuy)
        if name == nil or price == nil or not isnum(price) or price<0 or not isbool(canbuy) then return end

        local info = {
            name = name,
            price = price,
            canbuy = canbuy,
        }

        pe_item_data:SetItemInfo(info)
    end

    AddModRPCHandler("PureEconomics", "PEedit", PEEdit)


    local function PErecovery(player, name)
        dprint("PErecovery",player,name,player.Network:IsServerAdmin())
        if not player.Network:IsServerAdmin() then return end
        pe_item_data:ClearItemChange(name)
    end

    AddModRPCHandler("PureEconomics", "PErecovery", PErecovery)

else
    local __blank = function()end
    AddModRPCHandler("PureEconomics", "PEsell", __blank)
    AddModRPCHandler("PureEconomics", "PEbuy", __blank)
    AddModRPCHandler("PureEconomics", "PEedit", __blank)
    AddModRPCHandler("PureEconomics", "PErecovery", __blank)
end
