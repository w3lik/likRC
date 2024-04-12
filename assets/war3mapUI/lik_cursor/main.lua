--[[
    玩家鼠标指针
    Author: hunzsig
]]

local kit = "lik_cursor"

---@class UI_LikCursor:UIKit
local ui = UIKit(kit)

ui:onStart(function(this)

    this:stage().cursor = Cursor()
        :uiKit(kit)
        :sizeRate(20)
        :texture(
        {
            aim = {
                alpha = 255,
                width = 0.035,
                height = 0.035,
                normal = "Framework\\ui\\cursorAimWhite.tga",
                positive = "Framework\\ui\\cursorAimGreen.tga",
                negative = "Framework\\ui\\cursorAimRed.tga",
                neutral = "Framework\\ui\\cursorAimGold.tga",
            },
            drag = { width = 0.04, height = 0.04, alpha = 255, normal = "drag\\normal" },
        })

end)