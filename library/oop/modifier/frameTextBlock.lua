local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameTextBlockClass)

---@param obj FrameTextBlockClass
expander["block"] = function(obj)
    ---@type boolean
    local data = obj:propData("block")
    if (data == true) then
        Group():insert(obj)
    else
        Group():remove(obj)
    end
    japi.FrameShow(obj:handle(), data, 0)
end