--[[
    动画
    Author: hunzsig
]]

local kit = "lik_animate"

---@class UI_LikAnimate:UIKit
local ui = UIKit(kit)

ui:onSetup(function(this)
    local stage = this:stage()
    stage.main = FrameAnimate(kit .. "->an1", FrameGameUI)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
        :size(0.048, 0.06)
        :duration(1)
        :halt(0)
        :motion({
        "motion\\01",
        "motion\\02",
        "motion\\03",
        "motion\\04",
        "motion\\05",
        "motion\\06",
        "motion\\07",
        "motion\\08",
        "motion\\09",
        "motion\\10",
    })
    stage.main:play(-1)
end)
