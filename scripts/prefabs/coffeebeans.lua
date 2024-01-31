
local assets = {
    Asset("ANIM", "anim/coffeebeans.zip"),
}

local prefabs = {
    "coffeebeans_cooked",
    "spoiled_food",
}

local BEAN_MODIFIER = 1.15
local BEAN_DURATION = 60

local function OnEaten(inst, eater)
    if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
        return
    else 
        if eater.components.locomotor and eater.components.pecaffeinated then
            eater.components.pecaffeinated:Caffeinate(BEAN_MODIFIER, BEAN_DURATION)
        end
    end
end

local function fn(cooked)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)

        local s = 0.9
        inst.Transform:SetScale(s, s, s)
        inst.AnimState:SetBank("coffeebeans")
        inst.AnimState:SetBuild("coffeebeans")

        if cooked then
            inst.AnimState:PlayAnimation("cooked")
        else
            inst.AnimState:PlayAnimation("idle")
            inst:AddTag("cookable")
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 0
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY
        inst.components.edible.foodtype = FOODTYPE.VEGGIE

        inst:AddComponent("perishable")
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/coffeeinventory.xml"

        inst:AddComponent("bait")
        inst:AddComponent("tradable")

        if cooked then
            inst.components.edible.sanityvalue = -TUNING.SANITY_TINY
            inst.components.edible:SetOnEatenFn(OnEaten)
            inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
        else
            inst.components.edible.sanityvalue = 0
            inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
            inst:AddComponent("cookable")
            inst.components.cookable.product = "coffeebeans_cooked"
        end
        inst.components.perishable:StartPerishing()

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableLaunch(inst)

        return inst
    end
end

return Prefab("coffeebeans", fn(false), assets, prefabs),
       Prefab("coffeebeans_cooked", fn(true), assets, prefabs)
