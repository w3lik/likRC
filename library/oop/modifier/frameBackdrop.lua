local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameBackdropClass)

---@param obj FrameBackdrop
expander["texture"] = function(obj)
    japi.FrameSetTexture(obj:handle(), obj:propData("texture"), 0)
end