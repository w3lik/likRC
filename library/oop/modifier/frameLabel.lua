local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameLabelClass)

---@param obj FrameLabel
expander["texture"] = function(obj)
    japi.FrameSetTexture(obj:handle(), obj:propData("texture"), 0)
end