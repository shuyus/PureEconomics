local assets =
{
    Asset("ANIM", "anim/pedestal_crate.zip"),   
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

local prefabs =
{

}

local item_data = pe_context.pe_item_data
local Caculate_Sell_Price = pe_context.Caculate_Sell_Price


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

local function onitemgetfn(inst,data)
    if not ThePlayer then return end
    local containerwidget = ThePlayer.HUD.controls.containers[inst]
    if not containerwidget then
        dprint("=======no containerwidget")
        return
    end
    local tileslot = containerwidget.inv[data.slot]

    if not tileslot then
        dprint("=======no tileslot")
        return
    end

    if not data.item then
        dprint("=======no data.item")
        return
    end
    local price = math.floor(Caculate_Sell_Price(data.item))
    tileslot:SetHoverText(STRINGS.PUREECOMOMICS.SELLRATE_INFO_2..tostring(price)..STRINGS.PUREECOMOMICS.UNIT)	
end

local function onitemlosefn(inst,data)
    if not ThePlayer then return end
    local containerwidget = ThePlayer.HUD.controls.containers[inst]
    if not containerwidget then
        dprint("=======no containerwidget")
        return
    end
    local tileslot = containerwidget.inv[data.slot]

    if not tileslot then
        dprint("=======no tileslot")
        return
    end

    tileslot:ClearHoverText()
end


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()  
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    inst.MiniMapEntity:SetIcon("minimap_shoppedestal.tex")
  
    MakeSnowCoveredPristine(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("pedestal")
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("idle_cablespool")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("shop_pedestal")
    inst:AddTag("structure")

    inst.entity:SetPristine()

--TODO 逻辑不完美，待重写
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("itemlose", onitemlosefn)
        inst:ListenForEvent("itemget", onitemgetfn)
        inst:ListenForEvent("refresh",function()
            if not ThePlayer then return end
            local containerwidget = ThePlayer.HUD.controls.containers[inst]
            if not containerwidget then
                dprint("=======no containerwidget")
                return
            end
            for k, v in pairs(containerwidget.inv) do
                if v.tile then
                    local item = v.tile.item
                    if item ~= nil then
                        local price = math.floor(Caculate_Sell_Price(item))
                        v:SetHoverText(STRINGS.PUREECOMOMICS.SELLRATE_INFO_2..tostring(price)..STRINGS.PUREECOMOMICS.UNIT)
                    else
                        v:ClearHoverText()	
                    end
                end
            end
        end)
    end

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
