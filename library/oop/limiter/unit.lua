local expander = ClassExpander(CLASS_EXPANDS_LMT, UnitClass)

---@param obj Unit
expander["hpCur"] = function(obj, value)
    local v = obj:propData("hp")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end

---@param obj Unit
expander["mpCur"] = function(obj, value)
    local v = obj:propData("mp")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end

---@param obj Unit
expander["shieldCur"] = function(obj, value)
    local v = obj:propData("shield")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end

---@param obj Unit
expander["punishCur"] = function(obj, value)
    local v = obj:propData("punish")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end

---@param obj Unit
expander["weightCur"] = function(obj, value)
    local v = obj:propData("weight")
    if (type(v) == "number") then
        value = math.min(value, v)
    end
    return value
end
