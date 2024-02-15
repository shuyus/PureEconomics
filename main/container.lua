-- container.lua
-- Author: 勿言
-- LastEdit: 2024.2.15
-- Using: 容器添加

local containers = require("containers")

local params = {}

params.pesellpedestal = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(150, 0, 0),
        side_align_tip = 100,
        buttoninfo = {
            text = STRINGS.PUREECOMOMICS.SELL_BUTTON,
            position = Vector3(0, -160, 0),
        }
    },
    type = "sell",
    openlimit = 1,
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.pesellpedestal.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

function params.pesellpedestal.widget.buttoninfo.fn(inst)
    if TheWorld.ismastersim then  
        PESellFn(table.getkeys(inst.components.container.openlist)[1], inst)
    else
        SendModRPCToServer(MOD_RPC["PureEconomics"]["PEsell"], inst)
    end
end

for k, v in pairs(params) do
    containers.params[k] = v
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

params = nil