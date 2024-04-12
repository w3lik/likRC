local expander = ClassExpander(CLASS_EXPANDS_MOD, CameraClass)

---@param obj Camera
expander["farZ"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_FARZ, obj:propData("farZ"), 0)
end

---@param obj Camera
expander["zOffset"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_ZOFFSET, obj:propData("zOffset"), 0)
end

---@param obj Camera
expander["fov"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, obj:propData("fov"), 0)
end

---@param obj Camera
---@param data number
expander["xTra"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, obj:propData("xTra"), 0)
end

---@param obj Camera
---@param data number
expander["yTra"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_ROLL, obj:propData("yTra"), 0)
end

---@param obj Camera
expander["zTra"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_ROTATION, obj:propData("zTra"), 0)
end

---@param obj Camera
expander["distance"] = function(obj)
    J.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, obj:propData("distance"), 0)
end

---@param obj Camera
expander["follow"] = function(obj)
    ---@type Unit
    local data = obj:propData("follow")
    J.SetCameraTargetController(data:handle(), 0, 0, false)
end