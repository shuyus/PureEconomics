require("stategraphs/commonstates")

local actionhandlers = {}

local events = 
{
	-- EventHandler("lightningstrike", function(inst) 
	--     if not inst.EggHatched then
	--         inst.sg:GoToState("crack")
	--     end
	-- end),
}

local sound_arr = {
	good = "SLOT/SLOT/gold",
	ok = "SLOT/SLOT/carrot",
	bad = "SLOT/SLOT/skull",
}


local states =
{   
	State{
		name = "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle")
		end,
	},

	State{
		name = "fake_idle",
		tags = {"idle"},

		onenter = function(inst)
			--inst.AnimState:PlayAnimation("idle")
		end,
	},
	
	State{
		name = "spinning",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("use", false)
			local sound = sound_arr[inst.prizevalue]
			if sound then
				inst.SoundEmitter:PlaySound(sound)
			end
		end,

		timeline = 
		{
			--TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/slotmachine_coinslot") end),
			--TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/slotmachine_leverpull") end),
			--TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/slotmachine_jumpup") end),
			--TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/slotmachine_spin", "slotspin") end),
		},

		events = 
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("prize_"..inst.prizevalue) end),
		}
	},

	State{
		name = "prize_ok",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			--TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:KillSound("slotspin") end),
			--TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},

	State{
		name = "prize_good",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			--TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:KillSound("slotspin") end),
			--TimeEvent(33*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},

	State{
		name = "prize_bad",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			--TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:KillSound("slotspin") end),
			--TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},
}
	
return StateGraph("slotmachine", states, events, "idle", actionhandlers)
