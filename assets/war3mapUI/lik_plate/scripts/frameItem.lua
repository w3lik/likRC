---@param stage UI_LikPlateStage
function likPlate_frameItem(kit, stage)

    local kitIt = kit .. "->item"

    stage.item = FrameBackdrop(kitIt, FrameGameUI)
        :block(true)
        :relation(FRAME_ALIGN_LEFT_BOTTOM, FrameGameUI, FRAME_ALIGN_BOTTOM, 0.111, 0)
        :size(0.078, 0.098)

    ---@type FrameButton[]
    stage.itemButton = {}

    ---@type FrameText[]
    stage.itemCharges = {}

    stage.itemSizeX = 0.032
    stage.itemSizeY = 0.0294
    stage.itemMarginX = 0.008
    stage.itemMarginY = 0.009

    local raw = 2
    for i = 1, stage.itemMAX do
        local xo = 0.0040 + (i - 1) % raw * (stage.itemSizeX + stage.itemMarginX)
        local yo = 0.0132 - (math.ceil(i / raw) - 1) * (stage.itemMarginY + stage.itemSizeY)
        stage.itemButton[i] = FrameButton(kit .. '->btn->' .. i, stage.item)
            :relation(FRAME_ALIGN_LEFT_TOP, stage.item, FRAME_ALIGN_LEFT_TOP, xo, yo)
            :size(stage.itemSizeX, stage.itemSizeY)
            :fontSize(7.5)
            :mask('Framework\\ui\\black.tga')
            :show(false)
            :onEvent(EVENT.Frame.Leave,
            function(evtData)
                evtData.triggerFrame:childHighlight():show(false)
                FrameTooltips():show(false)
            end)
            :onEvent(EVENT.Frame.Enter,
            function(evtData)
                if (Cursor():isFollowing() or Cursor():dragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (false == isClass(selection, UnitClass)) then
                    return nil
                end
                local slot = selection:itemSlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                evtData.triggerFrame:childHighlight():show(true)
                local content = tooltipsItem(storage[i])
                if (content ~= nil) then
                    FrameTooltips()
                        :kit(kit)
                        :fontSize(10)
                        :textAlign(TEXT_ALIGN_LEFT)
                        :relation(FRAME_ALIGN_BOTTOM, stage.item, FRAME_ALIGN_TOP, 0, 0.04)
                        :content(content)
                        :show(true)
                end
            end)
            :onEvent(EVENT.Frame.LeftClick,
            function(evtData)
                if (Cursor():isFollowing() or Cursor():dragging()) then
                    return
                end
                local selection = evtData.triggerPlayer:selection()
                if (isClass(selection, UnitClass) == false) then
                    return
                end
                local slot = selection:itemSlot()
                if (slot == nil) then
                    return
                end
                local storage = slot:storage()
                if (storage == nil) then
                    return
                end
                Cursor():itemQuote(storage[i])
            end)

        stage.itemButton[i]:childMask():alpha(180)
        stage.itemButton[i]:childBorder():size(stage.itemSizeX * 1.05, stage.itemSizeY * 1.04)

        -- 物品使用次数
        stage.itemCharges[i] = FrameButton(kit .. '->charges->' .. i, stage.itemButton[i])
            :relation(FRAME_ALIGN_RIGHT_BOTTOM, stage.itemButton[i], FRAME_ALIGN_RIGHT_BOTTOM, -0.0014, 0.0014)
            :texture(TEAM_COLOR_BLP_BLACK)
            :fontSize(7)
    end

    --- right-sync

    --- 跟踪回调
    local onFollowChange = function(stopData, i)
        local fi = stopData.i
        local fo = stopData.followObj
        if (fi <= stage.itemMAX and i <= stage.itemMAX) then
            -- 物品 -> 物品
            sync.send(kitIt .. "_SYNC", { "item_push", fo:id(), i, fi })
            audio(Vcm("war3_MouseClick1"))
        elseif (fi > stage.itemMAX and i > stage.itemMAX) then
            -- 仓库 -> 仓库
            sync.send(kitIt .. "_SYNC", { "warehouse_push", fo:id(), i - stage.itemMAX, fi - stage.itemMAX })
            audio(Vcm("war3_MouseClick1"))
        elseif (fi <= stage.itemMAX and i > stage.itemMAX) then
            -- 物品 -> 仓库
            sync.send(kitIt .. "_SYNC", { "item_to_warehouse", fo:id(), i - stage.itemMAX, fi })
            audio(Vcm("war3_MouseClick1"))
        elseif (fi > stage.itemMAX and i <= stage.itemMAX) then
            -- 仓库 -> 物品
            sync.send(kitIt .. "_SYNC", { "warehouse_to_item", fo:id(), i, fi - stage.itemMAX })
            audio(Vcm("war3_MouseClick1"))
        end
    end

    sync.receive(kitIt .. "_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "item_push") then
            local itId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:selection():itemSlot():insert(it, i)
            end
            japi.FrameSetAlpha(stage.itemButton[fi]:handle(), stage.itemButton[fi]:alpha())
        elseif (command == "warehouse_push") then
            local itId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:warehouseSlot():insert(it, i)
            end
            japi.FrameSetAlpha(stage.warehouseButton[fi]:handle(), stage.warehouseButton[fi]:alpha())
        elseif (command == "item_to_warehouse") then
            local itId = syncData.transferData[2]
            local wIdx = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                local itIdx = it:itemSlotIndex()
                syncPlayer:selection():itemSlot():remove(itIdx)
                local wIt = syncPlayer:warehouseSlot():storage()[wIdx]
                if (isClass(wIt, ItemClass)) then
                    syncPlayer:warehouseSlot():remove(wIdx)
                    syncPlayer:selection():itemSlot():insert(wIt, itIdx)
                end
                syncPlayer:warehouseSlot():insert(it, wIdx)
            end
            japi.FrameSetAlpha(stage.itemButton[fi]:handle(), stage.itemButton[fi]:alpha())
        elseif (command == "warehouse_to_item") then
            local wItId = syncData.transferData[2]
            local itIdx = tonumber(syncData.transferData[3])
            local fi = tonumber(syncData.transferData[4])
            ---@type Item
            local wIt = i2o(wItId)
            if (isClass(wIt, ItemClass)) then
                local wIdx = wIt:warehouseSlotIndex()
                syncPlayer:warehouseSlot():remove(wIdx)
                local it = syncPlayer:selection():itemSlot():storage()[itIdx]
                if (isClass(it, ItemClass)) then
                    syncPlayer:selection():itemSlot():remove(it, itIdx)
                    syncPlayer:warehouseSlot():insert(it, wIdx)
                end
                syncPlayer:selection():itemSlot():insert(wIt, itIdx)
            end
            japi.FrameSetAlpha(stage.warehouseButton[fi]:handle(), stage.warehouseButton[fi]:alpha())
        end
    end)

    mouse.onRightClick(kitIt .. "_mouse_right", function(evtData)
        local triggerPlayer = evtData.triggerPlayer
        local followObject = Cursor():followObj()
        local ing = Cursor():isFollowing() or Cursor():dragging()
        if (ing == true and isClass(followObject, ItemClass) == false) then
            return
        end
        local selection = triggerPlayer:selection()
        local iCheck = false
        local wCheck = false
        if (isClass(selection, 'Unit')) then
            if (selection:isAlive() and selection:owner() == triggerPlayer) then
                local itemSlot = selection:itemSlot()
                if (itemSlot ~= nil) then
                    for i = 1, stage.itemMAX do
                        local it = itemSlot:storage()[i]
                        local btn = stage.itemButton[i]
                        if (true == btn:parent():show() and btn:isInner(nil, nil, false)) then
                            if (ing == true) then
                                if (table.equal(followObject, it) == false) then
                                    Cursor():followStop(function(stopData)
                                        onFollowChange(stopData, i)
                                    end)
                                else
                                    Cursor():followStop()
                                end
                            elseif (isClass(it, ItemClass)) then
                                FrameTooltips():show(false, 0)
                                audio(Vcm("war3_MouseClick1"))
                                japi.FrameSetAlpha(btn:handle(), 0)
                                Cursor():followCall(it, { frame = btn, i = i }, function(stopData)
                                    japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                                end)
                            end
                            iCheck = true
                            break
                        end
                    end
                end
            end
        end
        for i = 1, stage.warehouseMAX do
            local it = triggerPlayer:warehouseSlot():storage()[i]
            local btn = stage.warehouseButton[i]
            if (true == btn:parent():show() and btn:isInner(nil, nil, false)) then
                if (ing == true) then
                    if (table.equal(followObject, it) == false) then
                        Cursor():followStop(function(stopData)
                            onFollowChange(stopData, stage.itemMAX + i)
                        end)
                    else
                        Cursor():followStop()
                    end
                elseif (isClass(it, ItemClass)) then
                    FrameTooltips():show(false, 0)
                    audio(Vcm("war3_MouseClick1"))
                    japi.FrameSetAlpha(btn:handle(), 0)
                    Cursor():followCall(it, { frame = btn, i = stage.itemMAX + i }, function(stopData)
                        japi.FrameSetAlpha(stopData.frame:handle(), stopData.frame:alpha())
                    end)
                end
                wCheck = true
                break
            end
        end
        if (iCheck == false and wCheck == false and ing == true) then
            Cursor():followStop()
        end
    end)

end