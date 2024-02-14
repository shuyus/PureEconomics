-- api.lua
-- Author: 勿言
-- LastEdit: 2024.2.14
-- Using:  官方API的调用部分

AddReplicableComponent("peplayercontext")

if IsServer then
    AddPlayerPostInit(function(inst)
        inst:AddComponent("peplayercontext")
        if PE_DEBUG then inst.components.peplayercontext:SetCash(500000) end --TODO 测试代码，待删

        if inst.components.caffeinated == nil then
            inst:AddComponent("pecaffeinated")
        end

    end)
    AddPrefabPostInit("forest", function(inst) TheWorld:AddComponent("peworldcontext") end)
    AddPrefabPostInit("cave", function(inst) TheWorld:AddComponent("peworldcontext") end)
end