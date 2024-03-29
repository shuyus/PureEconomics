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

server_filter_tags = L and {"pureeconomics","PE"} or {"纯粹经济学","PE"}

configuration_options = {
    {
        name = "sellmulti",
        label   = "基础售卖倍率",
        hover   = "普通物品的售卖倍率",
        options = {
			{description = "10%", data = 0.1 },
            {description = "20%", data = 0.2 },
            {description = "25%", data = 0.25 },
            {description = "30%", data = 0.3},
            {description = "40%", data = 0.4 },
            {description = "50%", data = 0.5 },
            {description = "60%", data = 0.6 },
            {description = "70%", data = 0.7 },
            {description = "75%", data = 0.75 },
            {description = "80%", data = 0.8 },
            {description = "85%", data = 0.85 },
            {description = "90%", data = 0.9 },
            {description = "100%", data = 1.0 },
        },
        default = 0.5,
    },{
        name = "precioussellmulti",
        label   = "珍贵品售卖倍率",
        hover   = "珍贵商品售卖倍率",
        options = {
			{description = "10%", data = 0.1 },
            {description = "20%", data = 0.2 },
            {description = "25%", data = 0.25 },
            {description = "30%", data = 0.3},
            {description = "40%", data = 0.4 },
            {description = "50%", data = 0.5 },
            {description = "60%", data = 0.6 },
            {description = "70%", data = 0.7 },
            {description = "75%", data = 0.75 },
            {description = "80%", data = 0.8 },
            {description = "85%", data = 0.85 },
            {description = "90%", data = 0.9 },
            {description = "100%", data = 1.0 },
        },
        default = 0.25,
    },{
        name = "preciousslot",
        label   = "珍贵品数量",
        hover   = "商店售卖的珍贵品数量",
        options = {
			{description = "全部(关闭刷新)", data = -1 },
            {description = "6格", data = 6 },
            {description = "12格", data = 12 },
            {description = "18格", data = 18 },
            {description = "22格(一页)", data = 22 },
            {description = "44格子", data = 44 },
        },
        default = 12,
    },{
        name = "preciousperiod",
        label   = "珍贵品刷新周期",
        hover   = "珍贵品多少天刷新一次",
        options = {
			{description = "1天", data = 1 },
            {description = "3天", data = 3 },
            {description = "5天", data = 5 },
            {description = "7天", data = 7 },
            {description = "15天", data = 15 },
            {description = "20天", data = 20 },
            {description = "35天", data = 35 },
            {description = "70天", data = 70 },
        },
        default = 5,
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
    },{
        name = "disablecoffee",
        label   = "添加咖啡",
        hover   = "是否加入咖啡",
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