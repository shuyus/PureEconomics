require "prefabutil"
local treasurehunt = require "PEslotmachinedata"

local prefabs =
{	
	"oinc_yuan",
	"oinc10_yuan",
	"oinc100_yuan",
	"coffee",
	"coffeebush",
}

local goodspawns = 
{
	
	slot_cooker = 3,
	slot_warrior2 = 3,
	slot_warrior3 = 3,
	slot_warrior4 = 1,
	slot_scientist = 3,
	slot_walker = 3,
	slot_gemmy = 3,
	slot_bestgem = 30,
	slot_lifegiver = 3,
	slot_chilledamulet = 3,
	slot_icestaff = 3,
	slot_firestaff = 3,
	slot_coolasice = 3,
	slot_gunpowder = 3,
	slot_firedart = 30,
	slot_sleepdart = 30,
	slot_blowdart =30,
	slot_speargun = 30,
	slot_coconades = 30,
	slot_obsidian = 1,
	slot_thuleciteclub = 30,
	slot_ultimatewarrior = 3,
	slot_goldenaxe = 30,
	staydry = 30,
	cooloff = 30,
	birders = 30,
	gears =8,
	slot_seafoodsurprise = 30,
	slot_fisherman = 30,
	slot_camper = 30,
	slot_dapper = 30,
	slot_speed = 30,
	slot_tailor = 30,
	solt_coffee =5,
}

local okspawns =
{
	-- OK slot List - Food and Resrouces 
	slot_honeypot = 10,
	slot_goldy = 50,
	slot_anotherspin = 50,
	firestarter = 50,
	geologist = 50,
	slot_spiderboon = 50,
	slot_torched = 50,
	slot_jelly = 50,
	slot_handyman = 50,
	slot_poop = 50,
	slot_berry = 50,
	slot_limpets = 50,
	slot_bushy = 50,
	slot_bamboozled = 50,
	slot_grassy = 50,
	slot_prettyflowers = 50,
	slot_witchcraft = 50, 
	slot_bugexpert = 50,
	slot_flinty = 50,
	slot_fibre = 50,
	slot_drumstick = 50,
	slot_ropey = 50,
	slot_jerky = 50,
	slot_coconutty = 50,
	slot_bonesharded = 50,
}

local badspawns =
{
	-- Bad prizes
--	snake = 1,
--	spider_hider = 1,
	slot_spiderattack = 10,
	slot_mosquitoattack = 10,
	--slot_snakeattack = 10,
	--slot_monkeysurprise = 10,
	slot_poisonsnakes = 10,
	slot_hounds = 10,
    --slot_bishop =10,
	slot_krampus=10,
	slot_worm = 10,
	slot_knight = 10,
	slot_merm= 10,
	slot_tallbird =10,

	-- Old
	--nothing = 100,
	--trinket = 100,
}

-- weighted_random_choice for bad, ok, good prize lists 
local prizevalues =
{
	bad = 2,
	ok = 7,
	good =1 ,
}

-- actions to perform for the spawns
local actions =
{
}



--Check treasurehunt
do
	--dprint("Check treasurehunt...")
	local fail_prefab = {}
	local function CheckLoot(arr)
		if arr==nil then
			return
		end
		for k,v in pairs(arr) do
			if fail_prefab[k] == nil and not PrefabExists(k) then
				dprint('UNKNOWN PREFAB:',k)
				fail_prefab[k] = true
			end
		end
	end
	for k,v in pairs(treasurehunt) do
		CheckLoot(v.loot)
		CheckLoot(v.random_loot)
		CheckLoot(v.random_loot)
	end
	
	--dprint("Check local arrays...")
	local function CheckArr(arr)
		for k,v in pairs(arr) do
			if treasurehunt[k] == nil then
				dprint("UNKNOWN KEY:",k)
			end
		end
	end
	CheckArr(goodspawns)
	CheckArr(okspawns)
	CheckArr(badspawns)
end


local function GetTreasureLootList(reward)
	local lootlist = {}
	local loots = treasurehunt[reward]
	if loots then
		if loots.loot then
			for prefab, n in pairs(loots.loot) do
				if lootlist[prefab] == nil then
					lootlist[prefab] = 0
				end
				lootlist[prefab] = lootlist[prefab] + n
			end
		end
		if loots.random_loot then
			for i = 1, (loots.num_random_loot or 1), 1 do
				local prefab = weighted_random_choice(loots.random_loot)
				if prefab then
					if lootlist[prefab] == nil then
						lootlist[prefab] = 0
					end
					lootlist[prefab] = lootlist[prefab] + 1
				end
			end
		end
		if loots.chance_loot then
			for prefab, chance in pairs(loots.chance_loot) do
				if math.random() < chance then
					if lootlist[prefab] == nil then
						lootlist[prefab] = 0
					end
					lootlist[prefab] = lootlist[prefab] + 1
				end
			end
		end
		if loots.custom_lootfn then
			loots.custom_lootfn(lootlist)
		end
	end
	return lootlist
end

local sounds = 
{
	ok = "dontstarve_DLC002/common/slotmachine_mediumresult",
	good = "dontstarve_DLC002/common/slotmachine_goodresult",
	bad = "dontstarve_DLC002/common/slotmachine_badresult",
}

local function SpawnCritter(inst, critter, lootdropper, pt, delay)
	delay = delay or GetRandomWithVariance(1,0.8)
	inst:DoTaskInTime(delay, function() 
		SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
		local spawn = lootdropper:SpawnLootPrefab(critter, pt)
		if spawn and spawn.components.combat then
			spawn.components.combat:SetTarget(GetPlayer())
		end
	end)
end

local function SpawnReward(inst, reward, lootdropper, pt, delay)
	delay = delay or GetRandomWithVariance(1,0.8)

	local loots = GetTreasureLootList(reward)
	for k, v in pairs(loots) do
		for i = 1, v, 1 do

			inst:DoTaskInTime(delay, function(inst) 
				local down = TheCamera:GetDownVec()
				local spawnangle = math.atan2(down.z, down.x)
				local angle = math.atan2(down.z, down.x) + (math.random()*90-45)*DEGREES
				local sp = math.random()*3+2
				
				local item = SpawnPrefab(k)

				if item == nil then
					dprint("CAN't SPAWN PREFAB: ",k)
				else
					if item.components.inventoryitem and not item.components.health then
						local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(spawnangle), 3, 2*math.sin(spawnangle))
						--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/slotmachine_reward")
						item.Transform:SetPosition(pt:Get())
						item.Physics:SetVel(sp*math.cos(angle), math.random()*2+9, sp*math.sin(angle))
						--item.components.inventoryitem:OnStartFalling()
					else
						local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(spawnangle), 0, 2*math.sin(spawnangle))
						pt = pt + Vector3(sp*math.cos(angle), 0, sp*math.sin(angle))
						item.Transform:SetPosition(pt:Get())
						SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
					end
				end
				if i == v then
					inst.components.trader.enabled = true
				end
			end)
			delay = delay + 0.25
		end
	end
end



local function PickPrize(inst,item_prefab,giver)
	local anxiang= giver.userid
	inst.busy = true
	--dprint("item_prefab",tostring(item_prefab))
	local prizevalue

	if item_prefab == "oinc10_yuan" then
		prizevalue = weighted_random_choice(prizevalues)
		-- dprint("slotmachine prizevalue", prizevalue)
		if prizevalue == "ok" then
			inst.prize = weighted_random_choice(okspawns)
		elseif prizevalue == "good" then
			inst.prize = weighted_random_choice(goodspawns)
		elseif prizevalue == "bad" then
			inst.prize = weighted_random_choice(badspawns)
		else
			-- impossible!
			-- dprint("impossible slot machine prizevalue!", prizevalue)
		end
	elseif item_prefab== "oinc100_yuan" then   
		prizevalue = "good"
		inst.prize = weighted_random_choice(goodspawns)--
	else
		--prizevalue ="ok"
		--inst.prize = weighted_random_choice(from_trinket_spawns)
	end
	--dprint("prizevalue",prizevalue)

	inst.prizevalue = prizevalue

end

local function DoneSpinning(inst)


	local pos = inst:GetPosition()
	local item = inst.prize
	--local doaction = actions[item] --{ treasure = "geologist", },
	local doaction = { treasure = item, }

	local cnt = (doaction and doaction.cnt) or 1
	local func = (doaction and doaction.callback) or nil
	local radius = (doaction and doaction.radius) or 4
	local treasure = (doaction and doaction.treasure) or nil

	if doaction and doaction.var then
		cnt = GetRandomWithVariance(cnt,doaction.var)
		if cnt < 0 then cnt = 0 end
	end

	if cnt == 0 and func then
		func(inst,item,doaction)
	end

	for i=1,cnt do
		local offset, check_angle, deflected = FindWalkableOffset(pos, math.random()*2*PI, radius , 8, true, false) -- try to avoid walls
		if offset then
			if treasure then
				-- dprint("Slot machine treasure "..tostring(treasure))
				-- SpawnTreasureLoot(treasure, inst.components.lootdropper, pos+offset)
				-- SpawnPrefab("collapse_small").Transform:SetPosition((pos+offset):Get())
				SpawnReward(inst, treasure)
			elseif func then
				func(inst,item,doaction)
			elseif item == "trinket" then
				SpawnCritter(inst, "trinket_"..tostring(math.random(NUM_TRINKETS)), inst.components.lootdropper, pos+offset)
			elseif item == "nothing" then
				-- do nothing
				-- dprint("Slot machine says you lose.")
			else
				-- dprint("Slot machine item "..tostring(item))
				SpawnCritter(inst, item, inst.components.lootdropper, pos+offset)
			end
		end
	end

	-- the slot machine collected more coins
	inst.coins = inst.coins + 1

	--inst.AnimState:PlayAnimation("idle")
	inst.busy = false
	inst.prize = nil
	inst.prizevalue = nil
	
	inst.sg:GoToState("fake_idle")
end


local function StartSpinning(inst)
	inst.components.trader.enabled = false
	inst.sg:GoToState("spinning")
end

local function ShouldAcceptItem(inst, item)
	if not inst.busy and ((item.prefab == "oinc10_yuan") 
		or (item.prefab == "oinc100_yuan") )then
			return true
	end

	return false
end


local function OnGetItemFromPlayer(inst, giver, item)
	PickPrize(inst,item.prefab,giver)
	StartSpinning(inst)
end

local function OnRefuseItem(inst, item)
	-- dprint("Slot machine refuses "..tostring(item.prefab))
end

local function OnLoad(inst,data)
	if not data then
		return
	end
	
	inst.coins = data.coins or 0
	inst.prize = data.prize
	inst.prizevalue = data.prizevalue

	if inst.prize ~= nil then
		StartSpinning(inst)
	end
end

local function OnSave(inst,data)
	data.coins = inst.coins
	data.prize = inst.prize
	data.prizevalue = inst.prizevalue
end

local function CalcSanityAura(inst, observer)
	return -(TUNING.SANITYAURA_MED*(1+(inst.coins/100)))
end


local assets = 
{
	Asset("ANIM", "anim/slot_machine.zip"),
	--Asset("MINIMAP_IMAGE", "slot_machine"),
}


local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end

    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end


local function fn()
	local inst = CreateEntity()

	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetPriority( 5 )
	--minimap:SetIcon( "slot_machine.png" )
			
	MakeObstaclePhysics(inst, 0.8, 1.2)
	
	anim:SetBank("slot_machine")
	anim:SetBuild("slot_machine")
	anim:PlayAnimation("idle")
	
	inst:AddTag("structure")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end


	inst.DoneSpinning = DoneSpinning
	inst.busy = false
	inst.sounds = sounds


	inst.coins = 0
	
	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem


	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst:SetStateGraph("SGslotmachine")

	return inst
end

return Prefab( "pe_slotmachine", fn, assets, prefabs),
MakePlacer("pe_slotmachine_placer","slot_machine","slot_machine","idle")


