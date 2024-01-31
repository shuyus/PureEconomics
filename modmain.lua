--局部化
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local _G = GLOBAL
local type,tostring,tonumber,pairs,ipairs,table,next,string,unpack = type,_G.tostring,_G.tonumber,pairs,ipairs,_G.table,_G.next,string,_G.unpack
local Point,Vector3,TheNet,STRINGS,TUNING = _G.Point,_G.Vector3,_G.TheNet,_G.STRINGS,_G.TUNING
local SpawnPrefab,TheSim =  _G.SpawnPrefab,_G.TheSim

--中文判定
local L = false
local loc = require "languages/loc"
local lan = loc.GetLanguage()
if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL or lan == LANGUAGE.CHINESE_T then
    L = true
end


modimport("init/init_tuning")  --读取modinfo设置
modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/init_recipes") --材料添加，食谱添加


if L then
	modimport("init/init_string_zh")
else
	modimport("init/init_string_zh")
end

local pe_upvaluehelper = require("3rd/PEupvaluehelper")
local PEItemData = require("PEitemdata") --核心组件，包含所有商品信息，计算合成品价格
local item_data = PEItemData()
local pe_context = {} --放置小函数

GLOBAL.pe_context = pe_context
GLOBAL.pe_upvaluehelper = pe_upvaluehelper
GLOBAL.pe_item_data = item_data
GLOBAL.PE_DEBUG = true




modimport("main/init") 
modimport("main/debug")
modimport("main/trade")  --交易RPC相关
modimport("main/sync")   --同步RPC相关

modimport("main/widget") -- 容器添加

AddReplicableComponent("peplayercontext")

if not TheNet:IsDedicated() then
	modimport("main/ui")
end


if TheNet:GetIsServer() then
    modimport("overridelist")

    AddPlayerPostInit(function(inst)
        inst:AddComponent("peplayercontext")
        inst.components.peplayercontext:SetCash(500000) --TODO 删掉

        if inst.components.caffeinated == nil then
            inst:AddComponent("pecaffeinated")
        end

    end)
    AddPrefabPostInit("forest", function(inst) TheWorld:AddComponent("peworldcontext") end)
    AddPrefabPostInit("cave", function(inst) TheWorld:AddComponent("peworldcontext") end)
end
