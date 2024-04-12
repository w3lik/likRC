---@param ui UI_LikPlate
function likPlate_eventReaction(ui)

    ---@param evtData noteOnPropGame|noteOnPropPlayer
    event.reaction(EVENT.Prop.Change, ui:kit(), function(evtData)
        if (isClass(evtData.triggerObject, PlayerClass)) then
            if (evtData.key == "selection" and sync.is()) then
                async.call(evtData.triggerObject, function()
                    ui:updatePlate()
                    ui:updateAbility()
                    ui:updateItem()
                end)
                -- 注册变化事件
                event.register(evtData.old, EVENT.Unit.ItemSlotChange, ui:kit(), nil)
                event.register(evtData.old, EVENT.Unit.AbilitySlotChange, ui:kit(), nil)
                ---@param ed noteOnUnitItemSlotChangeData
                event.register(evtData.new, EVENT.Unit.ItemSlotChange, ui:kit(), function(ed)
                    async.call(ed.triggerUnit:owner(), function()
                        ui:updateItem()
                    end)
                end)
                ---@param ed noteOnUnitAbilitySlotChangeData
                event.register(evtData.new, EVENT.Unit.AbilitySlotChange, ui:kit(), function(ed)
                    async.call(ed.triggerUnit:owner(), function()
                        ui:updateAbility()
                    end)
                end)
            end
        elseif (isClass(evtData.triggerObject, UnitClass) and sync.is()) then
            if (evtData.triggerObject == PlayerLocal():selection()) then
                async.call(PlayerLocal(), function()
                    ui:updatePlate()
                end)
            end
        end
    end)

end