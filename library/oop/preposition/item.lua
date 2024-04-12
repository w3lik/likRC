local expander = ClassExpander(CLASS_EXPANDS_PRE, ItemClass)

---@param obj Item
expander["bindUnit"] = function(obj)
    ---@type Unit
    local prev = obj:bindUnit()
    if (isClass(prev, UnitClass)) then
        prev:itemSlot():remove(obj:itemSlotIndex())
        obj:clear("bindUnit")
    end
end

---@param obj Item
expander["ability"] = function(obj)
    ---@type Ability
    local prev = obj:ability()
    if (isClass(prev, AbilityClass)) then
        local bu = obj:bindUnit()
        prev:clear("bindItem")
        event.trigger(prev, EVENT.Ability.Lose, { triggerAbility = prev, triggerUnit = bu })
        event.trigger(bu, EVENT.Ability.Lose, { triggerAbility = prev, triggerUnit = bu })
    end
end
