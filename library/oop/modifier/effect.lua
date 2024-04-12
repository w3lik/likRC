local expander = ClassExpander(CLASS_EXPANDS_MOD, EffectClass)

---@param obj Effect
expander["position"] = function(obj)
    ---@type number[]
    local data = obj:propData("position")
    if (type(data[3]) ~= "number") then
        data[3] = japi.Z(data[1], data[2])
    end
    local positionOrigin = obj:propData("positionOrigin")
    local d = vector2.distance(positionOrigin[1], positionOrigin[2], data[1], data[2])
    if (d > 1000) then
        japi.EXSetEffectZ(obj:handle(), -9999)
        href(obj, J.AddSpecialEffect(obj:model(), data[1], data[2]))
        obj:propChange("positionOrigin", "std", data, false)
        obj:propChange("position", "std", data, false)
        obj:propChange("rotateX", "std", 0, false)
        obj:propChange("rotateY", "std", 0, false)
        obj:propChange("rotateZ", "std", 0, false)
        obj:restruct()
    else
        japi.EXSetEffectXY(obj:handle(), data[1], data[2])
    end
    japi.EXSetEffectZ(obj:handle(), data[3])
end

---@param obj Effect
expander["size"] = function(obj)
    japi.EXSetEffectSize(obj:handle(), obj:propData("size"))
end

---@param obj Effect
expander["speed"] = function(obj)
    japi.EXSetEffectSpeed(obj:handle(), obj:propData("speed"))
end

---@param obj Effect
---@param prev number
expander["rotateX"] = function(obj, prev)
    japi.EXEffectMatRotateX(obj:handle(), obj:propData("rotateX") - (prev or 0))
end

---@param obj Effect
---@param prev number
expander["rotateY"] = function(obj, prev)
    local data = obj:propData("rotateY")
    local rz = obj:propData("rotateZ")
    prev = prev or 0
    if (rz > 90 and rz < 270) then
        data = -data
        prev = -prev
    end
    japi.EXEffectMatRotateY(obj:handle(), data - prev)
end

---@param obj Effect
---@param prev number
expander["rotateZ"] = function(obj, prev)
    japi.EXEffectMatRotateZ(obj:handle(), obj:propData("rotateZ") - (prev or 0))
end

---@param obj Effect
expander["duration"] = function(obj)
    ---@type Timer
    local t = obj:prop("durationTimer")
    if (isClass(t, TimerClass)) then
        obj:clear("durationTimer", true)
    end
    local data = obj:propData("duration")
    if (data == 0) then
        destroy(obj)
    elseif (data > 0) then
        t = time.setTimeout(data, function()
            destroy(obj)
        end)
        obj:prop("durationTimer", t)
    end
end