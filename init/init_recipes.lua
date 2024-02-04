require("recipe")

AddRecipe2(
    "shop_pedestal", {
        Ingredient("boards", 5)}, 
        TECH.SCIENCE_ONE, {
        atlas = "images/shop_pedestal.xml", image = "shop_pedestal.tex",
        placer = "shop_pedestal_placer"
    }, {"STRUCTURES" }
)

if not TUNING.PUREECOMOMICS.DISABLE_COFFEE then
    AddIngredientValues({"coffeebeans"}, {veggie=.5})
    AddIngredientValues({"coffeebeans_cooked"}, {veggie=1})
    AddCookerRecipe("cookpot", {
        name = "coffee",
        test = function(cooker, names, tags)
            return names.coffeebeans_cooked
            and ((names.coffeebeans_cooked == 3 and (names.butter or tags.dairy or names.honey or tags.sweetener))
            or (names.coffeebeans_cooked == 4))
        end,
        priority = 30,
        weight = 1,
        foodtype = "GOODIES",
        health = 3,
        hunger = 10,
        perishtime = TUNING.PERISH_FAST,
        sanity = -5,
        cooktime = .25,
        tags = {},
    })
end


if not TUNING.PUREECOMOMICS.DISABLE_SLOTMACHINE then
    AddRecipe2(
        "pe_slotmachine", {
            Ingredient("boards", 5)}, 
            TECH.SCIENCE_ONE, {
            atlas = "images/slot_machine.xml", image = "slot_machine.tex",
            placer = "pe_slotmachine_placer"
        }, {"STRUCTURES" }
    )
end



