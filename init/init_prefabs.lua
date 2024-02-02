PrefabFiles = {
	"shop_pedestal",
	"oinc_yuan",
}

if not TUNING.PUREECOMOMICS.DISABLE_COFFEE then
	table.insert(PrefabFiles,"coffee")
	table.insert(PrefabFiles,"coffeebeans")
	table.insert(PrefabFiles,"dug_coffeebush")
	table.insert(PrefabFiles,"coffeebush")
end

if not TUNING.PUREECOMOMICS.DISABLE_SLOTMACHINE then
	table.insert(PrefabFiles,"pe_slotmachine")
end