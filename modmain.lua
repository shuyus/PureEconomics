--局部化
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
_G = GLOBAL
type,tostring,tonumber,pairs,ipairs,table,next,string,unpack = type,_G.tostring,_G.tonumber,pairs,ipairs,_G.table,_G.next,string,_G.unpack
Point,Vector3,TheNet,STRINGS,TUNING = _G.Point,_G.Vector3,_G.TheNet,_G.STRINGS,_G.TUNING
SpawnPrefab,TheSim =  _G.SpawnPrefab,_G.TheSim

--中文判定
L = false
local loc = require "languages/loc"
local lan = loc.GetLanguage()
if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL or lan == LANGUAGE.CHINESE_T then
    L = true
end

-- tips:在专服加载modmain的时候TheNet:GetIsServer()返回false
IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

modimport("init/init_tuning")  --读取modinfo设置
modimport("init/init_assets")
modimport("init/init_prefabs")
modimport("init/init_recipes") --材料添加，食谱添加


if L then
	modimport("init/init_string_zh")
else
	modimport("init/init_string_zh") --TODO 英文待做
end

modimport("main/init") 
modimport("main/debug") --调试使用


if IsServer then
    
    dprint("modmain info",TheNet:GetIsServer(),TheNet:GetServerIsClientHosted(),TheShard:IsMaster(),TheNet:IsDedicated())
    if not TheNet:IsDedicated() or TheShard:IsMaster() then --只有主世界需要加载数据
        modimport("overridelist")
        modimport("main/mod")
        modimport("main/cantsell")
    end

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



modimport("main/trade")  --交易RPC相关
modimport("main/sync")   --同步RPC相关
modimport("main/container") -- 容器添加

AddReplicableComponent("peplayercontext")

if not TheNet:IsDedicated() then
	modimport("main/ui")
end


