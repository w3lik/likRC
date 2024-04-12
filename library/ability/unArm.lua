--- 缴械
---@param options {whichUnit:Unit,duration:number,effect:string,attach:string}|noteAbilityBuff
function ability.unArm(options)
    local whichUnit = options.whichUnit
    if (isClass(whichUnit, UnitClass) == false or whichUnit:isDead()) then
        return
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local effect = options.effect or "SilenceTarget"
    local attach = options.attach or "weapon"
    local b = whichUnit:buff("unArm"):signal(BUFF_SIGNAL.down)
    b:name(options.name)
    b:icon(options.icon)
    b:description(options.description)
    b:duration(duration)
     :purpose(
        function(buffObj)
            buffObj:attach(effect, attach)
            buffObj:superposition("unArm", "+=1")
            buffObj:superposition("noAttack", "+=1")
        end)
     :rollback(
        function(buffObj)
            buffObj:detach(effect, attach)
            buffObj:superposition("noAttack", "-=1")
            buffObj:superposition("unArm", "-=1")
        end)
     :run()
end