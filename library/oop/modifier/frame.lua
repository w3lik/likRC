local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameClass)

---@param obj Frame
expander["size"] = function(obj)
    ---@type number[]
    local data = obj:propData("size")
    japi.FrameSetSize(obj:handle(), data[1], data[2])
end

---@param obj Frame
expander["relation"] = function(obj)
    ---@type number[]
    local data = obj:propData("relation")
    japi.FrameClearAllPoints(obj:handle())
    japi.FrameSetPoint(obj:handle(), data[1], data[2]:handle(), data[3], data[4], data[5])
end

dhsadhioa = 0

---@param obj Frame
expander["show"] = function(obj)
    ---@type boolean
    local data = obj:propData("show")
    japi.FrameShow(obj:handle(), data)
    if (data == true) then
        event.trigger(obj, EVENT.Frame.Show, { triggerFrame = obj })
    else
        event.trigger(obj, EVENT.Frame.Hide, { triggerFrame = obj })
    end
    if (obj:esc() == true) then
        view.esc(obj, data)
    end
    local f2m
    f2m = function(o)
        local evtList = event.data(o)
        if (type(evtList) == "table") then
            ---@param v Array
            for evt, v in pairx(evtList) do
                v:backEach(function(key, callFunc)
                    view.frame2Mouse(o, evt, data, key, callFunc)
                end)
            end
        end
        local child = o:children()
        if (type(child) == "table") then
            for _, c in pairx(child) do
                f2m(c)
            end
        end
    end
    f2m(obj)
end