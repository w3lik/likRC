---@param stage UI_LikPlateStage
function likPlate_frameAbility(kit, stage)

    local kitAb = kit .. "->ability"

    stage.ability = FrameBackdrop(kitAb, FrameGameUI)
        :relation(FRAME_ALIGN_RIGHT_BOTTOM, FrameGameUI, FRAME_ALIGN_RIGHT_BOTTOM, 0, 0)
        :size(0.202, 0.16)
        :show(false)

    ---@type FrameBackdrop[]
    stage.abilityBedding = {}

    ---@type FrameButton[]
    stage.abilityBtn = {}

    ---@type FrameButton[]
    stage.abilityBtnLvUp = {}

    stage.abilitySizeX = 0.0366
    stage.abilitySizeY = 0.0376
    stage.abilityMarginX = 0.0068
    stage.abilityMarginY = 0.0056

    for i = 1, stage.abilityMAX do
        stage.abilityBedding[i] = FrameBackdrop(kitAb .. '->bedding->' .. i, stage.ability)
            :size(stage.abilitySizeX, stage.abilitySizeY)
            :texture("Framework\\ui\\nil.tga")
            :show(i < 5)
        if (i == 1) then
            stage.abilityBedding[i]:relation(FRAME_ALIGN_LEFT_TOP, FrameGameUI, FRAME_ALIGN_RIGHT_BOTTOM, -0.181, 0.0446)
        elseif ((i - 1) % 4 == 0) then
            local j = (i // 4 - 1) * 4 + 1
            stage.abilityBedding[i]:relation(FRAME_ALIGN_LEFT_BOTTOM, stage.abilityBedding[j], FRAME_ALIGN_LEFT_TOP, 0, stage.abilityMarginY)
        else
            stage.abilityBedding[i]:relation(FRAME_ALIGN_LEFT_TOP, stage.abilityBedding[i - 1], FRAME_ALIGN_RIGHT_TOP, stage.abilityMarginX, 0)
        end
    end
    for i = 1, stage.abilityMAX do
        stage.abilityBtn[i] = FrameButton(kitAb .. '->btn->' .. i, stage.ability)
            :size(stage.abilitySizeX, stage.abilitySizeY)
            :relation(FRAME_ALIGN_CENTER, stage.abilityBedding[i], FRAME_ALIGN_CENTER, 0, 0)
            :hotkeyFontSize(9)
            :fontSize(10)
            :mask('Framework\\ui\\black.tga')
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                if (Cursor():isFollowing() or Cursor():dragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (selection == nil) then
                    return
                end
                local slot = selection:abilitySlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                evtData.triggerFrame:childHighlight():show(true)
                local content = tooltipsAbility(storage[i], 0)
                if (content ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :fontSize(10)
                        :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.ability, FRAME_ALIGN_RIGHT_TOP, -0.002, 0.002)
                        :content(content)
                        :show(true)
                end
            end)
            :onEvent(EVENT.Frame.Leave,
            function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                FrameTooltips():show(false)
            end)
            :onEvent(EVENT.Frame.LeftClick,
            function(evtData)
                local selection = evtData.triggerPlayer:selection()
                if (isClass(selection, UnitClass) == false) then
                    return
                end
                local slot = selection:abilitySlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                Cursor():abilityQuote(storage[i])
            end)
            :show(false)

        stage.abilityBtn[i]:childMask():alpha(180)
        stage.abilityBtn[i]:childBorder():size(stage.abilitySizeX * 1.05, stage.abilitySizeY * 1.04)
        stage.abilityBtn[i]:childHotkey()
             :relation(FRAME_ALIGN_RIGHT_TOP, stage.abilityBtn[i], FRAME_ALIGN_RIGHT_TOP, -0.004, -0.004)

        stage.abilityBtnLvUp[i] = FrameButton(kitAb .. '->upbtn->' .. i, stage.abilityBedding[i])
            :relation(FRAME_ALIGN_BOTTOM, stage.abilityBtn[i], FRAME_ALIGN_TOP, 0, 0)
            :texture('icon\\up')
            :show(false)
            :onEvent(EVENT.Frame.Leave, function(_) FrameTooltips():show(false, 0) end)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                local selection = evtData.triggerPlayer:selection()
                if (selection == nil) then
                    return
                end
                local content = tooltipsAbility(selection:abilitySlot():storage()[i], 1)
                if (content ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :fontSize(10)
                        :relation(FRAME_ALIGN_BOTTOM, stage.abilityBtnLvUp[i], FRAME_ALIGN_TOP, 0, 0.002)
                        :content(content)
                        :show(true)
                end
            end)
            :onEvent(EVENT.Frame.LeftClick,
            function(evtData)
                local selection = evtData.triggerPlayer:selection()
                if (isClass(selection, 'Unit') and selection:isAlive() and selection:owner() == evtData.triggerPlayer) then
                    audio(Vcm("war3_MouseClick1"))
                    local ab = selection:abilitySlot():storage()[i]
                    if (isClass(ab, AbilityClass)) then
                        sync.send("G_GAME_SYNC", { "ability_level_up", ab:id() })
                        local content = tooltipsAbility(ab, 1)
                        if (content ~= nil) then
                            FrameTooltips()
                                :kit(kit)
                                :textAlign(TEXT_ALIGN_LEFT)
                                :fontSize(10)
                                :content(content)
                        end
                    end
                end
            end)
    end

    --- right-sync

    sync.receive(kitAb .. "_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "push") then
            local abId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            ---@type Ability
            local ab = i2o(abId)
            if (isClass(ab, AbilityClass)) then
                syncPlayer:selection():abilitySlot():insert(ab, i)
            end
            japi.FrameSetAlpha(stage.abilityBtn[fi]:handle(), stage.abilityBtn[fi]:alpha())
        end
    end)

    mouse.onRightClick(kitAb .. "_mouse_right", function(evtData)
        local triggerPlayer = evtData.triggerPlayer
        local followObject = Cursor():followObj()
        local ing = Cursor():isFollowing() or Cursor():dragging()
        if (ing == true and isClass(followObject, AbilityClass) == false) then
            return
        end
        local selection = triggerPlayer:selection()
        if (isClass(selection, 'Unit')) then
            local abilitySlot = selection:abilitySlot()
            if (selection:isAlive() and selection:owner() == triggerPlayer and abilitySlot ~= nil) then
                local j = 0
                for i = 1, stage.abilityMAX do
                    local ab = abilitySlot:storage()[i]
                    local bed = stage.abilityBedding[i]
                    if (bed:isInner()) then
                        if (ing == true) then
                            if (table.equal(followObject, ab) == false) then
                                Cursor():followStop(function(stopData)
                                    local fab = stopData.followObj
                                    if (isClass(fab, AbilityClass)) then
                                        local fi = stopData.i
                                        local fo = stopData.followObj
                                        sync.send(kitAb .. "_SYNC", { "push", fo:id(), i, fi })
                                        audio(Vcm("war3_MouseClick1"))
                                    end
                                end)
                            else
                                Cursor():followStop()
                            end
                        elseif (isClass(ab, AbilityClass)) then
                            FrameTooltips():show(false, 0)
                            audio(Vcm("war3_MouseClick1"))
                            japi.FrameSetAlpha(stage.abilityBtn[i]:handle(), 0)
                            Cursor():followCall(ab, { frame = stage.abilityBtn[i], i = i }, function(stopData)
                                japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                            end)
                        end
                        break
                    end
                    j = i + 1
                end
                if (j > stage.abilityMAX and ing == true) then
                    Cursor():followStop()
                end
            end
        end
    end)

end