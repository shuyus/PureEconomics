dprint("mod.lua loaded")

local name_list = {
    "overrides",
    "additems",
    "addfilter",
}


do   -- 先应用模组修改
    
    for _,n in ipairs(name_list) do
        GLOBAL.pe_context[n] = {}
    end
    GLOBAL.pe_context.cantsell = {}

   
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

end

local filename = "mod_config_data/overridelist.lua"

local function LoadModOverrideList()
    for n,t in pairs(GLOBAL.pe_context.this) do
        for _,s in ipairs(t) do
            GLOBAL.pe_context[n]["name"] = s
        end 
    end
    
    for _,name in ipairs(GLOBAL.pe_context.this.cantsell) do
        table.insert(GLOBAL.pe_context.cantsell,name)
    end 

    local dumpdata = DataDumper(GLOBAL.pe_context.this, nil, true)
    TheSim:SetPersistentString(filename, dumpdata)
end



TheSim:GetPersistentString(filename, function(load_success, str)
    if load_success and string.len(str) > 0 then  --再试图读取存档目录下的覆盖表
        local success, loaded_this = RunInSandbox(str)
        if success then
            GLOBAL.pe_context.this = loaded_this
        else
            LoadModOverrideList()
        end
    else --没有就应用模组文件的overridelist文件并写入到存档目录
        LoadModOverrideList()
    end
end)














