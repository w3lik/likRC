local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameButtonClass)

---@param obj FrameButton
expander["texture"] = function(obj)
    japi.FrameSetTexture(obj:handle(), obj:propData("texture"), 0)
end