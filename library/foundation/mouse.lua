---@class mouse
mouse = mouse or {}

-- 鼠标事件
---@private
---@type table<string,Array>
mouse._evt = mouse._evt or {}

-- 鼠标初始化
---@private
mouse._init = function()
    mouse._evt["onLeftClick"] = Array()
    mouse._evt["onLeftRelease"] = Array()
    mouse._evt["onRightClick"] = Array()
    mouse._evt["onRightRelease"] = Array()
    mouse._evt["onWheel"] = Array()
    mouse._evt["onMove"] = { Array(), Array(), Array() }
    local call = function(arr, extra)
        if (true ~= japi.IsWindowActive()) then
            return
        end
        if (arr:count() > 0) then
            local data = { triggerPlayer = Player(1 + J.GetPlayerId(japi.GetTriggerKeyPlayer())) }
            if (extra) then
                for _, e in ipairs(extra) do
                    data[e[1]] = e[2]
                end
            end
            async.call(data.triggerPlayer, function()
                arr:backEach(function(_, v)
                    J.Promise(v, nil, nil, data)
                end)
            end)
        end
    end
    J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_LEFT, 1, false, function() call(mouse._evt["onLeftClick"]) end)
    J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_LEFT, 0, false, function() call(mouse._evt["onLeftRelease"]) end)
    J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_RIGHT, 1, false, function() call(mouse._evt["onRightClick"]) end)
    J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_RIGHT, 0, false, function() call(mouse._evt["onRightRelease"]) end)
    J.Japi["DzTriggerRegisterMouseWheelEventByCode"](nil, false, function() call(mouse._evt["onWheel"], { "delta", japi.GetWheelDelta() }) end)
    J.Japi["DzTriggerRegisterMouseMoveEventByCode"](nil, false, function() for i = 1, 3 do call(mouse._evt["onMove"][i]) end end)
    if (type(mouse._evt["init"]) == "table") then
        for _, v in ipairs(mouse._evt["init"]) do
            mouse.triggerRegisterEvent(table.unpack(v))
        end
        mouse._evt["init"] = nil
    end
end

--- 设置鼠标坐标
---@param x number
---@param y number
---@return void
function mouse.position(x, y)
    japi.SetMousePos(x, y)
end

--- 绑定鼠标按击事件
---@private
---@alias noteOnMouseGameData fun(evtData:{triggerPlayer:Player):void
---@param name string
---@param key string
---@param priority string|nil
---@param callFunc noteOnMouseGameData
---@return void
function mouse.triggerRegisterEvent(name, key, priority, callFunc)
    if (Game():isStarted()) then
        key = key or "default"
        local evt = mouse._evt[name]
        if (priority) then
            evt = evt[priority]
        end
        if (type(callFunc) == "function") then
            evt:set(key, callFunc)
        else
            evt:set(key, nil)
        end
    else
        if (mouse._evt["init"] == nil) then
            mouse._evt["init"] = {}
        end
        table.insert(mouse._evt["init"], { name, key, priority, callFunc })
    end
end

--- 当鼠标左键点击
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onLeftClick(key, callFunc)
    mouse.triggerRegisterEvent("onLeftClick", key, nil, callFunc)
end

--- 当鼠标左键释放
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onLeftRelease(key, callFunc)
    mouse.triggerRegisterEvent("onLeftRelease", key, nil, callFunc)
end

--- 当鼠标右键点击
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onRightClick(key, callFunc)
    mouse.triggerRegisterEvent("onRightClick", key, nil, callFunc)
end

--- 当鼠标右键释放
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onRightRelease(key, callFunc)
    mouse.triggerRegisterEvent("onRightRelease", key, nil, callFunc)
end

--- 当鼠标滚轮
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onWheel(key, callFunc)
    mouse.triggerRegisterEvent("onWheel", key, nil, callFunc)
end

--- 当鼠标移动
---@param key string
---@param priority 1|2|3 优先级，默认3
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onMove(key, priority, callFunc)
    mouse.triggerRegisterEvent("onMove", key, priority, callFunc)
end