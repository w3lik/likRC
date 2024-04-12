--- 隐身
---@param options {whichUnit:Unit,duration:number,effect:string}|noteAbilityBuff
function ability.invisible(options)
    local whichUnit = options.whichUnit
    if (isClass(whichUnit, UnitClass) == false or whichUnit:isDead()) then
        return
    end
    local duration = options.duration or 0
    whichUnit:effect(options.effect)
    local b = whichUnit:buff("invisible"):signal(BUFF_SIGNAL.up)
    b:name(options.name)
    b:icon(options.icon)
    b:description(options.description)
    b:duration(duration)
     :purpose(
        function(buffObj)
            buffObj:superposition("invisible", "+=1")
        end)
     :rollback(
        function(buffObj)
            buffObj:superposition("invisible", "-=1")
        end)
     :run()
end

--- 取消隐身
---@param options {whichUnit:Unit,effect:string}
function ability.unInvisible(options)
    local whichUnit = options.whichUnit
    if (isClass(whichUnit, UnitClass) == false or whichUnit:isDead()) then
        return
    end
    whichUnit:effect(options.effect)
    whichUnit:buffClear({ key = "invisible" })
end