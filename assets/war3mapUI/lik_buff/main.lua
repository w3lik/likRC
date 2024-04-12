--[[
    BUFF
    Author: hunzsig
]]

local kit = "lik_buff"

---@class UI_LikBuff:UIKit
local ui = UIKit(kit)

---@param this UI_LikBuff
ui:onSetup(function(this)

    local stage = this:stage()
    stage.buff_max = 12 --最大buff数
    stage.buff_iSize = 0.02
    stage.buff_iMar = 0
    stage.buff_buffs = {}
    stage.buff_buffSignal = {}
    stage.buff_tips = {}

    stage.buff = FrameBackdrop(kit, FrameGameUI)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, FrameGameUI, FRAME_ALIGN_BOTTOM, -0.054, 0.004)
        :size((stage.buff_iSize * 0.8 + stage.buff_iMar) * stage.buff_max, stage.buff_iSize)

    for i = 1, stage.buff_max do
        stage.buff_buffs[i] = FrameButton(kit .. '->btn->' .. i, stage.buff)
        if (i == 1) then
            stage.buff_buffs[i]:relation(FRAME_ALIGN_CENTER, stage.buff, FRAME_ALIGN_CENTER, -stage.buff_max / 2 * (stage.buff_iSize + stage.buff_iMar), 0)
        else
            stage.buff_buffs[i]:relation(FRAME_ALIGN_LEFT, stage.buff_buffs[i - 1], FRAME_ALIGN_RIGHT, stage.buff_iMar, 0)
        end
        stage.buff_buffs[i]:size(stage.buff_iSize * 0.8, stage.buff_iSize)
             :fontSize(6.5)
             :maskValue(1)
             :show(false)
             :onEvent(EVENT.Frame.Leave, function(_) FrameTooltips():show(false, 0) end)
             :onEvent(
            EVENT.Frame.Enter,
            function()
                local tips = this:tips(stage, i)
                if (tips ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :relation(FRAME_ALIGN_BOTTOM, stage.buff_buffs[i], FRAME_ALIGN_TOP, 0, 0.002)
                        :content({ tips = tips })
                        :show(true)
                end
            end)
        stage.buff_buffSignal[i] = FrameBackdrop(kit .. '->signal->' .. i, stage.buff_buffs[i])
            :relation(FRAME_ALIGN_CENTER, stage.buff_buffs[i], FRAME_ALIGN_CENTER, 0, 0)
            :size(stage.buff_iSize, stage.buff_iSize)
    end

end)

function ui:tips(whichStage, i)
    if (whichStage.buff_tips ~= nil and whichStage.buff_tips[i] ~= nil and whichStage.buff_tips[i].tips ~= nil) then
        return whichStage.buff_tips[i].tips
    end
end

function ui:updated(whichStage, whichUnit)
    local tmpData = {
        ---@type Unit
        buffTexture = {},
        buffAlpha = {},
        buffText = {},
        signalTexture = {},
        maskTexture = {},
        borderTexture = {},
    }
    whichStage.buff_tips = {}
    if (isClass(whichUnit, UnitClass)) then
        if (whichUnit:isAlive()) then
            -- 提取 附魔免疫
            for _, v in ipairs(ENCHANT_TYPES) do
                local isImmune = whichUnit:isEnchantImmune(v)
                if (isImmune) then
                    local e = Enchant(v)
                    local bt = {
                        buffTexture = buff.icon(e:key()),
                        signalTexture = 'immune',
                        maskTexture = 'Framework\\ui\\nil.tga',
                        alpha = 255,
                        text = '',
                        tips = { attribute.label(SYMBOL_EI .. e:key()), colour.hex(colour.gold, "持久") }
                    }
                    table.insert(whichStage.buff_tips, bt)
                end
            end
            -- 提取 附魔武器
            local am = whichUnit:attackMode()
            if (am ~= nil) then
                local damageType = am:damageType()
                if (type(damageType) == "table" and damageType.value ~= "common") then
                    table.insert(whichStage.buff_tips, {
                        buffTexture = buff.icon(damageType.value),
                        signalTexture = 'weapon',
                        maskTexture = 'Framework\\ui\\nil.tga',
                        text = '',
                        alpha = 255,
                        tips = { attribute.label(SYMBOL_E .. damageType.value .. "Weapon"), colour.hex(colour.gold, "持久") },
                    })
                end
            end
            -- 提取 附魔附着
            local appending = whichUnit:enchantAppending()
            if (type(appending) == "table") then
                for _, v in ipairs(ENCHANT_TYPES) do
                    ---@type noteEnchantAppendingData
                    local a = appending[v]
                    if (type(a) == "table") then
                        local e = Enchant(v)
                        local bt = {
                            buffTexture = buff.icon(e:key()),
                            signalTexture = 'append',
                            maskTexture = 'Framework\\ui\\nil.tga',
                            alpha = 255,
                        }
                        if (a.level < 0) then
                            bt.text = ''
                            bt.tips = { attribute.label(SYMBOL_E .. e:key() .. "Append"), colour.hex(colour.gold, "持久") }
                        else
                            bt.text = math.format(a.timer:remain(), 1)
                            bt.tips = { attribute.label(SYMBOL_E .. e:key() .. "Append"), a.level .. "级" }
                        end
                        table.insert(whichStage.buff_tips, bt)
                    end
                end
            end
            local catch = whichUnit:buffCatch({
                limit = (whichStage.buff_max - #whichStage.buff_tips),
                ---@param enumBuff Buff
                filter = function(enumBuff)
                    return true == enumBuff:visible()
                end
            })
            if (#catch > 0) then
                for _, b in ipairs(catch) do
                    local isOdds = (string.subPos(b:key(), SYMBOL_ODD) == 1)
                    local isResistance = (string.subPos(b:key(), SYMBOL_RES) == 1)
                    local signalTexture = 'Framework\\ui\\nil.tga'
                    local maskTexture = 'Framework\\ui\\nil.tga'
                    if (isOdds) then
                        signalTexture = 'odds'
                    elseif (isResistance) then
                        signalTexture = 'resistance'
                    end
                    local lText = b:text()
                    local lAlpha = 255
                    local duration = b:duration()
                    if (duration > 0) then
                        local remain = b:remain()
                        local line = math.min(5, duration)
                        if (remain > line) then
                            lAlpha = 255
                        else
                            lAlpha = 55 + 200 * remain / line
                        end
                        if (lText == nil) then
                            lText = string.format('%0.1f', remain)
                        end
                    end
                    if (lText == nil) then
                        lText = ''
                    end
                    local s = b:signal()
                    if (s == "up") then
                        maskTexture = "up"
                    elseif (s == "down") then
                        maskTexture = "down"
                    end
                    table.insert(whichStage.buff_tips, {
                        buffTexture = b:icon(),
                        signalTexture = signalTexture,
                        maskTexture = maskTexture,
                        text = lText,
                        alpha = lAlpha,
                        tips = b:description(),
                    })
                end
            end
            if (#whichStage.buff_tips > 0) then
                for i, c in ipairs(whichStage.buff_tips) do
                    tmpData.buffTexture[i] = c.buffTexture
                    tmpData.maskTexture[i] = c.maskTexture
                    tmpData.buffAlpha[i] = c.alpha
                    tmpData.buffText[i] = c.text
                    tmpData.signalTexture[i] = c.signalTexture
                end
            end
        end
    end
    for bi = 1, whichStage.buff_max, 1 do
        if (whichStage.buff_tips[bi] ~= nil) then
            whichStage.buff_buffSignal[bi]:texture(AUIKit(kit, tmpData.signalTexture[bi], "tga"))
            whichStage.buff_buffs[bi]:texture(tmpData.buffTexture[bi])
            whichStage.buff_buffs[bi]:alpha(tmpData.buffAlpha[bi])
            whichStage.buff_buffs[bi]:text(tmpData.buffText[bi])
            whichStage.buff_buffs[bi]:mask(AUIKit(kit, tmpData.maskTexture[bi], "tga"))
            whichStage.buff_buffs[bi]:show(true)
        else
            whichStage.buff_buffs[bi]:show(false)
        end
    end
end

---@param this UI_LikBuff
ui:onRefresh(0.1, function(this)
    local p = PlayerLocal()
    async.call(p, function()
        this:updated(this:stage(), p:selection())
    end)
end)