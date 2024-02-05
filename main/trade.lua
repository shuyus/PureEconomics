
if IsServer then
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
