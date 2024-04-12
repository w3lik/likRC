---@class FrameDragClass:FrameBackdropClass
local class = Class(FrameDragClass):extend(FrameBackdropClass)

---@private
function class:construct()
    if (DEBUGGING) then
        self:texture(TEAM_COLOR_BLP_PINK)
    end
    self:prop("block", true)
    self:onEvent(EVENT.Frame.LeftClick, function()
        if (Cursor():dragging() ~= true) then
            local a = self:anchor()
            local rx, ry = japi.MouseRX(), japi.MouseRY()
            local ofx = rx - a[1]
            local ofy = ry - a[2]
            Cursor():dragging(true)
            japi.FrameSetAlpha(self:handle(), self:alpha() * 0.8)
            event.trigger(self, EVENT.Frame.DragStart, { triggerFrame = self, triggerPlayer = PlayerLocal() })
            mouse.onMove(self:id(), 1, function()
                if (type(ofx) == "number" and type(ofy) == "number") then
                    local x = japi.MouseRX() - ofx
                    local y = japi.MouseRY() - ofy
                    local pad = self:padding()
                    x = math.max(x, a[3] / 2 + pad[4])
                    x = math.min(x, 0.8 - a[3] / 2 - pad[2])
                    y = math.max(y, a[4] / 2 + pad[3])
                    y = math.min(y, 0.6 - a[4] / 2 - pad[1])
                    japi.FrameClearAllPoints(self:handle())
                    japi.FrameSetPoint(self:handle(), FRAME_ALIGN_CENTER, FrameGameUI:handle(), FRAME_ALIGN_LEFT_BOTTOM, x, y)
                    self:prop("mx", x)
                    self:prop("my", y)
                end
            end)
        end
    end)
    self:onEvent(EVENT.Frame.LeftRelease, function()
        if (Cursor():dragging() == true) then
            Cursor():dragging(false)
            local x = self:prop("mx")
            local y = self:prop("my")
            if (self:adaptive() == true) then
                x = japi.FrameDisAdaptive(x)
            end
            japi.FrameSetAlpha(self:handle(), self:alpha())
            self:relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, x, y)
            self:clear("mx")
            self:clear("my")
            mouse.onMove(self:id(), 1, nil)
            event.trigger(self, EVENT.Frame.DragStop, { triggerFrame = self, triggerPlayer = PlayerLocal() })
        end
    end)
end

---@private
function class:destruct()
    mouse.onMove(self:id(), 1, nil)
end

--- 填充空间
--- 影响移动的极限
---@param top number|nil
---@param right number|nil
---@param bottom number|nil
---@param left number|nil
---@return self|number[]
function class:padding(top, right, bottom, left)
    local modify
    if (type(top) == "number" or type(right) == "number" and type(bottom) == "number" and type(top) == "left") then
        modify = { top or 0, right or 0, bottom or 0, left or 0 }
    end
    return self:prop("padding", modify)
end