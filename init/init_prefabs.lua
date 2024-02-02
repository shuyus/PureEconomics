PrefabFiles = {
	"shop_pedestal",
	"oinc_yuan",
}

if not TUNING.PUREECOMOMICS.DISABLECOFFEE then
	table.insert(PrefabFiles,"coffee")
	table.insert(PrefabFiles,"coffeebeans")
	table.insert(PrefabFiles,"dug_coffeebush")
	table.insert(PrefabFiles,"coffeebush")
end

if not TUNING.PUREECOMOMICS.DISABLESLOTMACHINE then
	table.insert(PrefabFiles,"pe_slotmachine")
end