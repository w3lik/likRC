local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameBackdropTileClass)

---@param obj FrameBackdropTile
expander["texture"] = function(obj)
    japi.FrameSetTexture(obj:handle(), obj:propData("texture"), 1)
end