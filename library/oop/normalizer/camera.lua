local expander = ClassExpander(CLASS_EXPANDS_NOR, CameraClass)

---@param value number
expander["farZ"] = function(_, value)
    value = math.min(3000, value)
    value = math.max(100, value)
    return value
end

---@param value number
expander["zOffset"] = function(_, value)
    value = math.min(3000, value)
    value = math.max(-1000, value)
    return value
end

---@param value number
expander["fov"] = function(_, value)
    value = math.min(120, value)
    value = math.max(20, value)
    return value
end

---@param value number
expander["xTra"] = function(_, value)
    value = math.min(350, value)
    value = math.max(270, value)
    return value
end

---@param value number
expander["yTra"] = function(_, value)
    value = math.min(280, value)
    value = math.max(80, value)
    return value
end

---@param value number
expander["zTra"] = function(_, value)
    value = math.min(280, value)
    value = math.max(80, value)
    return value
end

---@param value number
expander["distance"] = function(_, value)
    value = math.min(3000, value)
    value = math.max(400, value)
    return value
end