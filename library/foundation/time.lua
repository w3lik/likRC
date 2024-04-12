---@class time
time = time or {}
time._timeOfDay = {
    { evt = EVENT.Game.Dawn, time = 0, status = false },
    { evt = EVENT.Game.Day, time = 6, status = false },
    { evt = EVENT.Game.Noon, time = 12, status = false },
    { evt = EVENT.Game.Night, time = 18, status = false },
}
time._inc = time._inc or 0 --- 获取开始游戏后经过的总秒数
time._hour = time._hour or 0 --- 时
time._min = time._min or 0 --- 分
time._sec = time._sec or 0 --- 秒
time._msec = time._msec or 0 --- 毫秒
time._timeOfDayLast = time._timeOfDayLast or 0
---@type Array[]
time._kernel = time._kernel or {} --- 内核
for i = 0, BJ_MAX_PLAYERS, 1 do
    time._kernel[i] = {}
end

---@param t Timer
---@param remain number sec
---@private
function time.penetrate(t, remain)
    remain = remain or t:period()
    local i = math.ceil(time._inc + math.max(1, remain * 100))
    local aid
    if (t:prop("asyncId") ~= nil) then
        aid = t:prop("asyncId")
    else
        aid = async._idx
        t:prop("asyncId", aid)
    end
    ---@type Array[]
    local kl = time._kernel[aid]
    if (kl[i] == nil) then
        kl[i] = {}
    end
    t:prop("link", i)
    kl[i][t:id()] = t
end

--- 系统时钟
---@private
function time.clock()
    time._inc = time._inc + 1
    -- timer
    time._msec = time._msec + 10
    if (time._msec >= 1000) then
        time._msec = 0
        time._sec = time._sec + 1
        if (time._sec >= 60) then
            time._sec = 0
            time._min = time._min + 1
            if (time._min >= 60) then
                time._min = 0
                time._hour = time._hour + 1
            end
        end
        local timeOfDay = J.GetFloatGameState(GAME_STATE_TIME_OF_DAY)
        if (time._timeOfDayLast > timeOfDay) then
            time._timeOfDayLast = 0
            for _, v in ipairs(time._timeOfDay) do
                v.status = false
            end
        else
            for _, v in ipairs(time._timeOfDay) do
                if (v.status == false and timeOfDay >= v.time) then
                    v.status = true
                    event.trigger(Game(), v.evt, nil)
                end
            end
            time._timeOfDayLast = timeOfDay
        end
    end
    -- trigger
    local inc = time._inc
    for i = 0, BJ_MAX_PLAYERS, 1 do
        local kl = time._kernel[i]
        if (kl[inc] ~= nil) then
            local kdo = function()
                ---@param t Timer
                for k, t in pairx(kl[inc]) do
                    if (isClass(t, TimerClass)) then
                        J.Promise(t:propValue("callFunc"),
                            function()
                                destroy(t)
                            end,
                            function()
                                if (t:propValue("interval") == true) then
                                    if (t:propValue("link") ~= nil) then
                                        time.penetrate(t)
                                    end
                                else
                                    destroy(t)
                                end
                            end
                        , t)
                    end
                    kl[inc][k] = nil
                end
                kl[inc] = nil
            end
            if (i == 0) then
                kdo()
            else
                async.call(Player(i), kdo)
            end
        end
    end
end

--- 从内核中获取一个Timer对象
---@param interval boolean
---@param period number sec
---@param callFunc function
---@private
function time.periodic(interval, period, callFunc)
    local t = Timer(interval, period, callFunc)
    if (t ~= nil) then
        time.penetrate(t)
    end
    return t
end

--- 魔兽小时[0.00-24.00]
function time.ofDay(modify)
    if (type(modify) == "number") then
        J.SetFloatGameState(GAME_STATE_TIME_OF_DAY, modify)
    end
    return J.GetFloatGameState(GAME_STATE_TIME_OF_DAY)
end

--- 魔兽小时流逝速度[默认1.00]
function time.ofDayScale(modify)
    if (type(modify) == "number") then
        J.SetTimeOfDayScale(modify)
    end
    return J.GetTimeOfDayScale()
end

--- 是否夜晚
---@return boolean
function time.isNight()
    return (time.ofDay() <= 6.00 or time.ofDay() >= 18.00)
end

--- 是否白天
---@return boolean
function time.isDay()
    return (time.ofDay() > 6.00 and time.ofDay() < 18.00)
end

-- 设置一次性计时器
---@param period number
---@param callFunc fun(curTimer:Timer):void
---@return Timer
function time.setTimeout(period, callFunc)
    return time.periodic(false, period, callFunc)
end

--- 设置周期性计时器
---@param period number
---@param callFunc fun(curTimer:Timer):void
---@return Timer
function time.setInterval(period, callFunc)
    return time.periodic(true, period, callFunc)
end

--- 获取过去的时分秒
---@return string HH:ii:ss
function time.gone()
    local str = ""
    if (time._hour < 10) then
        str = str .. "0" .. time._hour
    else
        str = str .. time._hour
    end
    str = str .. ":"
    if (time._min < 10) then
        str = str .. "0" .. time._min
    else
        str = str .. time._min
    end
    str = str .. ":"
    if (time._sec < 10) then
        str = str .. "0" .. time._sec
    else
        str = str .. time._sec
    end
    return str
end

--- 获取服务器当前时间戳
--- * 此方法在本地不能准确获取当前时间
---@return number
function time.unix()
    return (japi.Map_GetGameStartTime() or 0) + time._sec
end

--- 获取服务器当前时间对象
--- * 此方法在本地不能准确获取当前时间，将从UNIX元秒开始(1970年)
---@param timestamp number
---@return table {Y:"年",m:"月",d:"日",H:"时",i:"分",s:"秒",w:"周[0-6]",W:"周[日-六]"}
function time.date(timestamp)
    timestamp = timestamp or time.unix()
    return math.date(timestamp)
end