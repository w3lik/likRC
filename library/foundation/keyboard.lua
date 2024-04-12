---@class keyboard
keyboard = keyboard or {}

-- 键盘事件
---@private
---@type table<string,Array>
keyboard._evt = keyboard._evt or {}

-- 键盘初始化
---@private
keyboard._init = function()
    keyboard._evt["onPress"] = {}
    keyboard._evt["onRelease"] = {}
    local call = function(kind)
        if (true ~= japi.IsWindowActive()) then
            return
        end
        local triggerKey = japi.GetTriggerKey()
        if (triggerKey ~= KEYBOARD["Esc"] and triggerKey ~= KEYBOARD["Enter"] and japi.IsTyping()) then
            return
        end
        local arr = keyboard._evt[kind][triggerKey]
        if (isClass(arr, ArrayClass) == false) then
            return
        end
        if (arr:count() > 0) then
            local triggerPlayer = Player(1 + J.GetPlayerId(japi.GetTriggerKeyPlayer()))
            async.call(triggerPlayer, function()
                arr:forEach(function(_, v)
                    J.Promise(v, nil, nil, { triggerPlayer = triggerPlayer, triggerKey = triggerKey })
                end)
            end)
        end
    end
    for _, v in pairx(KEYBOARD) do
        keyboard._evt["onPress"][v] = Array()
        keyboard._evt["onRelease"][v] = Array()
        J.Japi["DzTriggerRegisterKeyEventByCode"](nil, v, GAME_KEY_ACTION_PRESS, false, function() call("onPress") end)
        J.Japi["DzTriggerRegisterKeyEventByCode"](nil, v, GAME_KEY_ACTION_RELEASE, false, function() call("onRelease") end)
    end
    if (type(keyboard._evt["init"]) == "table") then
        for _, v in ipairs(keyboard._evt["init"]) do
            keyboard.triggerRegisterEvent(table.unpack(v))
        end
        keyboard._evt["init"] = nil
    end
end

--- 按下键盘
---@param ketString string
---@return void
function keyboard.press(ketString)
    J.ForceUIKey(ketString)
end

--- 键盘正在按下
---@param ketString string
---@return boolean
function keyboard.isPressing(ketString)
    return japi.IsKeyDown(ketString)
end

--- 当键盘触发事件
---@protected
---@alias noteOnKeyboardData fun(evtData:{triggerPlayer:Player,triggerKey:number}):void
---@param name string
---@param keyboardCode number
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.triggerRegisterEvent(name, keyboardCode, key, callFunc)
    if (Game():isStarted()) then
        key = key or "default"
        if (type(callFunc) == "function") then
            keyboard._evt[name][keyboardCode]:set(key, callFunc)
        else
            keyboard._evt[name][keyboardCode]:set(key, nil)
        end
    else
        if (keyboard._evt["init"] == nil) then
            keyboard._evt["init"] = {}
        end
        table.insert(keyboard._evt["init"], { name, keyboardCode, key, callFunc })
    end
end

--- 当键盘异步点击
---@param keyboardCode number
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.onPress(keyboardCode, key, callFunc)
    keyboard.triggerRegisterEvent("onPress", keyboardCode, key, callFunc)
end

--- 当键盘异步释放
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.onRelease(keyboardCode, key, callFunc)
    keyboard.triggerRegisterEvent("onRelease", keyboardCode, key, callFunc)
end