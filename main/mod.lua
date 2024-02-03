dprint("mod.lua loaded")

local name_list = {
    "overrides",
    "additems",
    "addfilter",
}

for _,n in ipairs(name_list) do
    GLOBAL.pe_context[n] = {}
end
GLOBAL.pe_context.cantsell = {}

-- 模组修改
for _,mc in pairs(GLOBAL.pe_context.mods) do
    for n,t in pairs(mc) do
        if table.contains(name_list, n) then
            for _,s in ipairs(t) do
                GLOBAL.pe_context[n]["name"] = s
            end
        end
    end
end

for _,mc in pairs(GLOBAL.pe_context.mods) do
    if mc.cantsell then
        for _,name in ipairs(mc.cantsell) do
            table.insert(GLOBAL.pe_context.cantsell,name)
        end
    end
end

-- 服务器修改
for n,t in pairs(GLOBAL.pe_context.this) do
    for _,s in ipairs(t) do
        GLOBAL.pe_context[n]["name"] = s
    end 
end

for _,name in ipairs(GLOBAL.pe_context.this.cantsell) do
    table.insert(GLOBAL.pe_context.cantsell,name)
end 







