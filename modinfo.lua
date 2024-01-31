local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文
L = false

name =L and "PureEconomics" or "纯粹经济学"
description = L and [[

]] or [[

]]
author = "勿言"
version = "1.0.0"

forumthread = ""

api_version = 10
priority = -65536

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = true
client_only_mod = false
server_only_mod = false


icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = L and {"pureeconomics"} or {"纯粹经济学"}

configuration_options = {
   	{
        name = "disablecoffee",
        label   = "添加咖啡",
        hover   = "是否加入咖啡",
        options = {
			{description = "是", data = false },
            {description = "否", data = true },
        },
        default = false,
    },{
        name = "unlock",
        label   = "解锁所有物品",
        hover   = "是否在商店中解锁所有物品",
        options = {
            {description = "是", data = true },
            {description = "否", data = false },
        },
        default = false,
    },{
        name = "disableslotmachine",
        label   = "添加抽奖机",
        hover   = "是否加入抽奖机",
        options = {
            {description = "是", data = false },
            {description = "否", data = true },
        },
        default = false,
    },
}


--[[
L and {
    {
        name = "",
        label   = "",
        hover   = "",
        options = {
            {description = "", data = 0},
        },
        default = 0,
    },
} or


]]