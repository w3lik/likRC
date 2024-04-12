local expander = ClassExpander(CLASS_EXPANDS_MOD, CursorClass)

---@param obj Cursor
expander["ability"] = function(obj)
    ---@type Ability
    local data = obj:propData("ability")
    if (data ~= nil) then
        if (data == false) then
            mouse.onLeftClick("LIK_CursorAbilityLeftClick", nil)
            obj:childArea():show(false)
            local prevRadiusUnit = obj:prop("curUnits")
            if (type(prevRadiusUnit) == "table") then
                for _, u in ipairs(prevRadiusUnit) do
                    J.SetUnitVertexColor(u:handle(), table.unpack(u:rgba()))
                end
            end
            local curAimClosest = obj:prop("curAimClosest")
            if (isClass(curAimClosest, UnitClass)) then
                J.SetUnitVertexColor(curAimClosest:handle(), table.unpack(curAimClosest:rgba()))
                obj:clear("curAimClosest")
            end
            local enableSelectTimer = obj:prop("enableSelectTimer")
            if (isClass(enableSelectTimer, TimerClass)) then
                destroy(enableSelectTimer)
                obj:clear("enableSelectTimer")
            end
            obj:clear("curSize")
            obj:clear("curUnits")
            if (isClass(data, AbilityClass)) then
                time.setTimeout(0, function()
                    obj:clear("ability")
                end)
            end
            obj:prop("enableSelectTimer", time.setTimeout(1, function()
                J.EnableSelect(true, false)
            end))
        else
            obj:clear("curAimClosest")
            obj:clear("curSize")
            obj:clear("curUnits")
            local enableSelectTimer = obj:prop("enableSelectTimer")
            if (isClass(enableSelectTimer, TimerClass)) then
                destroy(enableSelectTimer)
                obj:clear("enableSelectTimer")
            end
            if (isClass(data, AbilityClass)) then
                local selection = PlayerLocal():selection()
                if (selection == nil or selection:owner():id() ~= PlayerLocal():id()) then
                    return
                end
                if (selection:isInterrupt() or selection:isPause() or selection:isAbilityChantCasting() or selection:isAbilityKeepCasting()) then
                    return
                end
                local at = data:targetType()
                if (at == nil or at == ABILITY_TARGET_TYPE.pas or at == ABILITY_TARGET_TYPE.tag_nil) then
                    return
                else
                    J.EnableSelect(false, false)
                    time.setTimeout(0, function()
                        J.SelectUnit(selection:handle(), true)
                    end)
                    mouse.onLeftClick("LIK_CursorAbilityLeftClick", function(evtData)
                        ---@type Ability
                        local ab = obj:prop("ability")
                        if (isClass(ab, AbilityClass) == false) then
                            mouse.onLeftClick("LIK_CursorAbilityLeftClick", nil)
                            return
                        end
                        local tt = ab:targetType()
                        if (tt == ABILITY_TARGET_TYPE.tag_unit) then
                            ---@type Unit
                            local targetUnit = obj:prop("curAimClosest")
                            if (isClass(targetUnit, UnitClass)) then
                                if (ab:isCastTarget(targetUnit) == false) then
                                    evtData.triggerPlayer:alert(colour.hex(colour.gold, "目标不允许"))
                                else
                                    sync.send("G_GAME_SYNC", { "ability_effective_u", ab:id(), targetUnit:id() })
                                end
                            end
                        elseif (tt == ABILITY_TARGET_TYPE.tag_loc or
                            tt == ABILITY_TARGET_TYPE.tag_circle or
                            tt == ABILITY_TARGET_TYPE.tag_square) then
                            if (true ~= obj:isSafe(japi.MouseRX(), japi.MouseRY())) then
                                return
                            end
                            local cond = {
                                x = japi.GetMouseTerrainX(),
                                y = japi.GetMouseTerrainY(),
                            }
                            if (tt == ABILITY_TARGET_TYPE.tag_circle) then
                                cond.radius = obj:prop("curSize") or ab:castRadius()
                                cond.units = obj:prop("curUnits")
                            elseif (tt == ABILITY_TARGET_TYPE.tag_square) then
                                local cs = obj:prop("curSize")
                                if (cs) then
                                    cond.height = obj:prop("curSize") or ab:castHeight()
                                    cond.width = ab:castWidth() / ab:castHeight() * cond.height
                                else
                                    cond.height = ab:castHeight()
                                    cond.width = ab:castWidth()
                                end
                                cond.units = obj:prop("curUnits")
                            end
                            if (ab:isBanCursor(cond)) then
                                PlayerLocal():alert(colour.hex(colour.red, "无效目标"))
                                return
                            end
                            sync.send("G_GAME_SYNC", { "ability_effective_xyz", ab:id(), cond.x, cond.y, japi.GetMouseTerrainZ() })
                        end
                    end)
                end
            end
        end
    end
end

---@param obj Cursor
expander["followObj"] = function(obj, prev)
    ---@type Object
    local data = obj:propData("followObj")
    if (data ~= nil) then
        if (data == false) then
            japi.Refresh("LIK_CursorFollow", nil)
            mouse.onLeftClick("LIK_CursorFollowDrop", nil)
            ---@type FrameBackdrop
            obj:childFollow():alpha(0):show(false)
            local followData = obj:prop("followData") or {}
            followData.followObj = prev
            local stopFunc = obj:prop("followStopFunc")
            if (type(stopFunc) == "function") then
                stopFunc(followData)
            end
            obj:clear("followObj")
            local enableSelectTimer = obj:prop("enableSelectTimer")
            if (isClass(enableSelectTimer, TimerClass)) then
                destroy(enableSelectTimer)
                obj:clear("enableSelectTimer")
            end
            obj:prop("enableSelectTimer", time.setTimeout(1, function()
                J.EnableSelect(true, false)
            end))
        else
            obj:abilityStop()
            local enableSelectTimer = obj:prop("enableSelectTimer")
            if (isClass(enableSelectTimer, TimerClass)) then
                destroy(enableSelectTimer)
                obj:clear("enableSelectTimer")
            end
            local d = obj:prop("followData") or {}
            local texture = d.texture
            local size = d.size
            if (inClass(d.frame, FrameButtonClass, FrameBackdropClass, FrameBackdropTileClass)) then
                if (texture == nil) then
                    texture = d.frame:texture()
                end
                if (size == nil) then
                    size = d.frame:size()
                end
            end
            ---@type FrameBackdrop
            obj:childFollow()
               :texture(texture)
               :size(size[1], size[2])
               :relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, japi.MouseRX(), japi.MouseRY())
               :alpha(150)
               :show(true)

            local selection = PlayerLocal():selection()
            if (isClass(selection, UnitClass)) then
                J.EnableSelect(false, false)
                time.setTimeout(0, function()
                    J.SelectUnit(selection:handle(), true)
                end)
            end
            japi.Refresh("LIK_CursorFollow", function()
                local prevObj = obj:followObj()
                if (false == table.equal(data, prevObj)) then
                    japi.Refresh("LIK_CursorFollow", nil)
                    obj:followStop()
                    return
                end
                local siz = obj:childFollow():size()
                local mx = japi.MouseRX()
                local my = japi.MouseRY()
                if (siz ~= nil) then
                    local hw = siz[1] / 2
                    local hh = siz[2] / 2
                    if (mx - hw < 0) then
                        mx = hw
                    end
                    if (mx + hw > 0.8) then
                        mx = 0.8 - hw
                    end
                    if (my - hh < 0) then
                        my = hh
                    end
                    if (my + hh > 0.6) then
                        my = 0.6 - hh
                    end
                end
                obj:childFollow():relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, mx, my)
            end)
            if (isClass(data, ItemClass) and data:dropable()) then
                mouse.onLeftClick("LIK_CursorFollowDrop", function()
                    local o = obj:followObj()
                    if (obj:isSafe(japi.MouseRX(), japi.MouseRY())) then
                        local tx, ty = japi.GetMouseTerrainX(), japi.GetMouseTerrainY()
                        local closest = Group():closest(UnitClass, {
                            limit = 5,
                            circle = {
                                x = tx,
                                y = ty,
                                radius = 150,
                            },
                            ---@param enumUnit Unit
                            filter = function(enumUnit)
                                return enumUnit ~= selection and enumUnit:isAlive() and enumUnit:owner() == selection:owner()
                            end
                        })
                        if (isClass(closest, UnitClass)) then
                            sync.send("G_GAME_SYNC", { "item_deliver_cursor", o:id(), closest:id() })
                        else
                            sync.send("G_GAME_SYNC", { "item_drop_cursor", o:id(), tx, ty })
                        end
                        obj:followStop()
                    end
                end)
            end
        end
    end
end