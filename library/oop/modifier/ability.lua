local expander = ClassExpander(CLASS_EXPANDS_MOD, AbilityClass)

---@param obj Ability
expander["attributes"] = function(obj, prev)
    ---@type {string,number}[]
    local data = obj:propData("attributes")
    local eKey = "attributes"
    event.unregister(obj, EVENT.Ability.Get, eKey)
    event.unregister(obj, EVENT.Ability.Lose, eKey)
    event.unregister(obj, EVENT.Ability.LevelChange, eKey)
    if (type(data) == "table") then
        for i = #data, 1, -1 do
            local method = data[i][1]
            local base = data[i][2]
            local vary = data[i][3]
            if (type(method) ~= "string" or (base == nil and vary == nil)) then
                table.remove(data, i)
            end
        end
        if (type(prev) == "table") then
            local u = obj:bindUnit()
            if (isClass(u, UnitClass)) then
                local lv = obj:level()
                attribute.clever(prev, u, lv, -lv)
                attribute.clever(data, u, 0, lv)
            end
        end
        ---@param getData noteOnAbilityGetData
        obj:onEvent(EVENT.Ability.Get, eKey, function(getData)
            attribute.clever(data, getData.triggerUnit, 0, getData.triggerAbility:level())
        end)
        ---@param loseData noteOnAbilityLoseData
        obj:onEvent(EVENT.Ability.Lose, eKey, function(loseData)
            attribute.clever(data, loseData.triggerUnit, loseData.triggerAbility:level(), -loseData.triggerAbility:level())
        end)
        ---@param lvcData noteOnAbilityLevelChangeData
        obj:onEvent(EVENT.Ability.LevelChange, eKey, function(lvcData)
            attribute.clever(data, lvcData.triggerUnit, lvcData.triggerAbility:level(), lvcData.value)
        end)
    end
end

---@param obj Ability
expander["abilitySlotIndex"] = function(obj)
    ---@type number
    local data = obj:propData("abilitySlotIndex")
    obj:propChange("hotkey", "std", Game():abilityHotkey(data), false)
end

---@param obj Ability
expander["exp"] = function(obj)
    ---@type number
    local data = obj:propData("exp")
    local lv = obj:propData("level") or 0
    if (lv >= 1) then
        local lvn = 0
        for i = Game():abilityLevelMax(), 1, -1 do
            if (data >= Game():abilityExpNeeds(i)) then
                lvn = i
                break
            end
        end
        if (lvn ~= lv) then
            obj:level(lvn)
        end
    end
end

---@param obj Ability
---@param prev number
expander["level"] = function(obj, prev)
    ---@type number
    local data = obj:propData("level")
    prev = prev or 0
    local bu = obj:bindUnit()
    event.trigger(obj, EVENT.Ability.LevelChange, { triggerAbility = obj, triggerUnit = bu, value = data - prev })
    event.trigger(bu, EVENT.Ability.LevelChange, { triggerAbility = obj, triggerUnit = bu, data - prev })
    if ((obj:exp() or 0) > 0) then
        if ((data > 1 and data > prev) or data < prev) then
            obj:propChange("exp", "std", Game():abilityExpNeeds(data), false)
        end
    end
end