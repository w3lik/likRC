--- 无敌
---@param options {whichUnit:Unit,duration:number,effect:string,attach:string}|noteAbilityBuff
function ability.invulnerable(options)
    local whichUnit = options.whichUnit
    if (isClass(whichUnit, UnitClass) == false or whichUnit:isDead()) then
        return
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local effect = options.effect or "DivineShieldTarget"
    local attach = options.attach or "origin"
    local b = whichUnit:buff("invulnerable"):signal(BUFF_SIGNAL.up)
    b:name(options.name)
    b:icon(options.icon)
    b:description(options.description)
    b:duration(duration)
     :purpose(
        function(buffObj)
            buffObj:attach(effect, attach)
            buffObj:superposition("invulnerable", "+=1")
        end)
     :rollback(
        function(buffObj)
            buffObj:detach(effect, attach)
            buffObj:superposition("invulnerable", "-=1")
        end)
     :run()
end