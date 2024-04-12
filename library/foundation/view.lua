---@class
view = view or {}

---@private
---@type Array
view._evtAdaptive = view._evtAdaptive or nil
---@private
---@type Array
view._evtEsc = view._evtEsc or nil
---@private
---@type Array
view._evtResize = view._evtResize or nil

-- 视图初始化
---@private
view._init = function()
    view._evtResize = Array()
    view._evtAdaptive = Array()
    view._evtEsc = Array()
    J.Japi["DzTriggerRegisterWindowResizeEventByCode"](nil, false, function()
        if (view._evtResize:count() > 0) then
            local triggerPlayer = Player(1 + J.GetPlayerId(japi.GetTriggerKeyPlayer()))
            async.call(triggerPlayer, function()
                view._evtResize:forEach(function(_, v)
                    J.Promise(v, nil, nil, { triggerPlayer = triggerPlayer })
                end)
            end)
        end
    end)
    keyboard.onRelease(KEYBOARD["Esc"], "esc_", function()
        local keys = view._evtEsc:keys()
        local l = #keys
        if (l > 0) then
            local key = keys[l]
            local val = view._evtEsc:get(key)
            val:show(false)
            view._evtEsc:set(key, nil)
        end
    end)
    local smooth = {}
    view.onResize("adaptive_", function(evtData)
        local pIdx = evtData.triggerPlayer:index()
        if (isClass(smooth[pIdx], TimerClass)) then
            smooth[pIdx]:remain(smooth[pIdx]:period())
            return
        end
        smooth[pIdx] = time.setTimeout(0.1, function()
            smooth[pIdx] = nil
            ---@param value Frame
            view._evtAdaptive:forEach(function(_, value)
                if (instanceof(value, "Frame")) then
                    if (true == value:adaptive()) then
                        local s = value:prop("unAdaptiveSize")
                        local r = value:prop("unAdaptiveRelation")
                        if (type(s) == "table") then
                            value:size(table.unpack(s))
                        end
                        if (type(r) == "table") then
                            value:relation(table.unpack(r))
                        end
                    end
                end
            end)
        end)
    end)
end

---@param whichFrame Frame
function view.isGameUI(whichFrame)
    if (FrameGameUI == nil) then
        return whichFrame:handle() == japi.GetGameUI()
    end
    return whichFrame:id() == FrameGameUI:id()
end

--- 锚指的是一个frame的中心，相对于屏幕左下角的{X,Y,W,H}(RX)
---@param whichFrame Frame
---@return noteAnchorData
function view.setAnchor(whichFrame)
    local relative = whichFrame:relation()
    local size = whichFrame:size()
    if (relative ~= nil and size ~= nil) then
        ---@type noteAnchorData
        local anchorParent = relative[2]:anchor()
        if (anchorParent ~= nil) then
            local point = relative[1]
            local relativePoint = relative[3]
            -- 偏移度
            local aw
            local ah
            local pw
            local ph
            if (point == FRAME_ALIGN_LEFT_TOP or point == FRAME_ALIGN_LEFT or point == FRAME_ALIGN_LEFT_BOTTOM) then
                aw = 1
            elseif (point == FRAME_ALIGN_TOP or point == FRAME_ALIGN_CENTER or point == FRAME_ALIGN_BOTTOM) then
                aw = 0
            elseif (point == FRAME_ALIGN_RIGHT_TOP or point == FRAME_ALIGN_RIGHT or point == FRAME_ALIGN_RIGHT_BOTTOM) then
                aw = -1
            end
            if (point == FRAME_ALIGN_LEFT_TOP or point == FRAME_ALIGN_TOP or point == FRAME_ALIGN_RIGHT_TOP) then
                ah = -1
            elseif (point == FRAME_ALIGN_LEFT or point == FRAME_ALIGN_CENTER or point == FRAME_ALIGN_RIGHT) then
                ah = 0
            elseif (point == FRAME_ALIGN_LEFT_BOTTOM or point == FRAME_ALIGN_BOTTOM or point == FRAME_ALIGN_RIGHT_BOTTOM) then
                ah = 1
            end
            if (relativePoint == FRAME_ALIGN_LEFT_TOP or relativePoint == FRAME_ALIGN_LEFT or relativePoint == FRAME_ALIGN_LEFT_BOTTOM) then
                pw = -1
            elseif (relativePoint == FRAME_ALIGN_TOP or relativePoint == FRAME_ALIGN_CENTER or relativePoint == FRAME_ALIGN_BOTTOM) then
                pw = 0
            elseif (relativePoint == FRAME_ALIGN_RIGHT_TOP or relativePoint == FRAME_ALIGN_RIGHT or relativePoint == FRAME_ALIGN_RIGHT_BOTTOM) then
                pw = 1
            end
            if (relativePoint == FRAME_ALIGN_LEFT_TOP or relativePoint == FRAME_ALIGN_TOP or relativePoint == FRAME_ALIGN_RIGHT_TOP) then
                ph = 1
            elseif (relativePoint == FRAME_ALIGN_LEFT or relativePoint == FRAME_ALIGN_CENTER or relativePoint == FRAME_ALIGN_RIGHT) then
                ph = 0
            elseif (relativePoint == FRAME_ALIGN_LEFT_BOTTOM or relativePoint == FRAME_ALIGN_BOTTOM or relativePoint == FRAME_ALIGN_RIGHT_BOTTOM) then
                ph = -1
            end
            must(aw ~= nil and ah ~= nil and pw ~= nil and ph ~= nil)
            local offsetX = relative[4]
            local offsetY = relative[5]
            local parentX = anchorParent[1]
            local parentY = anchorParent[2]
            local parentW = anchorParent[3]
            local parentH = anchorParent[4]
            local anchorX
            local anchorY
            local anchorW = size[1]
            local anchorH = size[2]
            local pwHalf = parentW / 2
            local phHalf = parentH / 2
            local awHalf = anchorW / 2
            local ahHalf = anchorH / 2
            anchorX = offsetX + parentX + pw * pwHalf + aw * awHalf
            anchorY = offsetY + parentY + ph * phHalf + ah * ahHalf
            anchorX = math.min(anchorX, 0.8 - awHalf)
            anchorX = math.max(anchorX, awHalf)
            anchorY = math.min(anchorY, 0.6 - ahHalf)
            anchorY = math.max(anchorY, ahHalf)
            whichFrame:prop("anchor", { anchorX, anchorY, anchorW, anchorH })
        end
    end
    local lns = whichFrame:lowerNodes()
    if (isClass(lns, ArrayClass)) then
        lns:forEach(function(_, c)
            view.setAnchor(c)
        end)
    end
end

---@protected
---@param whichFrame Frame
---@param evt string|nil
---@return void
function view.frame2Mouse(whichFrame, evt, show, ...)
    local key, callFunc = datum.keyFunc(...)
    if (whichFrame == nil or evt == nil) then
        return
    end
    local mk = whichFrame:id() .. key
    local ban = (type(callFunc) ~= "function") or (false == show)
    if (ban) then
        if (evt == EVENT.Frame.LeftClick) then
            mouse.onLeftClick(mk, nil)
        elseif (evt == EVENT.Frame.LeftRelease) then
            mouse.onLeftRelease(mk, nil)
        elseif (evt == EVENT.Frame.RightClick) then
            mouse.onRightClick(mk, nil)
        elseif (evt == EVENT.Frame.RightRelease) then
            mouse.onRightRelease(mk, nil)
        elseif (evt == EVENT.Frame.Move) then
            mouse.onMove(mk, 1, nil)
        elseif (evt == EVENT.Frame.Enter) then
            mouse.onMove(mk .. '_in', 3, nil)
        elseif (evt == EVENT.Frame.Leave) then
            mouse.onMove(mk .. '_out', 2, nil)
        elseif (evt == EVENT.Frame.Wheel) then
            mouse.onWheel(mk, nil)
        end
    else
        if (evt == EVENT.Frame.LeftClick) then
            mouse.onLeftClick(mk, function(evtData)
                if (whichFrame:isInner() and whichFrame:checkTooltips()) then
                    event.trigger(whichFrame, EVENT.Frame.LeftClick, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                end
            end)
        elseif (evt == EVENT.Frame.LeftRelease) then
            mouse.onLeftRelease(mk, function(evtData)
                local status = whichFrame:isInner() and whichFrame:checkTooltips()
                event.trigger(whichFrame, EVENT.Frame.LeftRelease, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer, status = status })
            end)
        elseif (evt == EVENT.Frame.RightClick) then
            mouse.onRightClick(mk, function(evtData)
                if (whichFrame:isInner() and whichFrame:checkTooltips()) then
                    event.trigger(whichFrame, EVENT.Frame.RightClick, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                end
            end)
        elseif (evt == EVENT.Frame.RightRelease) then
            mouse.onRightRelease(mk, function(evtData)
                local status = whichFrame:isInner() and whichFrame:checkTooltips()
                event.trigger(whichFrame, EVENT.Frame.RightRelease, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer, status = status })
            end)
        elseif (evt == EVENT.Frame.Move) then
            mouse.onMove(mk, 1, function(evtData)
                if (whichFrame:isInner() and whichFrame:checkTooltips()) then
                    event.trigger(whichFrame, EVENT.Frame.Move, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                end
            end)
        elseif (evt == EVENT.Frame.Enter) then
            mouse.onMove(mk .. '_in', 3, function(evtData)
                local entering = whichFrame:prop("mec" .. key) or 0
                if (entering > 0) then
                    return
                end
                if (whichFrame:isInner() and whichFrame:checkTooltips()) then
                    whichFrame:prop("mec" .. key, 1)
                    event.trigger(whichFrame, EVENT.Frame.Enter, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                end
            end)
        elseif (evt == EVENT.Frame.Leave) then
            mouse.onMove(mk .. '_L', 2, function(evtData)
                local entering = whichFrame:prop("mec" .. key) or 0
                if (entering == 0) then
                    return
                end
                if (whichFrame:isBorder()) then
                    whichFrame:clear("mec" .. key)
                    event.trigger(whichFrame, EVENT.Frame.Leave, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                end
            end)
        elseif (evt == EVENT.Frame.Wheel) then
            mouse.onWheel(mk, function(evtData)
                if (whichFrame:isInner() and whichFrame:checkTooltips()) then
                    event.trigger(whichFrame, EVENT.Frame.Wheel, { triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer, delta = evtData.delta })
                end
            end)
        end
    end
end

---@param frame Frame
---@param enable boolean
---@return void
function view.esc(frame, enable)
    must(instanceof(frame, FrameClass))
    if (enable == true) then
        view._evtEsc:set(frame:id(), frame)
    else
        view._evtEsc:set(frame:id(), nil)
    end
end

--- 当游戏窗口大小异步改变
---@alias noteOnWindowResizeData fun(evtData:{triggerPlayer:Player):void
---@param key string
---@param callFunc noteOnWindowResizeData
---@return void
function view.onResize(key, callFunc)
    key = key or "default"
    if (type(callFunc) == "function") then
        view._evtResize:set(key, callFunc)
    else
        view._evtResize:set(key, nil)
    end
end