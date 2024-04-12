---@param stage UI_LikPlateStage
function likPlate_params(stage)

    stage.plateBarW = 0.0772
    stage.plateBarH = 0.013

    stage.abilityMAX = #Game():abilityHotkey()

    stage.itemMAX = #Game():itemHotkey()

    stage.warehouseMAX = Game():warehouseSlot()
    stage.warehouseRaw = 4
    stage.warehouseSize = 0.03
    stage.warehouseMarginW = 0.003
    stage.warehouseMarginH = 0.002
    stage.warehouseResAllow = {}
    stage.warehouseResOpt = {
        --lumber = { texture = 'Framework\\ui\\lumber', color = 'FED112', x = 3, y = 2 },
        gold = { texture = 'Framework\\ui\\gold.tga', color = 'FED112', x = 0.02, y = -0.03 },
        silver = { texture = 'Framework\\ui\\silver.tga', color = 'BEC8EB', x = 0.02, y = -0.043 },
        copper = { texture = 'Framework\\ui\\copper.tga', color = 'D7AE8E', x = 0.08, y = -0.043 },
    }
    local res = Game():worth()
    res:forEach(function(key, value)
        if (stage.warehouseResOpt[key]) then
            stage.warehouseResOpt[key].name = value.name
            if (false == table.includes(stage.warehouseResAllow, key)) then
                table.insert(stage.warehouseResAllow, key)
            end
        else
            stage.warehouseResOpt[key] = { name = value.name }
        end
    end)

end