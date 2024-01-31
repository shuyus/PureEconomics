local assets =
{
	Asset("ANIM", "anim/coffee.zip"),
	Asset("ATLAS", "images/inventoryimages/coffee.xml")
}

local prefabs =
{
	"spoiled_food",
}

local CAFFEINE_SPEED_MODIFIER = 1.83
local CAFFEINE_DURATION = 8 * 60

local function StartCaffeineFn(inst, eater)
	if eater.components.locomotor and eater.components.pecaffeinated then
		eater.components.pecaffeinated:Caffeinate(CAFFEINE_SPEED_MODIFIER, CAFFEINE_DURATION)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.05, 0.68)

	inst.AnimState:SetBuild("coffee")
	inst.AnimState:SetBank("coffee")
	inst.AnimState:PlayAnimation("idle", false)

	inst:AddTag("preparedfood")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 3
	inst.components.edible.hungervalue = 10
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible.sanityvalue = -5
	inst.components.edible.temperaturedelta = 5
	inst.components.edible.temperatureduration = 60
	inst.components.edible:SetOnEatenFn(StartCaffeineFn)

	inst:AddComponent("inspectable")
	inst.wet_prefix = "soggy"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/coffee.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	return inst
end

return Prefab("coffee", fn, assets, prefabs)
