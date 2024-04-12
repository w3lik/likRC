--[[
    debug提示
    Author: hunzsig
]]

if (DEBUGGING) then

    collectgarbage("collect")
    local ram = collectgarbage("count")

    local kit = "lik_debug"

    ---@class UI_LikDebug:UIKit
    local ui = UIKit(kit)

    ui:onSetup(function(this)

        ---@class UI_LikDebugStage
        local stage = this:stage()

        stage.infoIndex = 1

        stage.main = FrameText(kit, FrameGameUI)
            :relation(FRAME_ALIGN_LEFT_BOTTOM, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, 0.001, 0.20)
            :textAlign(TEXT_ALIGN_LEFT)
            :fontSize(7)

        stage.ram = FrameText(kit .. "->ram", FrameGameUI)
            :adaptive(true)
            :relation(FRAME_ALIGN_TOP, FrameGameUI, FRAME_ALIGN_TOP, -0.25, -0.03)
            :textAlign(TEXT_ALIGN_LEFT)
            :fontSize(8)

        stage.mark = FrameBackdrop(kit .. "->mark", FrameGameUI)
            :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_CENTER, 0, 0)
            :size(2, 2)
            :alpha(100)
            :texture(TEAM_COLOR_BLP_BLACK)
            :show(false)

        ---@type FrameBackdropTile[]
        stage.line = {}
        local graduation = 0.05
        local texture = TEAM_COLOR_BLP_YELLOW
        local txtColor = "ffe600"
        for i = 1, math.floor(0.6 / graduation - 0.5), 1 do
            local tile = FrameBackdropTile(kit .. "->horizontal->" .. i, FrameGameUI)
                :relation(FRAME_ALIGN_BOTTOM, FrameGameUI, FRAME_ALIGN_BOTTOM, 0, graduation * i)
                :size(2, 0.001)
                :texture(texture)
                :show(false)
            FrameText(kit .. "->horizontal->txt->" .. i, tile)
                :relation(FRAME_ALIGN_LEFT, tile, FRAME_ALIGN_LEFT, 0.002, 0.01)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(12)
                :text(colour.hex(txtColor, graduation * i))
            table.insert(stage.line, tile)
        end
        for i = 1, math.floor(0.8 / graduation - 0.5), 1 do
            local tile = FrameBackdropTile(kit .. "->vertical->" .. i, FrameGameUI)
                :relation(FRAME_ALIGN_LEFT, FrameGameUI, FRAME_ALIGN_LEFT, graduation * i, 0)
                :size(0.001, 2)
                :texture(texture)
                :show(false)
            FrameText(kit .. "->vertical->txt->" .. i, tile)
                :relation(FRAME_ALIGN_BOTTOM, tile, FRAME_ALIGN_BOTTOM, 0.01, 0.01)
                :textAlign(TEXT_ALIGN_LEFT)
                :fontSize(12)
                :text(colour.hex(txtColor, graduation * i))
            table.insert(stage.line, tile)
        end

        stage.costAvg = stage.costAvg or {}
        stage.types = { "all", "max" }
        stage.typesLabel = {
            all = "当前句柄数",
            max = "最大句柄数",
            ["+EIP"] = "对点特效",
            ["+EIm"] = "附着特效",
            ["+cst"] = "镜头",
            ["+dlb"] = "对话框按钮",
            ["+dlg"] = "对话框",
            ["+fgm"] = "可见修正器",
            ["+flt"] = "过滤器",
            ["+frc"] = "玩家势力",
            ["+grp"] = "单位组",
            ["+loc"] = "点",
            ["+ply"] = "玩家",
            ["+que"] = "任务",
            ["+rct"] = "区域",
            ["+snd"] = "声音",
            ["+tac"] = "触发器动作",
            ["+tmr"] = "计时器",
            ["+trg"] = "触发器",
            ["+w3d"] = "可破坏物",
            ["+w3u"] = "单位",
            ["devt"] = "对话框事件",
            ["pcvt"] = "玩家聊天事件",
            ["pevt"] = "玩家事件",
            ["tcnd"] = "触发器条件",
            ["uevt"] = "单位事件",
            ["wdvt"] = "可破坏物事件",
        }
    end)

    ---@param this UI_LikDebug
    ui:onRefresh(0.2, function(this)
        ---@type UI_LikDebugStage
        local stage = this:stage()
        local msg = this:debug()
        local mem = this:mem()
        local p = PlayerLocal()
        if (p:isPlaying() and p:isComputer() == false) then
            async.call(p, function()
                stage.main:text(table.concat(msg, '|n'))
                stage.ram:text(table.concat(mem, '   '))
                local show = keyboard.isPressing(KEYBOARD["Control"])
                stage.mark:show(show)
                for _, l in ipairs(stage.line) do
                    l:show(show)
                end
                if (keyboard.isPressing(KEYBOARD["Alt"]) and keyboard.isPressing(KEYBOARD['~'])) then
                    stage.infoIndex = stage.infoIndex + 1
                    if (stage.infoIndex > 2) then
                        stage.infoIndex = 1
                    end
                end
            end)
        end
    end)

    function ui:mem()
        ---@type UI_LikDebugStage
        local stage = self:stage()
        local cost = (collectgarbage("count") - ram) / 1024
        if (stage.costMax == nil or stage.costMax < cost) then
            stage.costMax = cost
        end
        local avg = 0
        if (#stage.costAvg < 100) then
            table.insert(stage.costAvg, cost)
            avg = table.average(stage.costAvg)
        else
            avg = table.average(stage.costAvg)
            stage.costAvg = { avg }
        end
        return {
            "FPS : " .. math.format(japi.FPS(), 1),
            colour.hex(colour.skyblue, "平均 : " .. math.format(avg, 3) .. ' MB'),
            colour.hex(colour.littlepink, "最大 : " .. math.format(stage.costMax, 3) .. ' MB'),
            colour.hex(colour.gold, "当前 : " .. math.format(cost, 3) .. ' MB'),
        }
    end

    function ui:debug()
        ---@type UI_LikDebugStage
        local stage = self:stage()
        local txts = {}
        if (stage.infoIndex == 1) then
            local count = { all = 0, max = J.handleMax() }
            for i = 1, count.max do
                local h = 0x100000 + i
                local info = J.handleDef(h)
                if (info and info.type) then
                    if (not table.includes(stage.types, info.type)) then
                        table.insert(stage.types, info.type)
                    end
                    if (count[info.type] == nil) then
                        count[info.type] = 0
                    end
                    count.all = count.all + 1
                    count[info.type] = count[info.type] + 1
                end
            end
            table.insert(txts, "  [内核]")
            table.insert(txts, "  模型漂浮字 : " .. ttg._count)
            for _, v in ipairs(stage.types) do
                table.insert(txts, "  " .. (stage.typesLabel[v] or v) .. " : " .. (count[v] or 0))
            end
        elseif (stage.infoIndex == 2) then
            table.insert(txts, "|n  [对象]")
            for k, v in pairx(oop._dbg) do
                local ol = 0
                for _ in pairs(v) do
                    ol = ol + 1
                end
                table.insert(txts, "  " .. k .. " : " .. ol)
            end
        end
        return txts
    end

end