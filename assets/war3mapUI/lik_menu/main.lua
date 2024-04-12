--[[
    顶部菜单
    Author: hunzsig
]]

local kit = "lik_menu"

---@class UI_LikMenu:UIKit
local ui = UIKit(kit)

ui:onSetup(function(this)
    local stage = this:stage()

    stage.mapNameBlack = FrameBackdrop(kit, FrameGameUI)
        :block(true)
        :absolut(FRAME_ALIGN_RIGHT_TOP, -0.005, -0.003)
        :size(0.07, 0.016)
        :texture("Framework\\ui\\black.tga")

    stage.mapName = FrameText(kit .. "->mn", stage.mapNameBlack)
        :relation(FRAME_ALIGN_CENTER, stage.mapNameBlack, FRAME_ALIGN_CENTER, 0, 0)
        :textAlign(TEXT_ALIGN_LEFT)
        :text(colour.hex(colour.gold, Game():name()))

    stage.info = FrameText(kit .. "->info", FrameGameUI)
        :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, 0, -0.014)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(8)
        :text("")

    stage.updateInfo = function()
        stage.info:text(table.concat(Game():infoCenter(), "|n"))
    end

    ---@param evtData noteOnPropGame|noteOnPropPlayer
    event.reaction(EVENT.Prop.Change, "lik_menu", function(evtData)
        if (isClass(evtData.triggerObject, GameClass)) then
            async.call(PlayerLocal(), function()
                if (i18n.isEnable() and evtData.key == "i18nLang") then
                    stage.updateInfo()
                elseif (evtData.key == "infoCenter") then
                    stage.updateInfo()
                end
            end)
        end
    end)

end)