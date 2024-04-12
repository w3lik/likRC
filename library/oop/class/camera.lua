---@class CameraClass:Class
local class = Class(CameraClass)

---@private
function class:construct()
    self:superposition("shake", 0) -- 摇晃态
    self:superposition("quake", 0) -- 震动态
    local lt = {}
    for i = 0, BJ_MAX_PLAYERS, 1 do
        local k = tostring(i)
        lt[k] = J.CreateUnit(PlayerPassive:handle(), FRAMEWORK_ID["unit_token"], 0, 0, 270)
        J.handleRef(lt[k])
    end
    self:prop("lockTokens", lt)
end

--- 当前镜头X坐标
---@return number
function class:x()
    return J.GetCameraTargetPositionX()
end

--- 当前镜头Y坐标
---@return number
function class:y()
    return J.GetCameraTargetPositionY()
end

--- 当前镜头Z坐标
---@return number
function class:z()
    return J.GetCameraTargetPositionZ()
end

--- 是否在摇晃
---@return boolean
function class:isShaking()
    return self:superposition("shake") > 0
end

--- 是否在震动
---@return boolean
function class:isQuaking()
    return self:superposition("quake") > 0
end

--- 重置镜头
---@param duration number
---@return void
function class:reset(duration)
    J.CameraSetSourceNoise(0, 0)
    J.CameraSetTargetNoise(0, 0)
    J.ResetToGameCamera(duration)
end

--- 设置空格坐标
--- 空格设置魔兽最大记录8个队列位置，不定死坐标则按空格时轮循跳转
--- 如要完全定死一个坐标，需要强行覆盖8次
---@param x number
---@param y number
---@param unique boolean 是否定死坐标记录,默认不锁死
---@return void
function class:spacePosition(x, y, unique)
    if (type(unique) ~= "boolean") then
        unique = false
    end
    if (unique) then
        for _ = 1, 8, 1 do
            J.SetCameraQuickPosition(x, y)
        end
    else
        J.SetCameraQuickPosition(x, y)
    end
end

--- 移动到XY
---@param x number
---@param y number
---@param duration number
---@return void
function class:to(x, y, duration)
    duration = duration or 0
    J.PanCameraToTimed(x, y, duration)
end

--- 远景截断距离
---@param modify number|nil
---@return self|number
function class:farZ(modify)
    local v = J.GetCameraField(CAMERA_FIELD_FARZ)
    if (modify) then
        self:propChange("farZ", "std", v, false)
        return self:prop("farZ", modify)
    end
    return v
end

--- Z轴偏移（高度偏移）
---@param modify number|nil
---@return self|number
function class:zOffset(modify)
    local v = J.GetCameraField(CAMERA_FIELD_ZOFFSET)
    if (modify) then
        self:propChange("zOffset", "std", v, false)
        return self:prop("zOffset", modify)
    end
    return v
end

--- 观察角度
---@param modify number|nil
---@return self|number
function class:fov(modify)
    local v = J.GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
    if (modify) then
        self:propChange("fov", "std", v, false)
        return self:prop("fov", modify)
    end
    return math._r2d * v
end

--- X轴翻转角度
---@param modify number|nil
---@return self|number
function class:xTra(modify)
    local v = J.GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)
    if (modify) then
        self:propChange("xTra", "std", v, false)
        return self:prop("xTra", modify)
    end
    return math._r2d * v
end

--- Y轴翻转角度
---@param modify number|nil
---@return self|number
function class:yTra(modify)
    local v = J.GetCameraField(CAMERA_FIELD_ROLL)
    if (modify) then
        self:propChange("yTra", "std", v, false)
        return self:prop("yTra", modify)
    end
    return math._r2d * v
end

--- Z轴翻转角度
---@param modify number|nil
---@return self|number
function class:zTra(modify)
    local v = J.GetCameraField(CAMERA_FIELD_ROTATION)
    if (modify) then
        self:propChange("zTra", "std", v, false)
        return self:prop("zTra", modify)
    end
    return math._r2d * v
end

--- 镜头距离
---@param modify number|nil
---@return self|number
function class:distance(modify)
    local v = math.floor(J.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE))
    if (modify) then
        self:propChange("distance", "std", v, false)
        return self:prop("distance", modify)
    end
    return v
end

--- 锁定镜头跟踪某单位
---@param whichUnit Unit
---@return self
function class:follow(whichUnit)
    return self:prop("follow", whichUnit)
end

--- 锁定镜头锁定某坐标
---@param x number
---@param y number
---@return void
function class:lock(x, y)
    if (type(x) == "number" and type(y) == "number") then
        local lt = self:prop("lockTokens")
        if sync.is() then
            local tu = lt['0']
            J.SetUnitPosition(tu, x, y)
            J.SetCameraTargetController(tu, 0, 0, false)
        else
            sync.send("G_GAME_SYNC", { "camera_lock", async._idx, x, y })
        end
    end
end

--- 解锁镜头锁定坐标
---@return void
function class:unlock()
    J.ResetToGameCamera(0)
end

--- 摇晃镜头
---@param magnitude number 幅度
---@param velocity number 速率
---@param duration number 持续时间
---@return void
function class:shake(magnitude, velocity, duration)
    magnitude = magnitude or 0
    velocity = velocity or 0
    duration = math.trunc(duration or 0, 2)
    if (magnitude <= 0 or velocity <= 0 or duration <= 0) then
        return
    end
    self:superposition("shake", "+=1")
    J.CameraSetTargetNoise(magnitude, velocity)
    time.setTimeout(duration, function()
        self:superposition("shake", "-=1")
        if (false == self:isShaking()) then
            J.CameraSetTargetNoise(0, 0)
        end
    end)
end

--- 震动镜头
---@param magnitude number 幅度
---@param duration number 持续时间
---@return self
function class:quake(magnitude, duration)
    magnitude = magnitude or 0
    duration = math.trunc(duration or 0, 2)
    if (magnitude <= 0 or duration <= 0) then
        return
    end
    local richter = magnitude
    if (richter > 5) then
        richter = 5
    end
    if (richter < 2) then
        richter = 2
    end
    self:superposition("quake", "+=1")
    J.CameraSetTargetNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
    J.CameraSetSourceNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
    time.setTimeout(duration, function()
        self:superposition("quake", "-=1")
        if (false == self:isQuaking()) then
            J.CameraSetSourceNoise(0, 0)
            if (false == self:isShaking()) then
                J.CameraSetTargetNoise(0, 0)
            end
        end
    end)
end
