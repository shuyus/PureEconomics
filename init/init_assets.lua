Assets = {

    Asset("ATLAS", "images/inventoryimages/oinc_yuan.xml"),
    Asset("IMAGE", "images/inventoryimages/oinc_yuan.tex"),
    Asset("ATLAS", "images/inventoryimages/oinc10_yuan.xml"),
    Asset("IMAGE", "images/inventoryimages/oinc10_yuan.tex"),
    Asset("ATLAS", "images/inventoryimages/oinc100_yuan.xml"),
    Asset("IMAGE", "images/inventoryimages/oinc100_yuan.tex"),
    ----------------------------------------
    Asset("ANIM", "anim/pedestal_crate.zip"),
    Asset("IMAGE", "images/shop_pedestal.tex"),
    Asset("ATLAS", "images/shop_pedestal.xml"),
    Asset("IMAGE", "map_icons/minimap_shoppedestal.tex"),
    Asset("ATLAS", "map_icons/minimap_shoppedestal.xml"),
    
}

AddMinimapAtlas("map_icons/minimap_shoppedestal.xml")



if not TUNING.PUREECOMOMICS.DISABLE_COFFEE then
    local coffee_assets = {
        Asset("ANIM", "anim/coffee.zip"),
        Asset("IMAGE", "images/inventoryimages/coffee.tex" ),
        Asset("ATLAS", "images/inventoryimages/coffee.xml" ),
        Asset("IMAGE", "images/inventoryimages/coffeeinventory.tex"),
        Asset("ATLAS", "images/inventoryimages/coffeeinventory.xml"),
        Asset("IMAGE", "map_icons/minimap_coffeebush.tex"),
        Asset("ATLAS", "map_icons/minimap_coffeebush.xml"),
    }

    for _,t in ipairs(coffee_assets) do
        table.insert(Assets,t)
    end

    AddMinimapAtlas("map_icons/minimap_coffeebush.xml")
end

if not TUNING.PUREECOMOMICS.DISABLE_SLOTMACHINE then
	local slotmachine_assets = {
        Asset("ANIM", "anim/slot_machine.zip"),
        Asset("SOUNDPACKAGE", "sound/SLOT.fev"),
        Asset("IMAGE", "images/slot_machine.tex"),
        Asset("ATLAS", "images/slot_machine.xml"),
        Asset("SOUND", "sound/SLOT.fsb"),
        Asset("IMAGE", "map_icons/minimap_slotmachine.tex"),
        Asset("ATLAS", "map_icons/minimap_slotmachine.xml"),
    }

    for _,t in ipairs(slotmachine_assets) do
        table.insert(Assets,t)
    end

    AddMinimapAtlas("map_icons/minimap_slotmachine.xml")
end