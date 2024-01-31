-- NOTE(勿言)：这个文件我不知道从谁哪里得到的

local replace_tbl = {
    ["rock_avocado_fruit"] = "rock_avocado_fruit_rockhard",
}
local img_cache = {}
local cant_find = {}

local function GetImage(input)       
    local name = replace_tbl[input] or input
    local t = name
    if t:sub(-4):lower() ~= ".tex" then
        t = t..".tex"
    end

    if cant_find[name] then
        return nil,nil
    end
    if img_cache[name] then
        return img_cache[name].atlas,img_cache[name].image
    end
    
    if TheSim:AtlasContains("images/inventoryimages.xml", t) then
        img_cache[name] ={ atlas = "images/inventoryimages.xml",image=t}
        return "images/inventoryimages.xml",t
    elseif TheSim:AtlasContains("images/inventoryimages1.xml", t) then
        img_cache[name] = { atlas = "images/inventoryimages1.xml",image=t}
        return "images/inventoryimages1.xml",t
    elseif TheSim:AtlasContains("images/inventoryimages.xml", 'quagmire_'..t) then
        img_cache[name] ={ atlas = "images/inventoryimages.xml",image='quagmire_'..t}
        return "images/inventoryimages.xml",'quagmire_'..t
    elseif TheSim:AtlasContains("images/inventoryimages1.xml", 'quagmire_'..t) then
        img_cache[name] = { atlas = "images/inventoryimages1.xml",image='quagmire_'..t}
        return "images/inventoryimages1.xml",'quagmire_'..t
    elseif TheSim:AtlasContains("images/inventoryimages2.xml", t) then
        img_cache[name] ={ atlas =  "images/inventoryimages2.xml",image=t}
        return "images/inventoryimages2.xml",t
    elseif TheSim:AtlasContains("images/inventoryimages3.xml", t) then
        img_cache[name] ={ atlas =  "images/inventoryimages3.xml",image=t}
        return "images/inventoryimages3.xml",t
    else
        if Prefabs[name] then
            local assets = Prefabs[name].assets or {}
            for ak,av in pairs(assets) do
                if type(av) == "table" and av.type and av.file and av.type == "ATLAS"  then
                    if TheSim:AtlasContains(av.file, t) then
                        img_cache[name] = { atlas = av.file,image=t}
                        return av.file,t
                    end
                end
            end
        end
        
        local test_atlas = softresolvefilepath("images/inventoryimages/"..name..".xml")
        if test_atlas and TheSim:AtlasContains(test_atlas, t) then
            img_cache[name] = { atlas = "images/inventoryimages/"..name..".xml",image=t}
            return "images/inventoryimages/"..name..".xml",t
        end
        test_atlas = GetInventoryItemAtlas(t,true)
        if test_atlas and TheSim:AtlasContains(test_atlas, t) then
            img_cache[name] ={ atlas =  test_atlas,image=t}
            return test_atlas,t
        end
        test_atlas = softresolvefilepath("images/"..name..".xml")
        if test_atlas and TheSim:AtlasContains(test_atlas, t) then
            img_cache[name] ={ atlas =  "images/"..name..".xml",image=t}
            return "images/"..name..".xml",t
        end


        if PREFABDEFINITIONS[name] then
            for idx,asset in ipairs(PREFABDEFINITIONS[name].assets) do
              if asset.type == "ATLAS" then
                test_atlas = asset.file
              end
            end
        end 
        if test_atlas and TheSim:AtlasContains(softresolvefilepath(test_atlas), t) then
            img_cache[name] = { atlas = test_atlas,image=t}
            return test_atlas,t
        end 
        
        if test_atlas and TheSim:AtlasContains(softresolvefilepath(test_atlas), 'quagmire_'..t) then
            img_cache[name] = { atlas = test_atlas,image='quagmire_'..t}
            return test_atlas,'quagmire_'..t
        end 
        
        for k,v in pairs(Prefabs) do
            if k and k:match("MOD_") then
                local assets = v.assets or {}
                for ak,av in pairs(assets) do
                    if type(av) == "table" and av.type and av.file and av.type == "ATLAS"  then
                        if TheSim:AtlasContains(av.file, t) then
                            img_cache[name] = { atlas = av.file,image=t}
                            return av.file,t
                        end
                    end
                end
            end
        end
        cant_find[name] = name
    return nil,nil
    end
end

return GetImage