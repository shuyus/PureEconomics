--参与商店且无法合成的物品必须在这里标注基础价格
--料理不算可合成物品，必须标注价格
--价格为nil的物品必须是可合成的，它们在PEItemData初始化时根据合成材料完成计算

local PE_GOODS_LIST={}

PE_GOODS_LIST.food =
{
	kabobs = {price = 36, canbuy = false},--肉串
	meatballs = {price = 54, canbuy = true},--肉丸
	bonestew = {price = 100, canbuy = false},--肉汤
	meat_dried = {price = 60, canbuy = false},--肉干
	turkeydinner = {price = 90, canbuy = false},--火鸡正餐
	baconeggs = {price = 125, canbuy = false},--鸡蛋火腿
	perogies = {price = 114, canbuy = false},--饺子
	hotchili = {price = 85, canbuy = false},--辣椒酱
	unagi = {price = 76, canbuy = false},--鳗鱼寿司
	frogglebunwich = {price = 64, canbuy = false},--青蛙三明治
	fishtacos = {price = 76, canbuy = false},--玉米鱼饼
	fishsticks = {price = 112, canbuy = false},--鱼条
	honeynuggets = {price = 92, canbuy = false},--甜蜜金砖
	honeyham = {price = 142, canbuy = false},--蜜汁火腿
	monsterlasagna = {price = 71, canbuy = false},--怪兽千层饼
	powcake = {price = 36, canbuy = false},--芝士蛋糕
	butterflymuffin = {price = 54, canbuy = false},--蝴蝶松饼
	fruitmedley = {price = 64, canbuy = false},--水果拼盘
	ratatouille = {price = 58, canbuy = false},--蔬菜杂烩
	jammypreserves = {price = 72, canbuy = false},--果酱蜜饯
	trailmix = {price = 64, canbuy = false},--水果杂烩
	flowersalad = {price = 96, canbuy = false},--花瓣沙拉
	taffy = {price = 48, canbuy = false},--太妃糖
	icecream = {price = 228, canbuy = false},--冰淇淋
	waffles = {price = 256, canbuy = false},--华夫饼
	pumpkincookie = {price = 76, canbuy = false},--南瓜饼
	stuffedeggplant = {price = 82, canbuy = false},--香酥茄盒
	watermelonicle = {price = 63, canbuy = false},--西瓜冰
	dragonpie = {price = 124, canbuy = false},--火龙果派
	pepperpopper = {price = 58, canbuy = false},--爆炒填馅辣椒
	mashedpotatoes = {price = 120, canbuy = false},--奶油土豆泥
	potatotornado = {price = 68, canbuy = false},--花式回旋块茎
	salsa = {price = 99, canbuy = false},--生鲜萨尔萨酱
	vegstinger = {price = 75, canbuy = false},--蔬菜鸡尾酒
	asparagussoup = {price = 66, canbuy = false},--芦笋汤
	surfnturf = {price = 148, canbuy = false},--海鲜牛排
	seafoodgumbo = {price = 138, canbuy = false},--海鲜浓汤
	californiaroll = {price = 107, canbuy = false},--加州卷
	ceviche = {price = 135, canbuy = false},--酸橘汁腌鱼
	lobsterdinner = {price = 374, canbuy = false},--龙虾正餐
	lobsterbisque = {price = 144, canbuy = false},--龙虾汤
	barnaclestuffedfishhead = {price = 87, canbuy = false},--酿鱼头
	barnaclinguine = {price = 96, canbuy = false},--藤壶中细面
	barnaclepita = {price = 48, canbuy = false},--藤壶皮塔饼
	barnaclesushi = {price = 75, canbuy = false},--藤壶握寿司
	sweettea = {price = 46, canbuy = false},--舒缓茶
	koalefig_trunk = {price = 334, canbuy = false},--无花果酿象鼻
	figkabab = {price = 79, canbuy = false},--无花果烤串
	figatoni = {price = 97, canbuy = false},--无花果意面
	frognewton = {price = 51, canbuy = false},--无花果蛙腿三明治
	meatysalad = {price = 108, canbuy = false},--牛肉绿叶菜
	leafymeatsouffle = {price = 123, canbuy = false},--果冻沙拉
	leafymeatburger = {price = 158, canbuy = false},--素食堡
	leafloaf = {price = 117, canbuy = false},--叶肉糕
	bananapop = {price = 66, canbuy = false},--香蕉冻
	bananajuice = {price = 70, canbuy = false},--香蕉奶昔
	frozenbananadaiquiri = {price = 78, canbuy = false},--冰香蕉冻唇蜜
	mandrakesoup = {price = 450, canbuy = false},--曼德拉草汤
	bonesoup = {price = 171, canbuy = false},--骨头汤
	freshfruitcrepes = {price = 351, canbuy = false},--鲜果可丽饼
	moqueca = {price = 160, canbuy = false},--海鲜杂烩
	monstertartare = {price = 132, canbuy = false},--怪物达达
	voltgoatjelly = {price = 450, canbuy = false},--伏特羊角冻
	glowberrymousse = {price = 204, canbuy = false},--发光浆果慕斯
	potatosouffle = {price = 148, canbuy = false},--蓬松土豆蛋奶酥
	frogfishbowl = {price = 135, canbuy = false},--蓝带鱼排
	gazpacho = {price = 96, canbuy = false},--芦笋冷汤
	dragonchilisalad = {price = 212, canbuy = false},--辣龙椒沙拉
	nightmarepie = {price = 255, canbuy = false},--恐怖国王饼
	bunnystew = {price = 40, canbuy = false},--炖兔子
	justeggs = {price = 48, canbuy = false},--普通煎蛋
	veggieomlet = {price = 60, canbuy = false},--早餐锅
	guacamole = {price = 36, canbuy = false},--鳄梨酱
	talleggs = {price = 170, canbuy = false},--苏格兰高鸟蛋
	shroomcake = {price = 180, canbuy = false},--蘑菇蛋糕
	beefalotreat = {price = 64, canbuy = false},--皮弗娄牛零食
	beefalofeed = {price = 30, canbuy = false},--蒸树枝
	dustmeringue = {price = 30, canbuy = false},--琥珀美食
	yotr_food1 = {price = 74, canbuy = false},--兔子卷
	yotr_food2 = {price = 114, canbuy = false},--月饼
	yotr_food3 = {price = 64, canbuy = false},--月冻
	yotr_food4 = {price = 76, canbuy = false},--泡芙串
	

	smallmeat = {price = 18},--小肉
	meat = {price = 30},--大肉
	monstermeat = {price = 27},--怪兽肉
	drumstick = {price = 18},--鸡腿
	bird_egg = {price = 12},--鸡蛋
	fishmeat_small = {price = 20},--小鱼块
	fishmeat = {price = 33},--大鱼块
	kelp = {price = 10},--海带
	barnacle = {price = 14, canbuy = false},--藤壶
	fig = {price = 11, canbuy = false},--无花果
	wobster_sheller_land = {price = 80},--龙虾
	wobster_moonglass_land = {price = 100, canbuy = false},--月光龙虾

	eel = {price = 60, canbuy = false},--鳗鱼
	froglegs = {price = 14},--青蛙腿
	plantmeat = {price = 33},--食人花肉
	batwing = {price = 62},--蝙蝠翅膀
	batnose = {price = 43, canbuy = false},--裸露鼻孔
	trunk_summer = {price = 125},--红色象鼻
	trunk_winter = {price = 200},--蓝色象鼻
	berries = {price = 3},--浆果
	berries_juicy = {price = 6},--蜜汁浆果
	rock_avocado_fruit_ripe = {price = 8, canbuy = false},--成熟石果
	cutlichen = {price = 4, canbuy = false},--苔藓
	ice = {price = 6},--冰
	red_cap = {price = 8},--红蘑菇
	green_cap = {price = 12},--绿蘑菇
	blue_cap = {price = 16},--蓝蘑菇
	moon_cap = {price = 24, canbuy = false},--月亮蘑菇
	cactus_meat = {price = 19},--仙人掌
	cactus_flower = {price = 30},--仙人掌花
	cave_banana = {price = 16},--香蕉
	butterflywings = {price = 8},--蝴蝶翅膀
	moonbutterflywings = {price = 20, canbuy = false},--月蛾翅膀
	moon_tree_blossom = {price = 10, canbuy = false},--月树花
	honey = {price = 8},--蜂蜜
	petals = {price = 2},--花瓣
	petals_evil = {price = 8},--噩梦花瓣
	carrot = {price = 12},--胡萝卜
	corn = {price = 18},--玉米
	durian = {price = 24},--榴莲
	pomegranate = {price = 21},--石榴
	eggplant = {price = 28},--茄子
	pumpkin = {price = 35},--南瓜
	watermelon = {price = 30},--西瓜
	dragonfruit = {price = 75},--火龙果
	asparagus = {price = 18},--芦笋
	onion = {price = 33},--洋葱
	potato = {price = 28},--土豆
	tomato = {price = 24},--番茄
	garlic = {price = 21},--大蒜
	pepper = {price = 15},--辣椒
	forgetmelots = {price = 7},--必忘我
	tillweed = {price = 2},--犁地草
	firenettles = {price = 4},--火荨麻叶
}
PE_GOODS_LIST.fight = {
	armorgrass = {price = nil},--草甲
	armorwood = {price = nil},--木甲
	spear = {price = nil},--长矛
	spear_wathgrithr = {price = 124, canbuy = false},--战斗长矛
	wathgrithrhat = {price = 132, canbuy = false},--战斗头盔
	hambat = {price = nil},--火腿棒
	footballhat = {price = nil},--猪皮头盔
	cookiecutterhat = {price = nil},--饼干切割机帽子
	tentaclespike = {price = 115},--触手棒
	batbat = {price = nil},--蝙蝠棒
	nightsword = {price = nil},--影刀
	armor_sanity = {price = nil},--影甲
	armormarble = {price = nil},--大理石甲
	whip = {price = nil},--猫尾鞭
	boomerang = {price = nil},--飞镖
	blowdart_pipe = {price = nil},--吹箭
	blowdart_fire = {price = nil},--燃烧吹箭
	blowdart_sleep = {price = nil},--麻醉吹箭
	blowdart_yellow = {price = nil},--电磁吹箭
	firestaff = {price = nil},--红魔杖
	icestaff = {price = nil},--蓝魔杖
	telestaff = {price = nil},--紫魔杖

	gunpowder = {price = nil},--炸药
	trap_teeth = {price = nil},--狗牙陷阱
	beemine = {price = nil},--蜜蜂地雷
	waterplant_bomb = {price = 29},--种壳

	healingsalve = {price = 36},--药膏
	tillweedsalve = {price = nil},--犁地草膏
	bandage = {price = nil},--蜂蜜药膏
}

PE_GOODS_LIST.tool = {
	axe = {price = nil},--斧头
	shovel = {price = nil},--铲子
	pickaxe = {price = nil},--矿锄
	goldenaxe = {price = nil},--金斧头
	goldenshovel = {price = nil},--金铲子
	goldenpickaxe = {price = nil},--金矿锄
	hammer = {price = nil},--锤子
	pitchfork = {price = nil},--草叉
	razor = {price = nil},--剃须刀
	bugnet = {price = nil},--捕虫网
	birdtrap = {price = nil},--捕鸟器
	beef_bell = {price = nil},--皮弗娄牛铃
	saddle_basic = {price = nil},--鞍
	saddlehorn = {price = nil},--取鞍器
	fishingrod = {price = nil},--鱼竿

	farm_hoe = {price = nil},--园艺锄
	golden_farm_hoe = {price = nil},--黄金园艺锄
	wateringcan = {price = nil},--浇水壶
	farm_plow_item = {price = nil},--耕地机
	soil_amender = {price = 80},--催长剂起子
	plantregistryhat = {price = nil},--耕作先驱帽
	treegrowthsolution = {price = nil, canbuy = false},--树果酱

	pocket_scale = {price = nil},--弹簧秤
	oceanfishingrod = {price = nil},--海钓竿
	oceanfishingbobber_ball = {price = nil},--木球浮标
	oceanfishingbobber_oval = {price = nil},--硬物浮标
	oceanfishinglure_spoon_red = {price = nil, canbuy = false},--日出匙型假饵
	oceanfishinglure_spoon_green = {price = nil, canbuy = false},--黄昏匙型假饵
	oceanfishinglure_spoon_blue = {price = nil, canbuy = false},--夜间匙型假饵
	oceanfishinglure_spinner_red = {price = nil, canbuy = false},--日出旋转亮片
	oceanfishinglure_spinner_green = {price = nil, canbuy = false},--黄昏旋转亮片
	oceanfishinglure_spinner_blue = {price = nil, canbuy = false},--夜间旋转亮片


	oar = {price = nil},--浆
	oar_driftwood = {price = nil},--浮木浆
	
	boat_item = {price = 200},--船套装
	boatpatch = {price = 100},--船补丁

	boat_grass_item = {price = 160},--草筏套装

	boat_bumper_kelp_kit = {price = 120},--海带保险杠套装
	boat_bumper_shell_kit = {price = 240, canbuy = false},--贝壳保险杠套装


	anchor_item = {price = nil},--锚套装
	mast_item = {price = nil},--桅杆套装
	steeringwheel_item = {price = nil},--方向舵套装
	mastupgrade_lamp_item = {price = nil},--甲板照明灯
	mastupgrade_lightningrod_item = {price = nil},--避雷导线
	boat_rotator_kit = {price = 200},--转向舵套装
	ocean_trawler_kit = {price = 346, canbuy = false},--海洋拖网捕鱼器套装
	boat_magnet_kit = {price = nil, canbuy = false},--自动航行套装
	boat_magnet_beacon = {price = nil, canbuy = false},--自动航行灯塔
	boat_cannon_kit = {price = nil, canbuy = false},--大炮套装
	cannonball_rock_item = {price = nil},--炮弹
	dock_kit = {price = nil, canbuy = false},--码头套装
	dock_woodposts_item = {price = nil, canbuy = false},--码头桩
}

PE_GOODS_LIST.smithing = 
{

	sewing_kit = {price = nil},--缝补机
	strawhat = {price = nil},--草帽
	flowerhat = {price = nil},--花环
	grass_umbrella = {price = nil},--花伞
	umbrella = {price = nil},--雨伞
	minifan = {price = nil},--风车
	beefalohat = {price = nil},--牛角帽
	catcoonhat = {price = nil},--猫帽
	earmuffshat = {price = nil},--兔毛耳罩
	hawaiianshirt = {price = nil},--花纹衬衫
	icehat = {price = nil},--冰块
	raincoat = {price = nil},--雨衣
	rainhat = {price = nil},--雨帽
	reflectivevest = {price = nil},--夏季背心
	trunkvest_summer = {price = nil},--夏日背心
	trunkvest_winter = {price = nil},--寒冬背心
	watermelonhat = {price = nil},--西瓜帽
	kelphat = {price = nil},--海花冠
	winterhat = {price = nil},--冬帽
	nightcaphat = {price = 30, canbuy = false},--睡帽
	torch = {price = nil},--火把
	redlantern = {price = 124},--灯笼
	lantern = {price = nil},--提灯
	minerhat = {price = nil},--矿工帽
	pumpkin_lantern = {price = nil},--南瓜灯
	molehat = {price = nil},--地鼠帽

	beehat = {price = nil},--养蜂帽
	featherhat = {price = nil},--羽毛帽
	bushhat = {price = nil},--浆果帽
	tophat = {price = nil},--高礼帽
	spiderhat = {price = 325},--女王帽
	goggleshat = {price = nil},--时尚眼镜
	sweatervest = {price = nil},--小巧背心
	onemanband = {price = nil},--独奏乐器
	compass = {price = nil},--指南针
	waterballoon = {price = nil},--水球
	amulet = {price = nil},--红护符
	blueamulet = {price = nil},--蓝护符
	purpleamulet = {price = nil},--紫护符

	heatrock = {price = nil},--暖石
	bedroll_straw = {price = nil},--稻草卷
	bedroll_furry = {price = nil},--毛皮铺盖
	bernie_inactive = {price = nil, canbuy=false},--小熊
	giftwrap = {price = nil},--彩纸
	bundlewrap = {price = nil},--空包裹
	featherpencil = {price = nil},--羽毛笔
	lifeinjector = {price = nil},--针筒
	reskin_tool = {price = nil},--清洁扫把

	backpack = {price = nil},--背包
	piggyback = {price = nil},--小猪包
	seedpouch = {price = nil},--种子袋

}

PE_GOODS_LIST.decoration ={
	winter_ornament_light1 = {price = 150},--圣诞灯红
	winter_ornament_light2 = {price = 150},--圣诞灯绿
	winter_ornament_light3 = {price = 150},--圣诞灯蓝
	winter_ornament_light4 = {price = 150},--圣诞灯白
	turf_grass = {price = nil},--长草地皮
	turf_forest = {price = nil},--森林地皮
	turf_savanna = {price = nil},--草地地皮
	turf_deciduous = {price = nil},--季节地皮
	turf_rocky = {price = nil},--岩石地皮
	turf_carpetfloor = {price = nil},--地毯地板
	turf_checkerfloor = {price = nil},--方格地板
	turf_woodfloor = {price = nil},--木质地板
	turf_road = {price = nil},--卵石路
	turf_pebblebeach = {price = 40},--岩石海滩地皮
	turf_shellbeach = {price = nil},--贝壳海滩地皮
	turf_meteor = {price = 87},--月球环形山地皮
	turf_archive = {price = 114},--远古石刻
	turf_beard_rug = {price = nil},--胡须地毯

	turf_mosaic_blue = {price = nil},--蓝色马赛克地
	turf_mosaic_grey = {price = nil},--灰色马赛克地面
	turf_mosaic_red = {price = nil},--红色马赛克地面
	turf_ruinsbrick_glow = {price = nil},--仿远古地面


	fence_item = {price = nil},--栅栏
	fence_gate_item = {price = nil},--木门
	wall_hay_item = {price = nil},--草墙
	wall_wood_item = {price = nil},--木墙
	wall_stone_item = {price = nil},--石墙
	wall_moonrock_item = {price = nil, canbuy = false},--月石墙
}

	

PE_GOODS_LIST.resource = 
{
	cutgrass = {price = 5},--草
	twigs = {price = 6},--树枝
	log = {price = 10},--木头
	charcoal = {price = 6},--木炭
	driftwood_log = {price = 34},--浮木桩
	cutreeds = {price = 8},--芦苇
	rocks = {price = 8},--石头
	flint = {price = 6},--燧石
	nitre = {price = 12},--硝石
	goldnugget = {price = 14},--金块
	saltrock = {price = 22},--盐晶
	rock_avocado_fruit = {price = 18},--石果
	marble = {price = 34},--大理石
	moonrocknugget = {price = 34, canbuy = false},--月石

	palmcone_scale = {price = 48, canbuy = false},--棕榈松果树鳞片
	
	dug_berrybush = {price = 27, canbuy = false},--浆果丛
	dug_berrybush2 = {price = 34, canbuy = false},--热带浆果丛
	dug_berrybush_juicy = {price = 40, canbuy = false},--蜜汁浆果丛
	dug_bananabush = {price = 25, canbuy = false},--香蕉丛
	dug_grass = {price = 20, canbuy = false},--草丛
	dug_sapling = {price = 17, canbuy = false},--树枝丛
	dug_sapling_moon = {price = 24, canbuy = false},--月岛树枝丛
	dug_marsh_bush = {price = 21, canbuy = false},--尖刺丛
	dug_monkeytail = {price = 40, canbuy = false},--猴尾草
	dug_rock_avocado_bush = {price = 24, canbuy = false},--月岛石果丛



	pinecone = {price = 5},--常青树种子
	acorn = {price = 6},--桦树种子

	twiggy_nut = {price = 6},--多枝树种
	palmcone_seed = {price = 36, canbuy = false},--棕榈松果树芽
	
	lureplantbulb = {price = 180, canbuy = false},--食人花
	livingtree_root = {price = 100, canbuy = false},--完全正常的树根
	rock_avocado_fruit_sprout = {price = 85, canbuy = false},--发芽的石果
	bullkelp_root = {price = 51},--公牛海带茎
	waterplant_planter = {price = 68, canbuy = false},--海芽插穗
	dug_trap_starfish = {price = 188, canbuy = false},--海星陷阱
	seeds = {price = 6},--种子
	foliage = {price = 6},--蕨叶
	succulent_picked = {price = 10},--肉质植物
	lightbulb = {price = 12},--荧光果
	wormlight_lesser = {price = 24},--小发光浆果
	wormlight = {price = 68},--发光浆果
	fireflies = {price = 84},--萤火虫
	lightflier = {price = 10, canbuy = false},--球状光虫
	redgem = {price = 100},--红宝石
	bluegem = {price = 100},--蓝宝石
	purplegem = {price = 200},--紫宝石
	livinglog = {price = 90},--活木
	nightmarefuel = {price = 32},--噩梦燃料
	spidergland = {price = 16},--蜘蛛腺体
	silk = {price = 20},--蜘蛛网
	spidereggsack = {price = 140},--蜘蛛巢
	honeycomb = {price = 120},--蜂巢
	coontail = {price = 100},--猫尾
	boneshard = {price = 20},--骨片
	houndstooth = {price = 38},--狗牙
	stinger = {price = 18},--蜂刺
	cookiecuttershell = {price = 52},--饼干切割机壳
	messagebottleempty = {price = 38},--空瓶子
	horn = {price = 180},--牛角
	beefalowool = {price = 21},--牛毛
	pigskin = {price = 48},--猪皮
	manrabbit_tail = {price = 53},--兔毛
	feather_crow = {price = 16},--黑鸟毛
	feather_robin = {price = 18},--红鸟毛
	feather_robin_winter = {price = 22},--蓝鸟毛
	feather_canary = {price = 36},--金鸟毛
	beardhair = {price = 20, canbuy = false},--胡须
	tentaclespots = {price = 74},--触手皮
	mosquitosack = {price = 32},--血袋
	rottenegg = {price = 10},--臭鸡蛋
	spoiled_food = {price = 6},--腐烂食物
	poop = {price = 12},--屎
	guano = {price = 10},--鸟屎
	phlegm = {price = 100},--鼻涕
	glommerfuel = {price = 38},--格罗姆粘液
	slurtleslime = {price = 30},--含糊虫粘液
	slurtle_shellpieces = {price = 30},--壳碎片
	spore_medium = {price = 55},--红色孢子
	spore_small = {price = 55},--绿色孢子
	spore_tall = {price = 55},--蓝色孢子
	ghostflower = {price = 200, canbuy = false},--哀悼荣耀
	tallbirdegg = {price = 130},--高鸟蛋
	--小动物
	butterfly = {price = 16},--蝴蝶
	bee = {price = 22},--蜜蜂
	rabbit = {price = 24},--兔子
	mole = {price = 36},--地鼠
	carrat = {price = 42, canbuy = false},--胡萝卜鼠
	lightcrab = {price = 136, canbuy = false},--发光蟹
	--鸟类
	crow = {price = 22},--黑鸟
	robin = {price = 33},--红鸟
	robin_winter = {price = 44},--蓝鸟
	puffin = {price = 48},--海鹦鹉
	canary = {price = 55},--金丝雀
	canary_poisoned = {price = 125},--中毒金丝雀
	bird_mutant = {price = 78, canbuy = false},--月茫无涯！
	bird_mutant_spitter = {price = 78, canbuy = false},--奇形鸟
	--鱼类
	oceanfish_medium_1_inv = {price = 136, canbuy = false},--泥鱼
	oceanfish_medium_2_inv = {price = 136, canbuy = false},--斑鱼
	oceanfish_medium_3_inv = {price = 136, canbuy = false},--浮夸狮子鱼
	oceanfish_medium_4_inv = {price = 136, canbuy = false},--黑鲶鱼
	oceanfish_medium_5_inv = {price = 150, canbuy = false},--玉米鳕鱼
	oceanfish_medium_6_inv = {price = 136, canbuy = false},--花锦鲤
	oceanfish_medium_7_inv = {price = 150, canbuy = false},--金锦鲤
	oceanfish_medium_8_inv = {price = 150, canbuy = false},--冰鲷鱼
	oceanfish_medium_9_inv = {price = 150, canbuy = false},--甜味鱼
	oceanfish_small_1_inv = {price = 90, canbuy = false},--小孔雀鱼
	oceanfish_small_2_inv = {price = 90, canbuy = false},--针鼻喷墨鱼
	oceanfish_small_3_inv = {price = 90, canbuy = false},--小饵鱼
	oceanfish_small_4_inv = {price = 90, canbuy = false},--三文鱼苗
	oceanfish_small_5_inv = {price = 90, canbuy = false},--爆米花鱼
	oceanfish_small_6_inv = {price = 150, canbuy = false},--落叶比目鱼(秋)
	oceanfish_small_7_inv = {price = 150, canbuy = false},--花朵金枪鱼(春)
	oceanfish_small_8_inv = {price = 150, canbuy = false},--炽热太阳鱼
	oceanfish_small_9_inv = {price = 60, canbuy = false},--口水鱼

	rope = {price = nil},--绳索
	boards = {price = nil},--木板
	cutstone = {price = nil},--石砖
	transistor = {price = nil},--电子元件
	papyrus = {price = nil},--芦苇
	beeswax	= {price = nil},--蜂蜡
	waxpaper = {price = nil},--蜡纸
	fertilizer = {price = nil},--粪桶
	trinket_6 = {price = 100, canbuy = false},--烂电线
	
}

PE_GOODS_LIST.precious = 
{
	blueprint = {price = 25, canbuy = false},--蓝图
	--常规可食用的
	batnosehat = {price = 2400},--牛奶帽
	goatmilk = {price = 1200},--电羊奶
	butter = {price = 1600},--蝴蝶黄油
	mandrake = {price = 2500},--曼德拉草
	--巨鹿相关
	deerclops_eyeball = {price = 3600},--眼球
	eyebrellahat = {price = 5600},--眼球伞
	--克劳斯相关
	deer_antler3 = {price = 250},--鹿角钥匙
	klaussackkey = {price = 1800},--真钥匙
	--麋鹿鹅相关
	goose_feather = {price = 200},--鹅毛
	--熊大相关
	bearger_fur = {price = 2800},--熊皮
	icepack = {price = 6000},--冰背包
	beargervest = {price = 4600},--熊皮大衣
	--龙蝇相关
	dragon_scales = {price = 600},--龙鳞
	lavae_egg = {price = 600},--熔岩虫卵
	armordragonfly = {price = 1400},--龙鳞衣
	--蜂后相关
	hivehat = {price = 2000},--蜂王冠
	royal_jelly = {price = 1500},--蜂王浆
	jellybean = {price = 600},--糖豆
	--蚁狮
	townportaltalisman = {price = 300},--沙之石	
	--影织者
	fossil_piece = {price = 600},--化石碎片
	armorskeleton = {price = 4000},--骨甲
	skeletonhat = {price = 3200},--骨盔
	thurible = {price = 2400},--暗影香炉	
	atrium_key = {price = 1200},--远古钥匙
	shadowheart = {price = 1600},--暗影之心
	--毒菌蟾蜍相关
	sleepbomb = {price = 800},--催眠袋
	red_mushroomhat = {price = 120},--红菇帽
	green_mushroomhat = {price = 120},--绿菇帽
	blue_mushroomhat = {price = 120},--蓝菇帽
	shroom_skin = {price = 1600},--蛤蟆皮
	--三基佬相关
	trinket_15 = {price = 270},--白主教
	trinket_16 = {price = 270},--黑主教
	trinket_28 = {price = 270},--白战车
	trinket_29 = {price = 270},--黑战车
	trinket_30 = {price = 270},--白骑士
	trinket_31 = {price = 270},--黑骑士
	--天体相关
	moonstorm_spark = {price = 200},--月熠
	moonglass_charged = {price = 220},--灌注月亮碎片
	moonstorm_static_item = {price = 2000},--约束静电
	moonrockseed = {price = 2000},--天体宝球
	alterguardianhat = {price = 8000},--启迪之冠
	alterguardianhatshard = {price = 1000},--启迪之冠碎片
	--远古相关
	greengem = {price = 1400},--绿宝石
	orangegem = {price = 1100},--橙宝石
	yellowgem = {price = 1100},--黄宝石
	eyeturret_item = {price = 9999},--眼球塔
	greenstaff = {price = 4500},--绿法杖
	orangestaff = {price = 4800},--橙法杖
	yellowstaff = {price = 3700},--黄法杖
	gears = {price = 400},--齿轮
	minotaurhorn = {price = 2500},--犀牛角
	thulecite = {price = 200},--铥矿
	armorruins = {price = 2100},--铥矿甲
	ruins_bat = {price = 1800},--铥矿棒
	ruinshat = {price = 1400},--铥矿头盔
	greenamulet = {price = 2200},--建造护符
	orangeamulet = {price = 1700},--懒人护符
	yellowamulet = {price = 1700},--魔光护符
	--暗影系列（2023.6.30）
	voidcloth = {price = 400},--暗影碎布
	voidcloth_scythe = {price = 2200},--暗影收割者
	voidcloth_umbrella = {price = 2200},--暗影伞
	voidclothhat = {price = 2400},--虚空风帽
	armor_voidcloth = {price = 2400},--虚空长袍
	--亮茄系列（2023.6.30）
	bomb_lunarplant = {price = 1000},--亮茄炸弹.1
	staff_lunarplant = {price = 2200},--亮茄魔杖
	sword_lunarplant = {price = 1800},--亮茄剑
	armor_lunarplant = {price = 2400},--亮茄盔甲.1
	lunarplanthat = {price = 2000},--亮茄头盔
	pickaxe_lunarplant = {price = 1400},--亮茄粉碎者
	shovel_lunarplant = {price = 1200},--亮茄铲子
	--航海
	monkey_mediumhat = {price = 2400},--船长的三角帽
	polly_rogershat = {price = 2800},--波莉·罗杰的帽子
	malbatross_feather = {price = 800},--邪天翁羽毛
	malbatross_beak = {price = 1000},--邪天翁喙
	gnarwail_horn = {price = 650},--一角鲸的角
	hermit_pearl = {price = 4000},--珍珠的珍珠
	messagebottle = {price = 250},--瓶中信
	trident = {price = 3000},--刺耳三叉戟
	moonbutterfly = {price = 300},--月蛾
	moonglass = {price = 200},--月亮碎片
	--疯猪
	horrorfuel = {price = 1000},--纯粹恐惧
	dreadstone = {price = 300},--绝望石
	armordreadstone = {price = 2000},--绝望石甲
	dreadstonehat = {price = 2000},--绝望石盔
	--水中木
	oceantreenut = {price = 8000},--疙瘩树果
	--坎普斯
	krampus_sack = {price = 9999},--小偷包
	--钢羊
	steelwool = {price = 800},--刚羊毛
	--海象
	walrus_tusk = {price = 1000},--海象牙
	walrushat = {price = 2400},--海象帽
	--韦伯玩家
	spider_healer = {price = 520},--护士蜘蛛
	
	--其他
	nightstick = {price = 1900},--晨星
	panflute = {price = 2500},--排箫	
	staff_tornado = {price = 5200},--旋风

	--oar_monkey = {price = 300},--战浆

	lightninggoathorn = {price = 1200},--电羊角
	slurper_pelt = {price = 450},--辍食者皮
	slurtlehat = {price = 1200},--蜗牛帽
	armorsnurtleshell = {price = 1800},--蜗牛壳
	armorslurper = {price = 3500},--饥饿腰带
	cane = {price = 1000},--步行手杖
	featherfan = {price = 1500},--鹅毛扇
	opalstaff = {price = 7400},--唤月法杖
	saddle_race = {price = 1200},--蝴蝶鞍
	saddle_war = {price = 4800},--战斗鞍
	--deserthat = {price = 300},--风镜
}

PE_GOODS_LIST.special = 
{

}

--特殊蓝图
PE_GOODS_LIST.blueprint = 
{
	mushroom_light_blueprint = {price = 2000},--萤菇灯
	mushroom_light2_blueprint = {price = 2000},--炽菇灯
	bundlewrap_blueprint = {price = 2000},--空包裹
	sleepbomb_blueprint = {price = 2000},--睡球
	endtable_blueprint = {price = 2000},--茶几
	dragonflyfurnace_blueprint = {price = 2000},--龙鳞熔炉
	townportal_blueprint = {price = 2000},--沙传送阵
	goggleshat_blueprint = {price = 2000},--时尚眼镜
	deserthat_blueprint = {price = 2000},--风镜
	red_mushroomhat_blueprint = {price = 2000},--红菇帽
	green_mushroomhat_blueprint = {price = 2000},--绿菇帽
	blue_mushroomhat_blueprint = {price = 2000},--蓝菇帽

	wall_dreadstone_item_blueprint = {price = 1000},--绝望石墙蓝图
	ruinsrelic_chair_blueprint = {price = 1000},--遗迹复制品
}


return PE_GOODS_LIST