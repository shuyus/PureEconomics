local LIST = require("PEitemlist")
local TAB_ALL = {} -- 已定义价格物品列表，所有的价格查询都在这个表
local TAB_UNPRICED = {} -- 文件未定义价格物品列表

--[[
PEItemData只负责数据管理
同步价格的功能由 PEWorldContext 组件 完成
]]
local PEItemData = Class(function(self)
    self.filters = {} -- 物品类别的物品计数表
    self.special_filters = {} -- 特殊分类，不参与主面板的购买
    self.filter_num = 0 -- 面板显示的分类数量，不包括特殊分类
    self.noprice = {} -- 价格全部计算完成后仍然无价格物品列表，正常情况下CaculatePrice完成后该列表和TAB_UNPRICED都为空
    self.cannotbuy = {} -- 有价格但不能买的物品列表
    self:Init()

    self:Print() -- TODO 删除
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
        RemoveByValue(self[filter .. "all"], TAB_UNPRICED[name])
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
                    RemoveByValue(self[filter .. "all"], TAB_UNPRICED[name])
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
        self[f .. "all"] = {} -- 给管理员面板使用的分类表
        for i, t in ipairs(v) do
            local name = t.name
            if t.canbuy == nil then
                t.canbuy = true
            end
            t.filter = f
            table.insert(self[f .. "all"], t)
            if TUNING.PUREECOMOMICS.UNLOCKEVERYTHING then t.canbuy = true end
            if t.canbuy then
                self.filters[f] = self.filters[f] + 1
                table.insert(self[f], t)
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
    self.filters[filter] = self.filters[filter] + 1
    local info = {
        name = name,
        price = price,
        filter = filter,
        canbuy = canbuy
    }

    table.insert(self[filter.."all"], info)

    if canbuy then
        table.insert(self[filter], info)
    else
        self.cannotbuy[name] = info
    end

    TAB_ALL[name] = info
    if self.noprice[name] then
        self.noprice[name] = nil
    end

end

function PEItemData:ChangeCanBuy(name)
    if TAB_ALL[name].canbuy then
        TAB_ALL[name].canbuy = false
        RemoveByValue(self[TAB_ALL[name].filter], TAB_ALL[name])
        self.cannotbuy[name] = TAB_ALL[name]
    else
        TAB_ALL[name].canbuy = true
        table.insert(self[TAB_ALL[name].filter],TAB_ALL[name])
        self.cannotbuy[name] = nil
    end
end

function PEItemData:SetItemInfoWithoutSync(info)
    local name = info.name

    if TAB_ALL[name] then
        if TheNet:GetIsServer() then
            local origin = TAB_ALL[name].origin or deepcopy(TAB_ALL[name])
            info.origin = origin
        end

        if info.canbuy ~= TAB_ALL[name].canbuy then
            self:ChangeCanBuy(name)
        end

        for k, v in pairs(info) do
            TAB_ALL[name][k] = v
        end

        

        return true
    end

    return false
end

function PEItemData:SetItemInfo(info)
    local name = info.name
    if not TAB_ALL[name] then
        return false
    end

    if self:SetItemInfoWithoutSync(info) and TheNet:GetIsServer() then -- 服务端才需要记录改变
        local _info = deepcopy(TAB_ALL[name])
        TheWorld.components.peworldcontext:AddChanged(_info)

        return true
    end

    return false
end

function PEItemData:ClearItemChange(name)
    if not TAB_ALL[name] and not TAB_ALL[name].origin then
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

    return true
end

function PEItemData:GetItem(name)
    return TAB_ALL[name]
end

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
    return filter and self[filter] or self[filter.."all"]
end

function PEItemData:GetItemNumOfFilter(filter)
    return self.filters[filter] or 0
end

function PEItemData:IsItemCanBuy(name)
    return TAB_ALL[name] and TAB_ALL[name].canbuy
end

function PEItemData:RemoveItem(name)
    self.noprice[name] = true
    local filter = TAB_ALL[name].filter
    RemoveByValue(self[filter], TAB_ALL[name])
    TAB_ALL[name] = nil
    if next(self[filter]) == nil then
        self[filter] = nil
        self.filters[filter] = nil
        self.filter_num = self.filter_num - 1
    end
end

function PEItemData:Print()
    -- print("===priced=====================================")
    -- for name,v in pairs(TAB_ALL) do
    -- 	print(name,v.price,v.filter)
    -- end
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
