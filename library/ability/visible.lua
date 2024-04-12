--- 反隐光环
---@param whichUnit Unit
---@param value number 反隐范围，设0取消
function ability.visible(whichUnit, value)
    local h = whichUnit:handle()
    local radius = 100 * math.round(value / 100)
    for _, v in ipairs(FRAMEWORK_ID["visible"]) do
        local id = v[2]
        if (J.GetUnitAbilityLevel(h, id) > 0) then
            J.UnitRemoveAbility(h, id)
        end
        if (J.GetUnitAbilityLevel(h, id) > 0) then
            J.UnitRemoveAbility(h, id)
        end
    end
    if (radius >= 100) then
        radius = math.min(radius, 2000)
        for _, v in ipairs(FRAMEWORK_ID["visible"]) do
            local r = v[1]
            local id = v[2]
            if (r == radius) then
                if (J.GetUnitAbilityLevel(h, id) == 0) then
                    J.UnitAddAbility(h, id)
                end
                break
            end
        end
    end
end