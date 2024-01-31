
require("prefabutil")

local assets = {
    Asset("ANIM", "anim/coffeebush.zip"),
}

local function OnDeploy(inst, pt, deployer)
    local coffeebush = SpawnPrefab("coffeebush")
    coffeebush.Transform:SetPosition(pt:Get())
    inst.components.stackable:Get():Remove()
    coffeebush.components.pickable:OnTransplant()
    deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", 0.3, 0.85)

    inst.AnimState:SetBank("coffeebush")
    inst.AnimState:SetBuild("coffeebush")
    inst.AnimState:PlayAnimation("dropped")

    inst:AddTag("deployedplant")
    inst:AddTag("wildfireprotected")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/coffeeinventory.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("dug_coffeebush", fn, assets),
       MakePlacer("dug_coffeebush_placer", "coffeebush", "coffeebush", "idle")
