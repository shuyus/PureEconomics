纯粹经济学

本模组基于简单经济学的思路开发
美术素材源于饥荒单机版和饥荒联机版
物品信息基于简单经济学模组和其衍生改版模组加工
引用的第三方代码模块位于scripts/3rd下

如果你是玩家或是服主，想修改物品价格或是添加其它模组物品到商店，请参考同级目录下的peoverridelist.lua文件中的说明并在文件内做出修改。
该修改文件不需要分发给其他玩家，只需要主机留存有修改文件，修改的信息会在游戏初始化后自动同步到其它玩家的客户端。
玩得愉快

如果你是模组作者，想要让自己的模组作品出现在本商店内，请把下列代码复制到你的modmain中，替换yourmodname并参照格式编写修改表
GLOBAL.global("pe_context")
if GLOBAL.pe_context == nil then
    pe_context = {}
    GLOBAL.pe_context = pe_context
    GLOBAL.pe_context.mods = {}
else
    GLOBAL.pe_context.mods =  GLOBAL.pe_context.mods or {}
    pe_context = GLOBAL.pe_context
end

GLOBAL.pe_context.mods.yourmodname = {}  --yourmodname换成你的模组名称(随便取个名字也行)
local context = GLOBAL.pe_context.mods.yourmodname

--参照peoverridelist.lua内的格式填写下面三个表
context.overrides = {

}

context.this.additems = {

}

context.this.cantsell = {

}



2024.2 BY 勿言
