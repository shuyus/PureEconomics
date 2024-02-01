-- PEitemdata.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 负责所有物品数据的储存和管理，同步价格的功能由 PEWorldContext 组件 完成

local LIST = require("PEitemlist")
local TAB_ALL = {} -- 已定义价格物品列表，所有的价格查询都在这个表
local TAB_UNPRICED = {} -- 文件未定义价格物品列表


local PEItemData = Class(function(self)
    self.filters = {} -- 物品类别的可购买物品计数表
    self.special_filters = {} -- 特殊分类，不参与主面板的购买
    self.filter_num = 0 -- 面板显示的分类数量，不包括特殊分类
    self.noprice = {} -- 价格全部计算完成后仍然无价格物品列表，正常情况下CaculatePrice完成后该列表和TAB_UNPRICED都为空
    self.cannotbuy = {} -- 有价格但不能买的物品列表
    self:Init()

end)

--[[
调用CaculatePrice时，确保name代表的物品可合成并且在TAB_UNPRICED里，不在noprice里
价格迭代时，新计算出价格的物品会被加入TAB_ALL
CaculatePrice函数返回0代表物品合成表内有PEitemlist没有定义到的东西
]]
function PEItemData:CaculatePrice(name) --
    local filter = TAB_UNPRICED[name].filter
    local recipe = AllRecipes[name]
    if recipe == nil then
        TAB_UNPRICED[name] = nil
        RemoveByValue(self[filter], TAB_UNPRICED[name])
        self.filters[filter] = self.filters[filter] - 1
        self.noprice[name] = true
        return 0
    end
    local price = 0
    for i, ingredient in ipairs(recipe.ingredients) do
        local iname = ingredient.type
        if self.noprice[iname] then
            return 0
        end

        local query_price = TAB_ALL[iname] and TAB_ALL[iname].price
        if query_price == nil then
            if TAB_UNPRICED[iname] then
                query_price = self:CaculatePrice(iname)
                if query_price == 0 then
                    TAB_UNPRICED[name] = nil
                    RemoveByValue(self[filter], TAB_UNPRICED[name])
                    self.filters[filter] = self.filters[filter] - 1
                    self.noprice[name] = true
                    return 0
                end
            else
                self.noprice[name] = true
                return 0
            end
        end
        price = price + query_price * ingredient.amount * 1.5
    end
    price = math.ceil(price / (recipe.numtogive or 1))
    TAB_ALL[name] = TAB_UNPRICED[name]
    TAB_UNPRICED[name] = nil
    TAB_ALL[name].price = price
    return price
end

--[[
将PEitemlist定义的物品根据是否定义了价格分为两组TAB_ALL和TAB_UNPRICED
]]
function PEItemData:Init()
    for f, v in pairs(LIST) do
        self:AddFilter(f)
        self[f] = {} -- 商店面板使用的分类表
        for i, t in ipairs(v) do
            local name = t.name
            if t.canbuy == nil then
                t.canbuy = true
            end
            t.filter = f
            if TUNING.PUREECOMOMICS.UNLOCKEVERYTHING then t.canbuy = true end
            table.insert(self[f], t)
            if t.canbuy then
                self.filters[f] = self.filters[f] + 1
            else
                self.cannotbuy[name] = t
            end
            if t.price == nil then
                TAB_UNPRICED[name] = t
            else
                TAB_ALL[name] = t
            end
        end
    end

    for name, v in pairs(TAB_UNPRICED) do
        self:CaculatePrice(name)
    end

    self:AddSpecial("special")
    self:AddSpecial("blueprint")

    if TUNING.PUREECOMOMICS.DISABLECOFFEE then
        RemoveByValue(self.special, TAB_ALL["coffee"])
        RemoveByValue(self.specialall, TAB_ALL["coffee"])
        TAB_ALL["coffee"] = nil
    end
end

function PEItemData:AddSpecial(filter)
    self.special_filters[filter] = true
    self.filter_num = self.filter_num - 1
end

function PEItemData:RemoveSpecial(filter)
    self.special_filters[filter] = nil
    self.filter_num = self.filter_num + 1
end

function PEItemData:AddFilter(name, isspecial)
    if self[name] then
        return
    end
    self.filters[name] = 0
    self.filter_num = self.filter_num + 1
    self[name] = {}
    if isspecial then
        self:AddSpecial(name)
    end
end

function PEItemData:AddItem(name, filter, price, canbuy)
    if canbuy == nil then
        canbuy = true
    end
    if self[filter] == nil then
        self:AddFilter(filter)
    end
    
    local info = {
        name = name,
        price = price,
        filter = filter,
        canbuy = canbuy
    }

    table.insert(self[filter], info)
    if not canbuy then
        self.cannotbuy[name] = info
    else
        self.filters[filter] = self.filters[filter] + 1
    end

    TAB_ALL[name] = info
    if self.noprice[name] then
        self.noprice[name] = nil
    end

end

function PEItemData:ChangeCanBuy(name)
    if TAB_ALL[name].canbuy then
        TAB_ALL[name].canbuy = false
        self.cannotbuy[name] = TAB_ALL[name]
    else
        TAB_ALL[name].canbuy = true
        self.cannotbuy[name] = nil
    end
end

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
function PEItemData:SetItemInfoWithoutSync(info)
    local name = info.name

    if TAB_ALL[name] then
        if TheNet:GetIsServer() and not info.origin then
            local origin = TAB_ALL[name].origin or deepcopy(TAB_ALL[name]) --只保留最第一次的修改信息
            info.origin = origin
        else
            TAB_ALL[name].origin = info.origin --如果是恢复物品初始信息，服务端发送的info不含origin,但要清除掉客户端信息的origin
        end

        if info.canbuy and info.canbuy ~= TAB_ALL[name].canbuy then
            self:ChangeCanBuy(name)
        end

        for k, v in pairs(info) do
            TAB_ALL[name][k] = v  --只修改info里有的项目
        end
        
        return true
    end

    return false
end

--服务端调用此方法会触发到客户端和其它世界的同步
function PEItemData:SetItemInfo(info,shard_sync)
    local name = info.name
    if not TAB_ALL[name] then
        return false
    end

    if self:SetItemInfoWithoutSync(info) and TheNet:GetIsServer() then
        if shard_sync==nil then shard_sync = true end
        local _info = deepcopy(TAB_ALL[name])
        TheWorld.components.peworldcontext:AddChanged(_info,shard_sync)
        return true
    end

    return false
end



function PEItemData:ClearItemChange(name)
    if not TAB_ALL[name] or not TAB_ALL[name].origin then
        return false
    end
    local obj = TAB_ALL[name]
    local origin = obj.origin

    for k, _ in pairs(obj) do
        obj[k] = nil
    end

    for k, v in pairs(origin) do
        obj[k] = v
    end

    if TheNet:GetIsServer() then
        TheWorld.components.peworldcontext:RemoveChanged(name,true)
    end

    return true
end

function PEItemData:GetItem(name)
    return TAB_ALL[name]
end

--返回信息的深拷贝
function PEItemData:GetItemInfo(name)
    return TAB_ALL[name] and deepcopy(TAB_ALL[name])
end

function PEItemData:GetItemFilter(name)
    if TAB_ALL[name] then
        return TAB_ALL[name].filter
    end
    return nil
end

function PEItemData:GetItemPrice(name)
    if TAB_ALL[name] then
        return TAB_ALL[name].price
    end
    return nil
end

function PEItemData:GetItemsOfFilter(filter)
    return self[filter]
end

function PEItemData:GetBuyableItemNumOfFilter(filter)
    return self.filters[filter] or 0
end

function PEItemData:IsItemCanBuy(name)
    return TAB_ALL[name] and TAB_ALL[name].canbuy
end

function PEItemData:RemoveItem(name)
    self.noprice[name] = true
    local filter = TAB_ALL[name].filter
    if not TAB_ALL[name].canbuy then
        self.cannotbuy[name] = info
    else
        self.filters[filter] = self.filters[filter] + 1
    end
    RemoveByValue(self[filter], TAB_ALL[name])
    TAB_ALL[name] = nil
    if next(self[filter]) == nil then
        self[filter] = nil
        self.filters[filter] = nil
        self.filter_num = self.filter_num - 1
    end
end

function PEItemData:DebugPrint()
    print("===noprice=====================================")
    for name, v in pairs(self.noprice) do
        print(name)
    end
    print("===unpriced=====================================")
    for name, v in pairs(TAB_UNPRICED) do
        print(name, v.price, v.filter)
    end
end

return PEItemData
