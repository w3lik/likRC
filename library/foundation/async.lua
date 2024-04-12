---@class async
async = async or {}

---@private
async._idx = async._idx or 0

---@private
async._rPool = async._rPool or { i = {}, d = {} }

--- 是否异步
function async.is()
    return async._idx > 0
end

--- 限制必须异步
function async.must()
    must(async.is(), "asyncCheck")
end

--- 异步调用，使用此方法后回调强制异步
---@param asyncPlayer Player
---@param callFunc function
function async.call(asyncPlayer, callFunc)
    if (asyncPlayer:handle() == J.Common["GetLocalPlayer"]()) then
        local aid = async._idx
        async._idx = asyncPlayer:index() -- 异步的
        J.Promise(callFunc)
        async._idx = aid -- 异步的
    end
end

--- 异步随机
--- 此方法只能写于异步区
--- 当范围数据池未重新打包建立时只会返回固定值
---@param min number
---@param max number
---@return number integer
function async.rand(min, max)
    min = math.ceil(min)
    max = math.ceil(max)
    if (min == max) then
        return min
    end
    must(async._idx > 0)
    if (min > max) then
        min, max = max, min
    end
    local m = min .. '_' .. max
    local d = async._rPool.d[async._idx][m]
    if (d == nil) then
        return min
    end
    local i = async._rPool.i[async._idx][m]
    if (i >= #d) then
        i = 0
    end
    i = i + 1
    async._rPool.i[async._idx][m] = i
    return d[i]
end