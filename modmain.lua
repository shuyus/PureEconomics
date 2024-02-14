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

-- tips:在专服加载modmain的时候TheNet:GetIsServer()返回false，所以使用下面的判定
IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
IsDedicated = TheNet:IsDedicated()
IsHost =  IsServer and not IsDedicated
IsMaster = IsHost or TheShard:IsMaster() --TODO 待验证

IsClientCodeArea = not IsDedicated


modimport("init/init_tuning")  --读取modinfo设置并添加到tuning
modimport("init/init_assets")  --注册素材
modimport("init/init_prefabs") --注册预制物
modimport("init/init_recipes") --材料，配方和食谱添加


if L then
	modimport("init/init_string_zh")
else
	modimport("init/init_string_zh") --TODO 英文待做
end

modimport("main/init")      --全局设置
modimport("main/debug")     --调试使用
modimport("main/rpctool")   --RPC的简单封装
SetNameSpace("PureEconomics")

dprint("modmain info",TheNet:GetIsServer(),TheNet:GetServerIsClientHosted(),TheShard:IsMaster(),TheNet:IsDedicated())

if IsMaster then --只有主世界需要加载数据
    modimport("overridelist")
    modimport("main/mod")
    modimport("main/cantsell")
end

modimport("main/trade")  --交易RPC相关
modimport("main/sync")   --同步RPC相关
modimport("main/container") -- 容器添加

if IsClientCodeArea then
	modimport("main/ui")
end

modimport("main/api")  --API调用


