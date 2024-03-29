-- trade.lua
-- Author: 勿言
-- LastEdit: 2024.2.14
-- Using: 交易相关的RPC定义

local function cansell(inst)
    local str = remove_worly_suffix(inst.prefab)
    if  not inst:HasTag("nonpotatable") and 
        not inst:HasTag("irreplaceable") and
        item_data:IsItemCanSell(str) and -- 用户自定义
        not table.contains(GLOBAL.pe_context.absoulte_cant_sell,str) then --绝对不可卖
        return true
    end

    return false
end


function PESellFn(player, inst)
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

local function PEEditFn(player, name, price, canbuy)
    if not player.Network:IsServerAdmin() then return end
    if canbuy == nil then canbuy =false end
    dprint("===PEEdit",name, price, canbuy)
    if name == nil or price == nil or not isnum(price) or price<0 or not isbool(canbuy) then return end

    local info = {
        name = name,
        price = price,
        canbuy = canbuy,
    }

    pe_service:SetItemInfo(info)
end

local function PERecoveryFn(player, name)
    dprint("PErecovery",player,name,player.Network:IsServerAdmin())
    if not player.Network:IsServerAdmin() then return end
    pe_service:ClearItemChange(name)
end


RegisterServerModRPC("PEsell", PESellFn)
RegisterServerModRPC("PEbuy", PEBuyFn)
RegisterServerModRPC("PEedit", PEEditFn)
RegisterServerModRPC("PErecovery", PERecoveryFn)