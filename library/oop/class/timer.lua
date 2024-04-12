---@class TimerClass:Class
local class = Class(TimerClass)

---@private
function class:construct(options)
    self:prop("interval", options.interval)
    self:prop("period", options.period)
    self:prop("callFunc", options.callFunc)
    self:prop("link", 0)
end

---@private
function class:destruct()
    local l = self:prop("link")
    self:clear("link")
    if (l ~= nil and l > time._inc) then
        local kl = self:kernel()
        local id = self:id()
        if (kl[l] ~= nil and kl[l][id] ~= nil) then
            kl[l][id] = nil
        end
    end
end

---@private
function class:kernel()
    local aid
    local asyncId = self:prop("asyncId")
    if (asyncId == 0) then
        aid = asyncId
    else
        aid = async._idx
        must(aid == asyncId)
    end
    return time._kernel[aid]
end

--- 循环
---@param modify boolean|nil
---@return self|boolean
function class:interval(modify)
    return self:prop("interval", modify)
end

--- 剩余时间
---@param variety number|string|nil
---@return number
function class:remain(variety)
    local remain = self:prop("pause") or -1
    local l = self:prop("link") or 0
    if (remain == -1) then
        if (l > 0) then
            remain = (l - time._inc) / 100
        end
    end
    if (variety) then
        remain = math.cale(variety, remain)
        local kl = self:kernel()
        local id = self:id()
        if (kl[l] ~= nil and kl[l][id] ~= nil) then
            kl[l][id] = nil
            time.penetrate(self, math.min(self:prop("period"), math.max(0, remain)))
        end
    end
    return remain
end

--- 周期时间
---@param modify number|nil
---@return number
function class:period(modify)
    if (modify) then
        self:prop("period", modify)
        local l = self:prop("link")
        if (l > 0) then
            local p = self:prop("period")
            if (self:remain() > p) then
                local kl = self:kernel()
                kl[l][self:id()] = nil
                time.penetrate(self, p)
            end
        end
    end
    return self:prop("period") or -1
end

--- 已逝时间（周期时间-剩余时间）
---@return number
function class:elapsed()
    return math.max(0, self:period() - self:remain())
end

--- 暂停计时器
---@return void
function class:pause()
    local l = self:prop("link")
    if (l > time._inc) then
        local kl = self:kernel()
        kl[l][self:id()] = nil
    end
    self:prop("pause", (l - time._inc) / 100)
    self:clear("link")
end

--- 恢复计时器
---@return void
function class:resume()
    if (self:prop("pause") ~= nil) then
        time.penetrate(self, self:prop("pause"))
        self:clear("pause")
    end
end