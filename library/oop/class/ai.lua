---@class AIClass:Class
local class = Class(AIClass)

---@private
function class:construct(options)
    self:prop("key", options.key)
    self:prop("period", 10)
end

--- key
---@return string
function class:key()
    return self:prop("key")
end

--- 执行周期，默认10
--- 不会影响已经关连的单位，如需要修改单位的执行周期，需要先断重连
--- 小于0.5或不合法数据将使AI关连
---@param modify number|nil
---@return self|number|10
function class:period(modify)
    return self:prop("period", modify)
end

--- 执行回调
---@alias noteAICall fun(linkUnit:Unit):void
---@param modify nil|noteAICall
---@return self|noteAICall
function class:action(modify)
    return self:prop("action", modify)
end

--- 关联单位
--- 单位被关联后等于启用了此AI
---@param whichUnit Unit
---@return void
function class:link(whichUnit)
    must(isClass(whichUnit, UnitClass))
    local tk = "aiTimer" .. self:id()
    local t = whichUnit:prop(tk)
    if (isClass(t, TimerClass)) then
        return
    end
    local period = self:period()
    if (type(period) ~= "number" or period < 0.5) then
        return
    end
    t = time.setInterval(period, function(curTimer)
        if (isDestroy(whichUnit) or isDestroy(self)) then
            destroy(curTimer)
            return
        end
        if (whichUnit:isDead()) then
            return
        end
        local action = self:action()
        if (type(action) == "function") then
            action(whichUnit)
        end
    end)
    whichUnit:prop(tk, t)
    event.trigger(self, EVENT.AI.Link, { triggerAI = self, triggerUnit = whichUnit })
    event.trigger(whichUnit, EVENT.AI.Link, { triggerAI = self, triggerUnit = whichUnit })
    ---@param unlinkData noteOnAIUnlinkData
    whichUnit:onEvent(EVENT.AI.Unlink, tk, function(unlinkData)
        local u = unlinkData.triggerUnit
        u:onEvent(EVENT.AI.Unlink, tk, nil)
        u:clear(tk, true)
    end)
    ---@param destroyData noteOnAIDestructData
    self:onEvent(EVENT.Object.Destruct, tk, function(destroyData)
        if (isClass(whichUnit, UnitClass)) then
            local ai = destroyData.triggerObject
            event.trigger(ai, EVENT.AI.Unlink, { triggerAI = ai, triggerUnit = whichUnit })
            event.trigger(whichUnit, EVENT.AI.Unlink, { triggerAI = ai, triggerUnit = whichUnit })
        end
    end)
end

--- 断联单位
--- 单位被关联后等于关闭了此AI
---@param whichUnit Unit
---@return void
function class:unlink(whichUnit)
    must(isClass(whichUnit, UnitClass))
    event.trigger(self, EVENT.AI.Unlink, { triggerAI = self, triggerUnit = whichUnit })
    event.trigger(whichUnit, EVENT.AI.Unlink, { triggerAI = self, triggerUnit = whichUnit })
end
