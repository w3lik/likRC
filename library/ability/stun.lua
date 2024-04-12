--- 眩晕
---@param options {targetUnit:Unit,sourceUnit:Unit,duration:number,odds:number,effect:string,attach:string}|noteAbilityBuff
function ability.stun(options)
    local targetUnit = options.targetUnit
    local sourceUnit = options.sourceUnit
    if (isClass(targetUnit, UnitClass) == false or targetUnit:isDead()) then
        return
    end
    if (isClass(sourceUnit, UnitClass)) then
        if (sourceUnit:isDead()) then
            return
        end
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local odds = (options.odds or 100) - targetUnit:resistance("stun")
    if (odds < math.rand(1, 100)) then
        return
    end
    if (sourceUnit) then
        event.trigger(sourceUnit, EVENT.Unit.Stun, { triggerUnit = sourceUnit, targetUnit = targetUnit, duration = duration })
    end
    event.trigger(targetUnit, EVENT.Unit.Be.Stun, { triggerUnit = targetUnit, sourceUnit = sourceUnit, duration = duration })
    local effect = options.effect or "ThunderclapTarget"
    local attach = options.attach or "overhead"
    local b = targetUnit:buff("stun"):signal(BUFF_SIGNAL.down)
    b:name(options.name)
    b:icon(options.icon)
    b:description(options.description)
    b:duration(duration)
     :purpose(
        function(buffObj)
            buffObj:attach(effect, attach)
            buffObj:superposition("stun", "+=1")
            buffObj:superposition("pause", "+=1")
        end)
     :rollback(
        function(buffObj)
            buffObj:detach(effect, attach)
            buffObj:superposition("pause", "-=1")
            buffObj:superposition("stun", "-=1")
        end)
     :run()
end