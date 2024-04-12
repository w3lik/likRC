---@class LightningClass:Class
local class = Class(LightningClass)

---@private
function class:construct(options)
    self:propChange("lightningType", "std", options.lightningType, false)
    self:propChange("point", "std", { options.x1, options.y1, options.z1, options.x2, options.y2, options.z2 }, false)
    self:propChange("rgba", "std", { 255, 255, 255, 255 }, false)
    self._handle = J.AddLightningEx(options.lightningType.value, false, options.x1, options.y1, options.z1, options.x2, options.y2, options.z2)
    Effect(options.lightningType.effect, options.x2, options.y2, options.z2, 0.25)
    self:prop("duration", options.duration)
end

---@private
function class:destruct()
    self:clear("chainTimer", true)
    self:clear("durationTimer", true)
    if (type(self._handle) == "number") then
        J.DestroyLightning(self._handle)
    end
end

--- key
---@return self|number
function class:handle()
    return self._handle
end

--- 闪电类型
---@param modify table LIGHTNING_TYPE
---@return self|table
function class:lightningType(modify)
    return self:prop("lightningType", modify)
end

--- 起终坐标
---@param x1 number|nil
---@param y1 number|nil
---@param z1 number|nil
---@param x2 number|nil
---@param y2 number|nil
---@param z2 number|nil
---@return self|number[]
function class:point(x1, y1, z1, x2, y2, z2)
    local modify
    if (type(x1) == "number" and type(y1) == "number" and type(z1) == "number" and
        type(x2) == "number" and type(y2) == "number" and type(z2) == "number") then
        modify = { x1, y1, z1, x2, y2, z2 }
    end
    return self:prop("point", modify)
end

--- 设置链条颜色
---@param red number 红0-255
---@param green number 绿0-255
---@param blue number 蓝0-255
---@param alpha number 透明度0-255
---@param duration number 持续时间 -1无限
---@return self|Array
function class:rgba(red, green, blue, alpha, duration)
    if (type(red) == "number" and type(green) == "number" and type(blue) == "number" and type(alpha) == "number") then
        return self:prop("rgba", { red, green, blue, alpha }, duration)
    end
    return self:prop("rgba")
end

--- 持续时间
---@param modify number
---@return self|number
function class:duration(modify)
    return self:prop("duration", modify)
end

--- 关连两个单位
--- 使用此方法后当两单位不满足条件将自动销毁
---@param sourceUnit Unit
---@param targetUnit Unit
---@return void
function class:chain(sourceUnit, targetUnit)
    must(isClass(sourceUnit, UnitClass))
    must(isClass(targetUnit, UnitClass))
    self:prop("chainTimer", time.setInterval(0.1, function()
        if (sourceUnit:isDead() or targetUnit:isDead()) then
            self:clear("chainTimer", true)
            destroy(self)
            return
        end
        self:point(sourceUnit:x(), sourceUnit:y(), sourceUnit:h(), targetUnit:x(), targetUnit:y(), targetUnit:h())
    end))
end