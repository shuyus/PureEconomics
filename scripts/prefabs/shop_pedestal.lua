local assets =
{
    Asset("ANIM", "anim/pedestal_crate.zip"),   
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

local prefabs =
{

}


local function onhammered(inst, worker)
    if inst.components.container then inst.components.container:DropEverything() end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onentityreplicated(inst)
    inst.replica.container:WidgetSetup("pesellpedestal")
end

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()  
    inst.entity:AddNetwork()
  
    MakeSnowCoveredPristine(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("pedestal")
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("idle_cablespool")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("shop_pedestal")
    inst:AddTag("structure")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = onentityreplicated
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("pesellpedestal")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

    return inst
end

return Prefab( "shop_pedestal", fn, assets, prefabs),
       MakePlacer("shop_pedestal_placer","pedestal","pedestal_crate","idle_cablespool")
