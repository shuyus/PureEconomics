--[[
注意：游戏内改动的优先级大于本文件

如果你对代码一窍不通，你只需要修改两条绿色虚线之间的代码即可，其它的不要动

添加示例如下：将下面一行代码复制到虚线区域，你就可以将肉串的价格修改为1000，并且可以在商店购买
{name = "kabobs", price = 1000, canbuy = true},
如果你不知道你要修改的物品name，请去scripts文件加下找到PEitemlist.lua文件，里面有物品名称注释
如果你不想让某样东西在商店购买，可以添加如下行所示的代码，这行代码让肉串不可以在商店购买
{name = "kabobs",  canbuy = false},

]]

local override_list = {

    -------------------------------------------------
    
    -------------------------------------------------
}


local add_list = {

    -------------------------------------------------
    
    -------------------------------------------------
}

GLOBAL.pe_context.overrides = override_list
GLOBAL.pe_context.addlist = add_list
override_list = nil
add_list = nil