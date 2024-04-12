local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameAnimateClass)

---@param obj FrameAnimate
expander["texture"] = function(obj)
    japi.FrameSetTexture(obj:handle(), obj:propData("texture"), 0)
end