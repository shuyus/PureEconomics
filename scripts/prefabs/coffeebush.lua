
local RuinsRespawner = require "prefabs/ruinsrespawner"

local assets = {
    Asset("ANIM", "anim/coffeebush.zip"),
    Asset("SCRIPT", "scripts/prefabs/ruinsrespawner.lua"),
}

local prefabs = {
    "coffeebeans",
    "dug_coffeebush",
    "perd",
    "twigs",
    "coffeebush_ruinsrespawner_inst",
}

local function GetBerriesAnim(inst, num)
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left + num
    local percent = cycles_left / max_cycles
    return percent >= 0.9 and "berriesmost" or percent >= 0.33 and "berriesmore" or "berries"
end

local function GetEmptyAnim(inst)
    return inst.components.pickable:IsBarren() and "idle_dead" or "empty"
end

local function Shake(inst)
    if inst.components.pickable:CanBePicked() then
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation(GetBerriesAnim(inst, 0))
    else
        inst.AnimState:PlayAnimation("shake_empty")
        inst.AnimState:PushAnimation(GetEmptyAnim(inst))
    end
end

local function GetPerdSpawnChance()
    return IsSpecialEventActive(SPECIAL_EVENTS.YOTG) and TUNING.YOTG_PERD_SPAWNCHANCE or TUNING.PERD_SPAWNCHANCE
end

local function SpawnPerd(inst)
    if inst:IsValid() and not inst.components.pickable:IsBarren() then
        local perd = SpawnPrefab("perd")
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle = math.random() * 2 * PI
        perd.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
        perd.sg:GoToState("appear")
        perd.components.homeseeker:SetHome(inst)
        Shake(inst)
    end
end

local function OnPicked(inst, picker)
    inst.AnimState:PlayAnimation(GetBerriesAnim(inst, 1).."_picked")
    if TheWorld.state.issnowcovered or inst:GetIsWet() then
        inst.components.pickable:MakeBarren()
    else
        inst.AnimState:PushAnimation(GetEmptyAnim(inst))
        if not picker:HasTag("berrythief") and math.random() < GetPerdSpawnChance() then
            inst:DoTaskInTime(3 + math.random() * 3, SpawnPerd)
        end
    end
end

local function MakeEmpty(inst)
    if inst.AnimState:IsCurrentAnimation("idle_dead") then
        inst.AnimState:PlayAnimation("dead_to_empty")
        inst.AnimState:PushAnimation("empty")
    else
        inst.AnimState:PlayAnimation("empty")
    end
end

local function MakeBarren(inst, wasempty)
    inst.AnimState:PushAnimation("idle_dead")
end

local function MakeFull(inst)
    inst.AnimState:PlayAnimation("idle_picked")
    inst.AnimState:PushAnimation(GetBerriesAnim(inst, 0))
end

local function OnTransplant(inst)
    inst.AnimState:PlayAnimation("idle_dead")
    inst.components.pickable:MakeBarren()
end

local function GetRegenTime(inst)
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_REGROW_TIME
         + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
         + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

local function OnWorked(inst, worker)
    if inst.components.pickable:IsBarren() then
        inst.components.lootdropper:SpawnLootPrefab("twigs")
        inst.components.lootdropper:SpawnLootPrefab("twigs")
    else
        if inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab("coffeebeans")
        end
        inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
    end
    inst:Remove()
end

local function OnHaunt(inst)
    --TUNING.HAUNT_CHANCE_ALWAYS
    Shake(inst)
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("coffeebush.tex")

    MakeSmallObstaclePhysics(inst, 0.1)

    inst.AnimState:SetBank("coffeebush")
    inst.AnimState:SetBuild("coffeebush")
    inst.AnimState:PlayAnimation("berriesmost")

    MakeSnowCoveredPristine(inst)

    inst:AddTag("bush")
    inst:AddTag("plant")
    inst:AddTag("wildfireprotected")
    inst:AddTag("volcanic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("pickable")
    inst.components.pickable:SetUp("coffeebeans", TUNING.BERRY_REGROW_TIME)
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = MakeEmpty
    inst.components.pickable.makebarrenfn = MakeBarren
    inst.components.pickable.makefullfn = MakeFull
    inst.components.pickable.ontransplantfn = OnTransplant
    inst.components.pickable.getregentimefn = GetRegenTime
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

    if not TUNING.workable then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(OnWorked)
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)
    MakeNoGrowInWinter(inst)
    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst:ListenForEvent("onwenthome", Shake)
    if IsSpecialEventActive(SPECIAL_EVENTS.YOTG) then
        inst:ListenForEvent("spawnperd", SpawnPerd)
    end

    return inst
end

local function OnRuinsRespawn(inst, respawner)
    if not respawner:IsAsleep() then
        inst.AnimState:PlayAnimation("berriesmost")
        local fx = SpawnPrefab("small_puff")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end

return Prefab("coffeebush", fn, assets, prefabs),
       RuinsRespawner.Inst("coffeebush", OnRuinsRespawn),
       RuinsRespawner.WorldGen("coffeebush", OnRuinsRespawn)
