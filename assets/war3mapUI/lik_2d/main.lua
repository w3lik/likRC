--[[
    2D游戏演示
    Author: hunzsig
]]

local kit = "lik_2d"

---@class UI_Lik2d:UIKit
local ui = UIKit(kit)

ui:onSetup(function(this)
    local stage = this:stage()
    stage.stand = {
        "stand\\01", "stand\\02", "stand\\03", "stand\\04", "stand\\05", "stand\\06",
        "stand\\07", "stand\\08", "stand\\09", "stand\\10", "stand\\11", "stand\\12", "stand\\13"
    }
    stage.run = { "run\\01", "run\\02", "run\\03", "run\\04", "run\\05", "run\\06", "run\\07", "run\\08" }
    stage.attack = {
        "attack\\01", "attack\\02", "attack\\03", "attack\\04", "attack\\05", "attack\\06",
        "attack\\07", "attack\\08", "attack\\09", "attack\\10", "attack\\11", "attack\\12",
        "attack\\13", "attack\\14", "attack\\15", "attack\\16", "attack\\17", "attack\\18", "attack\\19",
    }

    stage.man = FrameAnimate(kit .. "->man", FrameGameUI)
        :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
        :size(0.2, 0.25)

    stage.man:motion(stage.stand):duration(2):play(-1, true)

    keyboard.onRelease(KEYBOARD["T"], "lik_2d", function()
        stage.man:motion(stage.stand):duration(2):play(-1)
    end)
    keyboard.onRelease(KEYBOARD["Y"], "lik_2d", function()
        stage.man:motion(stage.run):duration(0.5):play(-1, true)
    end)
    keyboard.onRelease(KEYBOARD["U"], "lik_2d", function()
        stage.man:motion(stage.attack):duration(0.3):play(1, true)
    end)
end)


