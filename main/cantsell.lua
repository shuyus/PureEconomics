-- cantsell.lua
-- Author: 勿言
-- LastEdit: 2024.2.14
-- Using:  不可卖物品的添加逻辑


-- 初始不可卖的物品列表
local cant_sell = {
    "lucy",--露西斧(谁会卖老婆啊)
    "abigail_flower",--阿比盖尔花
    "messagebottle",--瓶中信
    -- "shadowheart",--暗影之心  1%售卖倍率，不用禁止了

    -- "chester_eyebone", --眼骨
    -- "glommerflower", --格罗姆花
    -- "hutch_fishbowl", --星空(哈奇鱼缸)
    -- "atrium_key",--远古钥匙
    -- "moonrockseed",--天体宝球
    -- "terrarium",--盒中泰拉
    -- 不用写了，已经被irreplaceable标签过滤了
}

GLOBAL.pe_context.absoulte_cant_sell = cant_sell

for k,name in pairs(GLOBAL.pe_context.cantsell) do
    if isstr(name) then
        item_data:SetItemCanSell(name,false)
    end
end
