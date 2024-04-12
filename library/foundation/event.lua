--- 事件
event = event or {}
event._pool = event._pool or {}
event._reaction = event._reaction or {}
event._propChange = event._propChange or nil

--- 触发池
--- 使用一个handle，以不同的conditionAction累计计数
--- 分配触发到回调注册
--- 触发池的action是不会被同一个handle注册两次的，与on事件并不相同
---@param conditionFunc number
---@param regEvent function
---@return void
function event.pool(conditionFunc, regEvent)
    if (type(regEvent) ~= "function") then
        return
    end
    local id = J.GetHandleId(conditionFunc)
    -- 如果这个handle已经注册过此动作，则不重复注册
    local tgr = event._pool[id]
    if (tgr == nil) then
        tgr = J.CreateTrigger()
        J.handleRef(tgr)
        J.TriggerAddCondition(tgr, conditionFunc)
        event._pool[id] = tgr
    end
    regEvent(event._pool[id])
end

--- 捕捉反应
---@param evt string 事件类型
---@vararg any 可以填写一个function|或string,function 当拥有string参数时作为其key
---@return void
function event.reaction(evt, ...)
    local key, func = datum.keyFunc(...)
    if (evt == nil) then
        stack()
    end
    if (event._reaction[evt] == nil) then
        event._reaction[evt] = Array()
    end
    event._reaction[evt]:set(key, func)
end

---@param obj Object
---@param evt string 事件类型
---@param init boolean
---@return nil|table<string,Array>|Array
function event.data(obj, evt, init)
    if (obj == nil) then
        return
    end
    local oid = obj:id()
    if (oid == nil or oop._i2o[oid] == nil) then
        return
    end
    if (init == true) then
        if (oop._i2o[oid]._evt == nil) then
            oop._i2o[oid]._evt = {}
        end
        if (evt ~= nil and oop._i2o[oid]._evt[evt] == nil) then
            oop._i2o[oid]._evt[evt] = Array()
        end
    end
    if (evt == nil) then
        return oop._i2o[oid]._evt
    else
        if (type(oop._i2o[oid]._evt) == "table") then
            return oop._i2o[oid]._evt[evt]
        end
    end
end

--- 注销事件|事件集
---@param obj Object
---@param evt string 事件类型
---@param key string|nil
---@return void
function event.unregister(obj, evt, key)
    if (obj == nil or evt == nil) then
        return
    end
    local data = event.data(obj)
    if (data == nil) then
        return
    end
    if (data[evt] == nil) then
        return
    end
    if (key == nil) then
        data[evt] = nil
    else
        data[evt]:set(key, nil)
    end
end

--- 注册事件
--- 每种类型的事件默认只会被注册一次，重复会覆盖
--- 这是根据 key 值决定的，key 默认就是default，需要的时候可以自定义
---@param obj Object
---@param evt string 事件类型字符
---@vararg any 可以填写一个function|或string,function 当拥有string参数时作为其key
---@return void
function event.register(obj, evt, ...)
    if (obj == nil) then
        return
    end
    local key, callFunc = datum.keyFunc(...)
    if (key ~= nil) then
        if (callFunc == nil) then
            event.unregister(obj, evt, key)
        elseif (type(callFunc) == "function") then
            local d = event.data(obj, evt, true)
            d:set(key, callFunc)
        end
    end
end

--- 拥有事件
---@param obj Object|string
---@param evt string 事件类型
---@param key string|nil 特定键值判断
---@return boolean
function event.has(obj, evt, key)
    local data = event.data(obj, evt)
    local res = isClass(data, ArrayClass) and data:count() > 0
    if (res == true and type(key) == "string") then
        res = (data:get(key) ~= nil)
    end
    return res
end

--- 触发事件
---@param obj Object
---@param evt string 事件类型
---@param triggerData table
function event.trigger(obj, evt, triggerData)
    if (obj == nil or evt == nil) then
        return
    end
    -- 数据
    triggerData = triggerData or {}
    -- 反应
    if (isClass(event._reaction[evt], ArrayClass)) then
        event._reaction[evt]:forEach(function(_, val)
            if (type(val) == "function") then
                J.Promise(val, nil, nil, triggerData)
            end
        end)
    end
    -- 判断事件注册执行与否
    local reg = event.data(obj, evt)
    if (isClass(reg, ArrayClass)) then
        if (reg:count() > 0) then
            reg:forEach(function(_, callFunc)
                J.Promise(callFunc, nil, nil, triggerData)
            end)
        end
    end
end

--- 参变判定配置
--- 可配置nil、any或字符串表[string]boolean
---@param keys nil|"any"|table<string,boolean>
---@return void
function event.confPropChange(keys)
    if (keys == "any" or type(keys) == "table") then
        event._propChange = keys
    else
        event._propChange = nil
    end
end

--- 参变判定检查
---@param key string
---@return boolean
function event.checkPropChange(key)
    return event._propChange == nil or event._propChange == "any" or (type(event._propChange) == "table" and event._propChange[key] == true)
end