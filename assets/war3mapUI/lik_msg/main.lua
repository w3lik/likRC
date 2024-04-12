--[[
    消息类
    Author: hunzsig
]]

local kit = "lik_msg"

---@class UI_LikMsg:UIKit
local ui = UIKit(kit)

ui:onSetup(function(this)
    local stage = this:stage()
    -- Echo 屏幕信息
    if (false == isStaticClass("lik_echo", UIKitClass)) then
        stage.echo = Frame(kit .. "->echo", japi.FrameGetUnitMessage(), nil)
            :absolut(FRAME_ALIGN_LEFT_BOTTOM, 0.134, 0.18)
            :size(0, 0.36)
    end
    -- Chat 居中聊天信息
    stage.chat = Frame(kit .. "->chat", japi.FrameGetChatMessage(), nil)
        :absolut(FRAME_ALIGN_BOTTOM, 0, 0.22)
        :size(0.22, 0.16)
    -- Alert 警告
    stage.alert = FrameText(kit .. "->alert", FrameGameUI)
        :relation(FRAME_ALIGN_BOTTOM, FrameGameUI, FRAME_ALIGN_BOTTOM, 0, 0.17)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(13)

    ---@param evtData noteOnPropPlayer
    event.reaction(EVENT.Prop.Change, "lik_msg", function(evtData)
        if (isClass(evtData.triggerObject, PlayerClass)) then
            if (evtData.key == "alert") then
                async.call(evtData.triggerObject, function()
                    stage.alert:text(evtData.new)
                end)
            end
        end
    end)

end)