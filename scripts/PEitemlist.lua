-- PEitemlist.lua
-- Author: 勿言
-- LastEdit: 2024.1.31
-- Using: 提供原始的商品信息，由PEItemData读取
--        canbuy为true代表该物品可以在商店在售列表买到
--		  参与买卖的且无法合成的物品必须在这里标注基础价格
--		  料理不算可合成物品，必须标注价格
--		  价格为nil的物品必须是可合成的，它们在PEItemData初始化时根据合成材料完成计算

local PE_GOODS_LIST={}


PE_GOODS_LIST.food =
{
	{name = "kabobs", price = 36},--肉串
	{name = "meatballs", price = 54},--肉丸
	{name = "bonestew", price = 100},--肉汤
	{name = "meat_dried", price = 60},--肉干
	{name = "turkeydinner", price = 90},--火鸡正餐
	{name = "baconeggs", price = 125},--鸡蛋火腿
	{name = "perogies", price = 114},--饺子
	{name = "hotchili", price = 85},--辣椒酱
	{name = "unagi", price = 76, canbuy = false},--鳗鱼寿司
	{name = "frogglebunwich", price = 64},--青蛙三明治
	{name = "fishtacos", price = 76},--玉米鱼饼
	{name = "fishsticks", price = 112},--鱼条
	{name = "honeynuggets", price = 92},--甜蜜金砖
	{name = "honeyham", price = 142},--蜜汁火腿
	{name = "monsterlasagna", price = 71},--怪兽千层饼
	{name = "powcake", price = 36},--芝士蛋糕
	{name = "butterflymuffin", price = 54},--蝴蝶松饼
	{name = "fruitmedley", price = 64},--水果拼盘
	{name = "ratatouille", price = 58},--蔬菜杂烩
	{name = "jammypreserves", price = 72},--果酱蜜饯
	{name = "trailmix", price = 64},--水果杂烩
	{name = "flowersalad", price = 96},--花瓣沙拉
	{name = "taffy", price = 48},--太妃糖
	{name = "icecream", price = 228, canbuy = false},--冰淇淋
	{name = "waffles", price = 256, canbuy = false},--华夫饼
	{name = "pumpkincookie", price = 76, canbuy = false},--南瓜饼
	{name = "stuffedeggplant", price = 82, canbuy = false},--香酥茄盒
	{name = "watermelonicle", price = 63, canbuy = false},--西瓜冰
	{name = "dragonpie", price = 124, canbuy = false},--火龙果派
	{name = "pepperpopper", price = 58, canbuy = false},--爆炒填馅辣椒
	{name = "mashedpotatoes", price = 120, canbuy = false},--奶油土豆泥
	{name = "potatotornado", price = 68, canbuy = false},--花式回旋块茎
	{name = "salsa", price = 99, canbuy = false},--生鲜萨尔萨酱
	{name = "vegstinger", price = 75, canbuy = false},--蔬菜鸡尾酒
	{name = "asparagussoup", price = 66, canbuy = false},--芦笋汤
	{name = "surfnturf", price = 148},--海鲜牛排
	{name = "seafoodgumbo", price = 138, canbuy = false},--海鲜浓汤
	{name = "californiaroll", price = 107},--加州卷
	{name = "ceviche", price = 135},--酸橘汁腌鱼
	{name = "lobsterdinner", price = 374, canbuy = false},--龙虾正餐
	{name = "lobsterbisque", price = 144},--龙虾汤
	{name = "barnaclestuffedfishhead", price = 87, canbuy = false},--酿鱼头
	{name = "barnaclinguine", price = 96, canbuy = false},--藤壶中细面
	{name = "barnaclepita", price = 48, canbuy = false},--藤壶皮塔饼
	{name = "barnaclesushi", price = 75, canbuy = false},--藤壶握寿司
	{name = "sweettea", price = 46, canbuy = false},--舒缓茶
	{name = "koalefig_trunk", price = 334, canbuy = false},--无花果酿象鼻

	{name = "figkabab", price = 79, canbuy = false},--无花果烤串
	{name = "figatoni", price = 97, canbuy = false},--无花果意面
	{name = "frognewton", price = 51, canbuy = false},--无花果蛙腿三明治
	{name = "meatysalad", price = 108, canbuy = false},--牛肉绿叶菜
	{name = "leafymeatsouffle", price = 123, canbuy = false},--果冻沙拉
	{name = "leafymeatburger", price = 158, canbuy = false},--素食堡
	{name = "leafloaf", price = 117, canbuy = false},--叶肉糕
	{name = "bananapop", price = 66, canbuy = false},--香蕉冻
	
	{name = "bananajuice", price = 70, canbuy = false},--香蕉奶昔
	{name = "frozenbananadaiquiri", price = 78, canbuy = false},--冰香蕉冻唇蜜
	{name = "mandrakesoup", price = 450, canbuy = false},--曼德拉草汤
	{name = "bonesoup", price = 171, canbuy = false},--骨头汤
	{name = "freshfruitcrepes", price = 351, canbuy = false},--鲜果可丽饼
	{name = "moqueca", price = 160, canbuy = false},--海鲜杂烩
	{name = "monstertartare", price = 132, canbuy = false},--怪物达达
	{name = "voltgoatjelly", price = 450, canbuy = false},--伏特羊角冻
	{name = "glowberrymousse", price = 204, canbuy = false},--发光浆果慕斯
	{name = "potatosouffle", price = 148, canbuy = false},--蓬松土豆蛋奶酥
	{name = "frogfishbowl", price = 135, canbuy = false},--蓝带鱼排
	{name = "gazpacho", price = 96, canbuy = false},--芦笋冷汤
	{name = "dragonchilisalad", price = 212, canbuy = false},--辣龙椒沙拉
	{name = "nightmarepie", price = 255, canbuy = false},--恐怖国王饼

	{name = "bunnystew", price = 40},--炖兔子
	{name = "justeggs", price = 48},--普通煎蛋
	{name = "veggieomlet", price = 60},--早餐锅
	{name = "guacamole", price = 36, canbuy = false},--鳄梨酱
	{name = "talleggs", price = 170, canbuy = false},--苏格兰高鸟蛋
	{name = "shroomcake", price = 180, canbuy = false},--蘑菇蛋糕

	{name = "beefalotreat", price = 64},--皮弗娄牛零食
	{name = "beefalofeed", price = 30},--蒸树枝
	{name = "dustmeringue", price = 30, canbuy = false},--琥珀美食

	{name = "yotr_food1", price = 74, canbuy = false},--兔子卷
	{name = "yotr_food2", price = 114, canbuy = false},--月饼
	{name = "yotr_food3", price = 64, canbuy = false},--月冻
	{name = "yotr_food4", price = 76, canbuy = false},--泡芙串
	

	{name = "smallmeat", price = 18},--小肉
	{name = "meat", price = 30},--大肉
	{name = "monstermeat", price = 27},--怪兽肉
	{name = "drumstick", price = 18},--鸡腿
	{name = "bird_egg", price = 12},--鸡蛋
	{name = "fishmeat_small", price = 20},--小鱼块
	{name = "fishmeat", price = 33},--生鱼肉
	{name = "kelp", price = 10},--海带 
	{name = "barnacle", price = 14, canbuy = false},--藤壶
	{name = "fig", price = 11, canbuy = false},--无花果
	{name = "wobster_sheller_land", price = 80},--龙虾
	{name = "wobster_moonglass_land", price = 100, canbuy = false},--月光龙虾

	{name = "eel", price = 60, canbuy = false},--鳗鱼
	{name = "froglegs", price = 14},--青蛙腿
	{name = "plantmeat", price = 33, canbuy = false},--食人花肉
	{name = "batwing", price = 62},--蝙蝠翅膀
	{name = "batnose", price = 43, canbuy = false},--裸露鼻孔
	{name = "trunk_summer", price = 125, canbuy = false},--红色象鼻
	{name = "trunk_winter", price = 200, canbuy = false},--蓝色象鼻
	{name = "berries", price = 3},--浆果
	{name = "berries_juicy", price = 6},--蜜汁浆果
	{name = "rock_avocado_fruit_ripe", price = 8, canbuy = false},--成熟石果
	{name = "cutlichen", price = 4, canbuy = false},--苔藓
	{name = "ice", price = 6},--冰
	{name = "red_cap", price = 8},--红蘑菇
	{name = "green_cap", price = 12},--绿蘑菇
	{name = "blue_cap", price = 16},--蓝蘑菇
	{name = "moon_cap", price = 24, canbuy = false},--月亮蘑菇
	{name = "cactus_meat", price = 19},--仙人掌
	{name = "cactus_flower", price = 30},--仙人掌花
	{name = "cave_banana", price = 16},--香蕉
	{name = "butterflywings", price = 8},--蝴蝶翅膀
	{name = "moonbutterflywings", price = 20, canbuy = false},--月蛾翅膀
	{name = "moon_tree_blossom", price = 10, canbuy = false},--月树花
	{name = "honey", price = 8},--蜂蜜
	{name = "petals", price = 2},--花瓣
	{name = "petals_evil", price = 8, canbuy = false},--噩梦花瓣
	{name = "carrot", price = 12},--胡萝卜
	{name = "corn", price = 18},--玉米
	{name = "durian", price = 24},--榴莲
	{name = "pomegranate", price = 21},--石榴
	{name = "eggplant", price = 28},--茄子
	{name = "pumpkin", price = 35},--南瓜
	{name = "watermelon", price = 30},--西瓜
	{name = "dragonfruit", price = 75},--火龙果
	{name = "asparagus", price = 18},--芦笋
	{name = "onion", price = 33},--洋葱
	{name = "potato", price = 28},--土豆
	{name = "tomato", price = 24},--番茄
	{name = "garlic", price = 21},--大蒜
	{name = "pepper", price = 15},--辣椒
	{name = "forgetmelots", price = 7},--必忘我
	{name = "tillweed", price = 2},--犁地草
	{name = "firenettles", price = 4},--火荨麻叶
}

PE_GOODS_LIST.fight = {
	{name = "armorgrass", price = nil},--草甲
	{name = "armorwood", price = nil},--木甲
	{name = "spear", price = nil},--长矛
	{name = "spear_wathgrithr", price = nil, canbuy = false},--战斗长矛
	{name = "wathgrithrhat", price = nil, canbuy = false},--战斗头盔
	{name = "hambat", price = nil},--火腿棒
	{name = "footballhat", price = nil},--猪皮头盔
	{name = "cookiecutterhat", price = nil, canbuy = false},--饼干切割机帽子
	{name = "tentaclespike", price = 115},--触手棒
	{name = "batbat", price = nil},--蝙蝠棒
	{name = "nightsword", price = nil},--影刀
	{name = "armor_sanity", price = nil},--影甲
	{name = "armormarble", price = nil},--大理石甲
	{name = "whip", price = nil},--猫尾鞭
	{name = "boomerang", price = nil},--飞镖
	{name = "blowdart_pipe", price = nil},--吹箭
	{name = "blowdart_fire", price = nil},--燃烧吹箭
	{name = "blowdart_sleep", price = nil},--麻醉吹箭
	{name = "blowdart_yellow", price = nil},--电磁吹箭
	{name = "firestaff", price = nil},--红魔杖
	{name = "icestaff", price = nil},--蓝魔杖
	{name = "telestaff", price = nil},--紫魔杖

	{name = "healingsalve", price = nil},--药膏
	{name = "tillweedsalve", price = nil},--犁地草膏
	{name = "bandage", price = nil},--蜂蜜药膏

	{name = "gunpowder", price = nil},--炸药
	{name = "trap_teeth", price = nil},--狗牙陷阱
	{name = "beemine", price = nil},--蜜蜂地雷
	{name = "waterplant_bomb", price = 29, canbuy = false},--种壳
}

PE_GOODS_LIST.tool = {
	{name = "axe", price = nil},--斧头
	{name = "shovel", price = nil},--铲子
	{name = "pickaxe", price = nil},--矿锄
	{name = "goldenaxe", price = nil},--金斧头
	{name = "goldenshovel", price = nil},--金铲子
	{name = "goldenpickaxe", price = nil},--金矿锄
	{name = "hammer", price = nil},--锤子
	{name = "pitchfork", price = nil},--草叉
	{name = "razor", price = nil},--剃须刀
	{name = "bugnet", price = nil},--捕虫网
	{name = "birdtrap", price = nil},--捕鸟器
	{name = "beef_bell", price = nil},--皮弗娄牛铃
	{name = "saddle_basic", price = nil},--鞍
	{name = "saddlehorn", price = nil},--取鞍器
	{name = "fishingrod", price = nil},--鱼竿

	{name = "farm_hoe", price = nil},--园艺锄
	{name = "golden_farm_hoe", price = nil},--黄金园艺锄
	{name = "wateringcan", price = nil},--浇水壶
	{name = "farm_plow_item", price = nil},--耕地机
	{name = "soil_amender", price = nil},--催长剂起子
	{name = "plantregistryhat", price = nil},--耕作先驱帽
	{name = "treegrowthsolution", price = nil, canbuy = false},--树果酱

	{name = "pocket_scale", price = nil},--弹簧秤
	{name = "oceanfishingrod", price = nil},--海钓竿
	{name = "oceanfishingbobber_ball", price = nil},--木球浮标
	{name = "oceanfishingbobber_oval", price = nil},--硬物浮标
	{name = "oceanfishinglure_spoon_red", price = nil, canbuy = false},--日出匙型假饵
	{name = "oceanfishinglure_spoon_green", price = nil, canbuy = false},--黄昏匙型假饵
	{name = "oceanfishinglure_spoon_blue", price = nil, canbuy = false},--夜间匙型假饵
	{name = "oceanfishinglure_spinner_red", price = nil, canbuy = false},--日出旋转亮片
	{name = "oceanfishinglure_spinner_green", price = nil, canbuy = false},--黄昏旋转亮片
	{name = "oceanfishinglure_spinner_blue", price = nil, canbuy = false},--夜间旋转亮片


	{name = "oar", price = nil},--浆
	{name = "oar_driftwood", price = nil},--浮木浆
	
	{name = "boat_item", price = nil},--船套装
	{name = "boatpatch", price = nil},--船补丁

	{name = "boat_grass_item", price = nil},--草筏套装

	{name = "boat_bumper_kelp_kit", price = nil},--海带保险杠套装
	{name = "boat_bumper_shell_kit", price = nil, canbuy = false},--贝壳保险杠套装


	{name = "anchor_item", price = nil},--锚套装
	{name = "mast_item", price = nil},--桅杆套装
	{name = "steeringwheel_item", price = nil},--方向舵套装
	{name = "mastupgrade_lamp_item", price = nil},--甲板照明灯
	{name = "mastupgrade_lightningrod_item", price = nil},--避雷导线
	{name = "boat_rotator_kit", price = nil},--转向舵套装
	{name = "ocean_trawler_kit", price = nil, canbuy = false},--海洋拖网捕鱼器套装
	{name = "boat_magnet_kit", price = nil, canbuy = false},--自动航行套装
	{name = "boat_magnet_beacon", price = nil, canbuy = false},--自动航行灯塔
	{name = "boat_cannon_kit", price = nil, canbuy = false},--大炮套装
	{name = "cannonball_rock_item", price = nil},--炮弹
	{name = "dock_kit", price = nil, canbuy = false},--码头套装
	{name = "dock_woodposts_item", price = nil, canbuy = false},--码头桩
}

PE_GOODS_LIST.decoration = {

	{name = "fence_item", price = nil},--栅栏
	{name = "fence_gate_item", price = nil},--木门
	{name = "wall_hay_item", price = nil},--草墙
	{name = "wall_wood_item", price = nil},--木墙
	{name = "wall_stone_item", price = nil},--石墙
	{name = "wall_moonrock_item", price = nil},--月石墙
	{name = "winter_ornament_light1", price = 150},--圣诞灯红
	{name = "winter_ornament_light2", price = 150},--圣诞灯绿
	{name = "winter_ornament_light3", price = 150},--圣诞灯蓝
	{name = "winter_ornament_light4", price = 150},--圣诞灯白

	{name = "turf_grass", price = nil},--长草地皮
	{name = "turf_forest", price = nil},--森林地皮
	{name = "turf_savanna", price = nil},--草地地皮
	{name = "turf_deciduous", price = nil},--季节地皮
	{name = "turf_rocky", price = nil},--岩石地皮
	{name = "turf_carpetfloor", price = nil},--地毯地板
	{name = "turf_checkerfloor", price = nil},--方格地板
	{name = "turf_woodfloor", price = nil},--木质地板
	{name = "turf_road", price = nil},--卵石路
	{name = "turf_pebblebeach", price = nil},--岩石海滩地皮
	{name = "turf_shellbeach", price = nil},--贝壳海滩地皮
	{name = "turf_meteor", price = nil},--月球环形山地皮
	{name = "turf_archive", price = nil},--远古石刻
	{name = "turf_beard_rug", price = nil},--胡须地毯

	{name = "turf_mosaic_blue", price = nil},--蓝色马赛克地
	{name = "turf_mosaic_grey", price = nil},--灰色马赛克地面
	{name = "turf_mosaic_red", price = nil},--红色马赛克地面
	{name = "turf_ruinsbrick_glow", price = nil},--仿远古地面
	{name = "turf_beard_rug", price = nil},--胡须地毯


}

PE_GOODS_LIST.smithing = 
{
	
	{name = "sewing_kit", price = nil},--缝补机
	{name = "strawhat", price = nil},--草帽
	{name = "flowerhat", price = nil},--花环
	{name = "grass_umbrella", price = nil},--花伞
	{name = "umbrella", price = nil},--雨伞
	{name = "minifan", price = nil},--风车
	{name = "beefalohat", price = nil},--牛角帽
	{name = "catcoonhat", price = nil},--猫帽
	{name = "earmuffshat", price = nil},--兔毛耳罩
	{name = "hawaiianshirt", price = nil},--花纹衬衫
	{name = "icehat", price = nil},--冰块
	{name = "raincoat", price = nil},--雨衣
	{name = "rainhat", price = nil},--雨帽
	{name = "reflectivevest", price = nil},--夏季背心
	{name = "trunkvest_summer", price = nil},--夏日背心
	{name = "trunkvest_winter", price = nil},--寒冬背心
	{name = "watermelonhat", price = nil},--西瓜帽
	{name = "kelphat", price = nil},--海花冠
	{name = "winterhat", price = nil},--冬帽
	{name = "nightcaphat", price = 30, canbuy = false},--睡帽
	{name = "torch", price = nil},--火把
	{name = "redlantern", price = 124},--灯笼
	{name = "lantern", price = nil},--提灯
	{name = "minerhat", price = nil},--矿工帽
	{name = "pumpkin_lantern", price = nil},--南瓜灯
	{name = "molehat", price = nil},--地鼠帽

	{name = "beehat", price = nil},--养蜂帽
	{name = "featherhat", price = nil},--羽毛帽
	{name = "bushhat", price = nil},--浆果帽
	{name = "tophat", price = nil},--高礼帽
	{name = "spiderhat", price = 325},--女王帽
	{name = "goggleshat", price = nil},--时尚眼镜
	{name = "sweatervest", price = nil},--小巧背心
	{name = "onemanband", price = nil},--独奏乐器
	{name = "compass", price = nil},--指南针
	{name = "waterballoon", price = nil},--水球
	{name = "amulet", price = nil},--红护符
	{name = "blueamulet", price = nil},--蓝护符
	{name = "purpleamulet", price = nil},--紫护符

	{name = "heatrock", price = nil},--暖石
	{name = "bedroll_straw", price = nil},--稻草卷
	{name = "bedroll_furry", price = nil},--毛皮铺盖
	{name = "bernie_inactive", price = nil, canbuy = false},--小熊
	{name = "giftwrap", price = nil},--彩纸
	{name = "bundlewrap", price = nil},--空包裹
	{name = "featherpencil", price = nil},--羽毛笔
	{name = "lifeinjector", price = nil},--针筒
	{name = "reskin_tool", price = nil},--清洁扫把

	{name = "backpack", price = nil},--背包
	{name = "piggyback", price = nil},--小猪包
	{name = "seedpouch", price = nil},--种子袋

}

	

PE_GOODS_LIST.resource = 
{
	{name = "cutgrass", price = 5},--草
	{name = "twigs", price = 6},--树枝
	{name = "log", price = 10},--木头
	{name = "charcoal", price = 6},--木炭
	{name = "driftwood_log", price = 34},--浮木桩
	{name = "cutreeds", price = 8},--芦苇
	{name = "rocks", price = 8},--石头
	{name = "flint", price = 6},--燧石
	{name = "nitre", price = 12},--硝石
	{name = "goldnugget", price = 14},--金块
	{name = "ash", price = 6},--灰烬

	{name = "rope", price = nil},--绳索
	{name = "boards", price = nil},--木板
	{name = "cutstone", price = nil},--石砖
	{name = "transistor", price = nil},--电子元件
	{name = "papyrus", price = nil},--芦苇
	{name = "beeswax", price = nil},--蜂蜡
	{name = "waxpaper", price = nil},--蜡纸
	{name = "fertilizer", price = nil},--粪桶
	{name = "trinket_6", price = 100, canbuy = false},--烂电线


	{name = "saltrock", price = 22},--盐晶
	{name = "rock_avocado_fruit", price = 18, canbuy = false},--石果
	{name = "marble", price = 34},--大理石
	{name = "moonrocknugget", price = 34},--月石

	{name = "palmcone_scale", price = 48},--棕榈松果树鳞片
	
	{name = "dug_berrybush", price = 27, canbuy = false},--浆果丛
	{name = "dug_berrybush2", price = 34, canbuy = false},--热带浆果丛
	{name = "dug_berrybush_juicy", price = 40, canbuy = false},--蜜汁浆果丛
	{name = "dug_bananabush", price = 25, canbuy = false},--香蕉丛
	{name = "dug_grass", price = 20, canbuy = false},--草丛
	{name = "dug_sapling", price = 17, canbuy = false},--树枝丛
	{name = "dug_sapling_moon", price = 24, canbuy = false},--月岛树枝丛
	{name = "dug_marsh_bush", price = 21, canbuy = false},--尖刺丛
	{name = "dug_monkeytail", price = 40, canbuy = false},--猴尾草
	{name = "dug_rock_avocado_bush", price = 24, canbuy = false},--月岛石果丛



	{name = "pinecone", price = 5},--常青树种子
	{name = "acorn", price = 6},--桦树种子

	{name = "twiggy_nut", price = 6},--多枝树种
	{name = "palmcone_seed", price = 36, canbuy = false},--棕榈松果树芽
	
	{name = "lureplantbulb", price = 180, canbuy = false},--食人花
	{name = "livingtree_root", price = 100, canbuy = false},--完全正常的树根
	{name = "rock_avocado_fruit_sprout", price = 85, canbuy = false},--发芽的石果
	{name = "bullkelp_root", price = 51, canbuy = false},--公牛海带茎
	{name = "waterplant_planter", price = 68, canbuy = false},--海芽插穗
	{name = "dug_trap_starfish", price = 188, canbuy = false},--海星陷阱
	{name = "seeds", price = 6},--种子
	{name = "foliage", price = 6},--蕨叶
	{name = "succulent_picked", price = 10},--肉质植物
	{name = "lightbulb", price = 12},--荧光果
	{name = "wormlight_lesser", price = 24},--小发光浆果
	{name = "wormlight", price = 68, canbuy = false},--发光浆果
	{name = "fireflies", price = 84},--萤火虫
	{name = "lightflier", price = 101, canbuy = false},--球状光虫
	{name = "redgem", price = 100},--红宝石
	{name = "bluegem", price = 100},--蓝宝石
	{name = "purplegem", price = 200},--紫宝石
	{name = "livinglog", price = 90},--活木
	{name = "nightmarefuel", price = 32},--噩梦燃料
	{name = "spidergland", price = 16},--蜘蛛腺体
	{name = "silk", price = 20},--蜘蛛网
	{name = "spidereggsack", price = nil},--蜘蛛巢
	{name = "honeycomb", price = 120},--蜂巢
	{name = "coontail", price = 100},--猫尾
	{name = "boneshard", price = 20},--骨片
	{name = "houndstooth", price = 38},--狗牙
	{name = "stinger", price = 18},--蜂刺
	{name = "cookiecuttershell", price = 52, canbuy = false},--饼干切割机壳
	{name = "messagebottleempty", price = 38, canbuy = false},--空瓶子
	{name = "horn", price = 180},--牛角
	{name = "beefalowool", price = 21},--牛毛
	{name = "pigskin", price = 48},--猪皮
	{name = "manrabbit_tail", price = 53},--兔毛
	{name = "feather_crow", price = 16},--黑鸟毛
	{name = "feather_robin", price = 18},--红鸟毛
	{name = "feather_robin_winter", price = 22},--蓝鸟毛
	{name = "feather_canary", price = 36},--金鸟毛
	{name = "beardhair", price = 20},--胡须
	{name = "tentaclespots", price = 74},--触手皮
	{name = "mosquitosack", price = 32},--血袋
	{name = "rottenegg", price = 10},--臭鸡蛋
	{name = "spoiled_food", price = 6},--腐烂食物
	{name = "poop", price = 12},--屎
	{name = "guano", price = 10},--鸟屎
	{name = "phlegm", price = 100},--鼻涕
	{name = "glommerfuel", price = 38},--格罗姆粘液
	{name = "slurtleslime", price = 30},--含糊虫粘液
	{name = "slurtle_shellpieces", price = 30},--外壳碎片
	{name = "spore_medium", price = 55},--红色孢子
	{name = "spore_small", price = 55},--绿色孢子
	{name = "spore_tall", price = 55},--蓝色孢子
	{name = "ghostflower", price = 200, canbuy = false},--哀悼荣耀
	{name = "tallbirdegg", price = 130, canbuy = false},--高鸟蛋
	--小动物
	{name = "butterfly", price = 16},--蝴蝶
	{name = "bee", price = 22},--蜜蜂
	{name = "rabbit", price = 24},--兔子
	{name = "mole", price = 36},--地鼠
	{name = "carrat", price = 42, canbuy = false},--胡萝卜鼠
	{name = "lightcrab", price = 136, canbuy = false},--发光蟹
	--鸟类
	{name = "crow", price = 22},--黑鸟
	{name = "robin", price = 33},--红鸟
	{name = "robin_winter", price = 44},--蓝鸟
	{name = "puffin", price = 48},--海鹦鹉
	{name = "canary", price = 55},--金丝雀
	{name = "canary_poisoned", price = 125},--中毒金丝雀
	{name = "bird_mutant", price = 78, canbuy = false},--月茫无涯！
	{name = "bird_mutant_spitter", price = 78, canbuy = false},--奇形鸟
	--鱼类
	{name = "oceanfish_medium_1_inv", price = 136, canbuy = false},--泥鱼
	{name = "oceanfish_medium_2_inv", price = 136, canbuy = false},--斑鱼
	{name = "oceanfish_medium_3_inv", price = 136, canbuy = false},--浮夸狮子鱼
	{name = "oceanfish_medium_4_inv", price = 136, canbuy = false},--黑鲶鱼
	{name = "oceanfish_medium_5_inv", price = 150, canbuy = false},--玉米鳕鱼
	{name = "oceanfish_medium_6_inv", price = 136, canbuy = false},--花锦鲤
	{name = "oceanfish_medium_7_inv", price = 150, canbuy = false},--金锦鲤
	{name = "oceanfish_medium_8_inv", price = 150, canbuy = false},--冰鲷鱼
	{name = "oceanfish_medium_9_inv", price = 150, canbuy = false},--甜味鱼
	{name = "oceanfish_small_1_inv", price = 90, canbuy = false},--小孔雀鱼
	{name = "oceanfish_small_2_inv", price = 90, canbuy = false},--针鼻喷墨鱼
	{name = "oceanfish_small_3_inv", price = 90, canbuy = false},--小饵鱼
	{name = "oceanfish_small_4_inv", price = 90, canbuy = false},--三文鱼苗
	{name = "oceanfish_small_5_inv", price = 90, canbuy = false},--爆米花鱼
	{name = "oceanfish_small_6_inv", price = 150, canbuy = false},--落叶比目鱼(秋)
	{name = "oceanfish_small_7_inv", price = 150, canbuy = false},--花朵金枪鱼(春)
	{name = "oceanfish_small_8_inv", price = 150, canbuy = false},--炽热太阳鱼
	{name = "oceanfish_small_9_inv", price = 60, canbuy = false},--口水鱼
	
}

PE_GOODS_LIST.precious = 
{
	--{name = "blueprint", price = 250},--蓝图
	--常规可食用的
	{name = "batnosehat", price = 800},--牛奶帽
	{name = "goatmilk", price = 1000},--电羊奶
	{name = "butter", price = 800},--蝴蝶黄油
	{name = "mandrake", price = 2400},--曼德拉草
	--巨鹿相关
	{name = "deerclops_eyeball", price = 2400},--眼球
	{name = "eyebrellahat", price = nil},--眼球伞
	--克劳斯相关
	{name = "deer_antler3", price = 240},--鹿角钥匙
	{name = "klaussackkey", price = 2000},--真钥匙
	--麋鹿鹅相关
	{name = "goose_feather", price = 200},--鹅毛
	--熊大相关
	{name = "bearger_fur", price = 2800},--熊皮
	{name = "icepack", price = nil},--冰背包
	{name = "beargervest", price = nil},--熊皮大衣
	--龙蝇相关
	{name = "dragon_scales", price = 600},--龙鳞
	{name = "lavae_egg", price = 600},--熔岩虫卵
	{name = "armordragonfly", price = nil},--龙鳞衣
	--蜂后相关
	{name = "hivehat", price = 2000},--蜂王冠
	{name = "royal_jelly", price = 1500},--蜂王浆
	{name = "jellybean", price = 600},--糖豆
	--蚁狮
	{name = "townportaltalisman", price = 300},--沙之石	
	--影织者
	{name = "fossil_piece", price = 400},--化石碎片
	{name = "armorskeleton", price = 4000},--骨甲
	{name = "skeletonhat", price = 3200},--骨盔
	{name = "thurible", price = 2400},--暗影香炉	
	--{name = "atrium_key", price = 1200},--远古钥匙
	{name = "shadowheart", price = 800},--暗影之心
	--毒菌蟾蜍相关
	{name = "sleepbomb", price = nil},--催眠袋
	{name = "red_mushroomhat", price = nil},--红菇帽
	{name = "green_mushroomhat", price = nil},--绿菇帽
	{name = "blue_mushroomhat", price = nil},--蓝菇帽
	{name = "shroom_skin", price = 1600},--蛤蟆皮

	--天体相关
	{name = "purebrilliance", price = 300},-- 纯粹辉煌
	{name = "moonstorm_spark", price = 200},--月熠
	{name = "moonglass_charged", price = 220, canbuy = false},--灌注月亮碎片
	{name = "moonstorm_static_item", price = 2000},--约束静电
	--{name = "moonrockseed", price = 2000},--天体宝球
	{name = "alterguardianhat", price = 8000},--启迪之冠
	{name = "alterguardianhatshard", price = 1000},--启迪之冠碎片
	--远古相关
	{name = "greengem", price = 1400},--绿宝石
	{name = "orangegem", price = 1100},--橙宝石
	{name = "yellowgem", price = 1100},--黄宝石
	{name = "eyeturret_item", price = nil},--眼球塔
	{name = "greenstaff", price = nil},--绿法杖
	{name = "orangestaff", price = nil},--橙法杖
	{name = "yellowstaff", price = nil},--黄法杖
	{name = "gears", price = 400},--齿轮
	{name = "minotaurhorn", price = 2500},--犀牛角
	{name = "thulecite_pieces", price = 30, canbuy = false},--铥矿碎片
	{name = "thulecite", price = nil, canbuy = false},--铥矿
	{name = "armorruins", price = nil},--铥矿甲
	{name = "ruins_bat", price = nil},--铥矿棒
	{name = "ruinshat", price = nil},--铥矿头盔
	{name = "greenamulet", price = nil},--建造护符
	{name = "orangeamulet", price = nil},--懒人护符
	{name = "yellowamulet", price = nil},--魔光护符
	--暗影系列（2023.6.30）
	{name = "voidcloth", price = 400, canbuy = false},--暗影碎布
	{name = "voidcloth_scythe", price = nil},--暗影收割者
	{name = "voidcloth_umbrella", price = nil},--暗影伞
	{name = "voidclothhat", price = nil},--虚空风帽
	{name = "armor_voidcloth", price = nil},--虚空长袍
	--亮茄系列（2023.6.30）
	{name = "lunarplant_husk", price = 200, canbuy = false},--亮茄壳
	{name = "bomb_lunarplant", price = nil},--亮茄炸弹.1
	{name = "staff_lunarplant", price = nil},--亮茄魔杖
	{name = "sword_lunarplant", price = nil},--亮茄剑
	{name = "armor_lunarplant", price = nil},--亮茄盔甲.1
	{name = "lunarplanthat", price = nil},--亮茄头盔
	{name = "pickaxe_lunarplant", price = nil},--亮茄粉碎者
	{name = "shovel_lunarplant", price = nil},--亮茄铲子
	--航海
	{name = "monkey_mediumhat", price = 2400},--船长的三角帽
	{name = "polly_rogershat", price = 2800},--波莉·罗杰的帽子
	{name = "malbatross_feather", price = 800},--邪天翁羽毛
	{name = "malbatross_beak", price = 1000},--邪天翁喙
	{name = "gnarwail_horn", price = 650},--一角鲸的角
	{name = "hermit_pearl", price = 2000},--珍珠的珍珠
	{name = "hermit_cracked_pearl", price = 100, canbuy = false},--开裂珍珠
	--{name = "messagebottle", price = 250},--瓶中信
	{name = "trident", price = nil},--刺耳三叉戟
	{name = "moonbutterfly", price = 300},--月蛾
	{name = "moonglass", price = 200},--月亮碎片
	--疯猪
	{name = "horrorfuel", price = 1000, canbuy = false},--纯粹恐惧
	{name = "dreadstone", price = 300, canbuy = false},--绝望石
	{name = "armordreadstone", price = nil},--绝望石甲
	{name = "dreadstonehat", price = nil},--绝望石盔
	--水中木
	{name = "oceantreenut", price = 9999},--疙瘩树果
	--坎普斯
	{name = "krampus_sack", price = 9999},--小偷包
	--钢羊
	{name = "steelwool", price = 800},--刚羊毛
	--海象
	{name = "walrus_tusk", price = 800},--海象牙
	{name = "walrushat", price = 2000},--海象帽
	--韦伯玩家
	--{name = "spider_healer", price = 520, canbuy = false},--护士蜘蛛
	
	--其他
	{name = "nightstick", price = nil},--晨星
	{name = "panflute", price = nil},--排箫	
	{name = "staff_tornado", price = nil},--旋风

	--{name = "oar_monkey", price = 300},--战浆

	{name = "lightninggoathorn", price = 1200},--电羊角
	{name = "slurper_pelt", price = 450},--辍食者皮
	{name = "slurtlehat", price = 1200},--蜗牛帽
	{name = "armorsnurtleshell", price = 1800},--蜗牛壳
	{name = "armorslurper", price = nil},--饥饿腰带
	{name = "cane", price = nil},--步行手杖
	{name = "featherfan", price = nil},--鹅毛扇
	{name = "opalstaff", price = 7400},--唤月法杖
	{name = "saddle_race", price = nil},--蝴蝶鞍
	{name = "saddle_war", price = nil},--战斗鞍
	{name = "deserthat", price = nil},--风镜

	--三基佬相关
	{name = "trinket_15", price = 200, canbuy = false},--白主教
	{name = "trinket_16", price = 200, canbuy = false},--黑主教
	{name = "trinket_28", price = 200, canbuy = false},--白战车
	{name = "trinket_29", price = 200, canbuy = false},--黑战车
	{name = "trinket_30", price = 200, canbuy = false},--白骑士
	{name = "trinket_31", price = 200, canbuy = false},--黑骑士
}

PE_GOODS_LIST.special = 
{
	{name = "oinc_yuan", price = 100},
	{name = "oinc10_yuan", price = 1000},
	{name = "oinc100_yuan", price = 10000},
	{name = "coffee", price = 200},
}

--特殊蓝图
PE_GOODS_LIST.blueprint = 
{
	{name = "mushroom_light_blueprint", price = 2000},--萤菇灯
	{name = "mushroom_light2_blueprint", price = 2000},--炽菇灯
	{name = "bundlewrap_blueprint", price = 2000},--空包裹
	{name = "sleepbomb_blueprint", price = 2000},--睡球
	{name = "endtable_blueprint", price = 2000},--茶几
	{name = "dragonflyfurnace_blueprint", price = 2000},--龙鳞熔炉
	{name = "townportal_blueprint", price = 2000},--沙传送阵
	{name = "goggleshat_blueprint", price = 2000},--时尚眼镜
	{name = "deserthat_blueprint", price = 2000},--风镜
	{name = "red_mushroomhat_blueprint", price = 2000},--红菇帽
	{name = "green_mushroomhat_blueprint", price = 2000},--绿菇帽
	{name = "blue_mushroomhat_blueprint", price = 2000},--蓝菇帽

	{name = "wall_dreadstone_item_blueprint", price = 1000},--绝望石墙蓝图
	{name = "ruinsrelic_chair_blueprint", price = 1000},--遗迹复制品
}


return PE_GOODS_LIST