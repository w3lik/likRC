---@class DestructableClass:Class
local class = Class(DestructableClass)

---@private
---@param options {id:string}
function class:construct(options)
    local dSlk = destructable.slk(options.id)
    local variationQty = math.floor(tonumber(dSlk.numVar) or 1)
    options.x = options.x or 0
    options.y = options.y or 0
    options.z = options.z or 0
    options.facing = options.facing or math.rand(0, 360)
    options.modelScale = options.modelScale or (math.rand(7, 11) * 0.1)
    options.variation = options.variation or 0
    href(self, J.CreateDestructableZ(J.C2I(options.id), options.x, options.y, options.z, options.facing, options.modelScale, options.variation))
    J.SetDestructableInvulnerable(self:handle(), true)
    self:propChange("modelId", "std", options.id, false)
    self:propChange("modelAlias", "std", options.modelAlias, false)
    self:propChange("variationQty", "std", variationQty, false)
    self:propChange("position", "std", { options.x, options.y, options.z }, false)
    self:propChange("facing", "std", options.facing, false)
    self:propChange("modelScale", "std", options.modelScale, false)
    self:propChange("variation", "std", options.variation, false)
    self:propChange("occluderHeight", "std", math.trunc(dSlk.occH or 0.00, 2), false) -- 闭塞高度
    Group():insert(self)
end

---@private
function class:destruct()
    Group():remove(self)
end

--- handle
---@return number
function class:handle()
    return self._handle
end

--- 获得X坐标
---@return number
function class:x()
    return self:prop("position")[1]
end

--- 获得Y坐标
---@return number
function class:y()
    return self:prop("position")[2]
end

--- 获得Z坐标
---@return number
function class:z()
    return self:prop("position")[3]
end

---@protected
---@return number
function class:modelId()
    return self:prop("modelId")
end

---@protected
---@param modify string|nil
---@return self|string
function class:modelAlias(modify)
    return self:prop("modelAlias", modify)
end

--- 缩放
---@param modify number|nil
---@return self|number
function class:modelScale(modify)
    return self:prop("modelScale", modify)
end

--- 面向角度
---@param modify number|nil
---@return self|number
function class:facing(modify)
    return self:prop("facing", modify)
end

--- 板式
---@param modify number|nil
---@return self|number
function class:variation(modify)
    return self:prop("variation", modify)
end

--- 闭塞高度
---@param modify number|nil
---@return self|number
function class:occluderHeight(modify)
    return self:prop("occluderHeight", modify)
end

--- 名称
---@return string
function class:name()
    return J.GetDestructableName(self:handle())
end

--- 移动到XYZ
---@param x number
---@param y number
---@param z number
---@return void
function class:position(x, y, z)
    if (x and y and z) then
        local p = self:prop("position")
        local modify = { x or p[1], y or p[2], z or p[3] }
        self:prop("position", modify)
    end
end

--- 显示
---@return void
function class:show()
    J.ShowDestructable(self:handle(), true)
end

--- 隐藏
---@return void
function class:hide()
    J.ShowDestructable(self:handle(), false)
end

--- 杀死
---@return void
function class:kill()
    destructable.kill(self:handle())
end

--- 复活
---@return void
function class:reborn()
    destructable.reborn(self:handle(), true)
end