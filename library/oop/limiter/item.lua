local expander = ClassExpander(CLASS_EXPANDS_LMT, ItemClass)

---@param obj Item
expander["hpCur"] = function(obj, value)
    local v = obj:propData("hp")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end
