local expander = ClassExpander(CLASS_EXPANDS_MOD, FrameTextClass)

---@param obj FrameText
expander["textAlign"] = function(obj)
    japi.FrameSetTextAlignment(obj:handle(), obj:propData("textAlign"))
end

---@param obj FrameText
expander["textColor"] = function(obj)
    japi.FrameSetTextColor(obj:handle(), obj:propData("textColor"))
end

---@param obj FrameText
expander["textSizeLimit"] = function(obj)
    japi.FrameSetTextSizeLimit(obj:handle(), obj:propData("textSizeLimit"))
end

---@param obj FrameText
expander["fontSize"] = function(obj)
    japi.FrameSetFont(obj:handle(), 'fonts.ttf', obj:propData("fontSize") * 0.001, 0)
end

---@param obj FrameText
expander["text"] = function(obj)
    japi.FrameSetText(obj:handle(), obj:propData("text"))
end