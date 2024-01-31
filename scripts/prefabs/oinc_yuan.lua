local assets=
{
	Asset("ANIM", "anim/pig_coin.zip"),
    Asset("ANIM", "anim/pig_coin_silver.zip"),
    Asset("ANIM", "anim/pig_coin_jade.zip"),
}

local prefabs =
{

}


local function MakeCoin(name,buildname,master_postinit,common_postinit)

    local function fn()

        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        
        inst.AnimState:SetBank("coin")
        inst.AnimState:SetBuild(buildname)
        inst.AnimState:PlayAnimation("idle")
        
        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "med", 0.05, 0.68)

        inst.entity:SetPristine()

        if common_postinit~=nil then
            common_postinit(inst)
        end

        if not TheWorld.ismastersim then
            return inst
        end
        
        inst:AddComponent("inspectable")
        
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("bait")
        inst:AddTag("molebait")

        inst:AddComponent("tradable")
        inst:AddTag("oinc")

        
        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name,fn,assets,prefabs)
    
end


return MakeCoin("oinc_yuan","pig_coin"),
       MakeCoin("oinc10_yuan","pig_coin_silver"),
       MakeCoin("oinc100_yuan","pig_coin_jade")