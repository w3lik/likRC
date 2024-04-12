---@type fun(obj:Destructable,key:string,value:any)
local reset = function(obj, prev, key, value)
    if (prev == nil) then
        return
    end
    local dataCur = {
        modelId = obj:modelId(),
        position = obj:propData("position"),
        facing = obj:propData("facing"),
        modelScale = obj:propData("modelScale"),
        variation = obj:propData("variation"),
    }
    if (key and value) then
        dataCur[key] = value
    end
    J.RemoveDestructable(obj:handle())
    href(obj, J.CreateDestructableZ(J.C2I(dataCur.modelId), dataCur.position[1], dataCur.position[2], dataCur.position[3], dataCur.facing, dataCur.modelScale, dataCur.variation))
    J.SetDestructableInvulnerable(obj:handle(), true)
end

local expander = ClassExpander(CLASS_EXPANDS_MOD, DestructableClass)

---@param obj Destructable
expander["modelAlias"] = function(obj, prev)
    ---@type string
    local data = obj:propData("modelAlias")
    local id
    if (type(FRAMEWORK_DESTRUCTABLE[data]) == "string") then
        id = slk.n2i("　" .. data .. "　")
    else
        id = data
    end
    destructable.slk(id)
    obj:propChange("modelId", "std", id, false)
    reset(obj, prev)
end

---@param obj Destructable
expander["modelScale"] = function(obj, prev)
    reset(obj, prev, "modelScale", obj:propData("modelScale"))
end

---@param obj Destructable
expander["position"] = function(obj, prev)
    reset(obj, prev, "position", obj:propData("position"))
end

---@param obj Destructable
expander["facing"] = function(obj, prev)
    reset(obj, prev, "facing", obj:propData("facing"))
end

---@param obj Destructable
expander["occluderHeight"] = function(obj)
    J.SetDestructableOccluderHeight(obj:handle(), obj:propData("occluderHeight"))
end