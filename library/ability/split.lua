--- 分裂
---@param options {sourceUnit:Unit,targetUnit:Unit,radius:number,damage:number,damageSrc:table,damageType:table,damageTypeLevel:number,breakArmor:table,effect:string,containSelf:boolean}
function ability.split(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    if (isClass(sourceUnit, UnitClass) == false or sourceUnit:isDead()) then
        return
    end
    if (isClass(targetUnit, UnitClass) == false or targetUnit:isDead()) then
        return
    end
    local radius = options.radius or 200
    event.trigger(sourceUnit, EVENT.Unit.Split, { triggerUnit = sourceUnit, targetUnit = targetUnit, radius = radius })
    event.trigger(targetUnit, EVENT.Unit.Be.Split, { triggerUnit = sourceUnit, sourceUnit = sourceUnit, radius = radius })
    local damage = options.damage or 0
    if (damage > 0) then
        local containSelf = false
        if (type(options.containSelf) == "boolean") then
            containSelf = options.containSelf
        end
        local filter
        if (containSelf) then
            ---@param enumUnit Unit
            filter = function(enumUnit)
                return enumUnit:isAlive() and sourceUnit:isEnemy(enumUnit:owner())
            end
        else
            ---@param enumUnit Unit
            filter = function(enumUnit)
                return enumUnit:isAlive() and enumUnit:isSelf(targetUnit) == false and sourceUnit:isEnemy(enumUnit:owner())
            end
        end
        local enumUnits = Group():catch(UnitClass, {
            filter = filter,
            circle = {
                x = targetUnit:x(),
                y = targetUnit:y(),
                radius = radius,
            },
        })
        if (#enumUnits > 0) then
            for _, eu in ipairs(enumUnits) do
                eu:effect(options.effect, 0.6)
                event.trigger(eu, EVENT.Unit.Be.SplitSpread, { triggerUnit = sourceUnit, sourceUnit = sourceUnit })
                ability.damage({
                    sourceUnit = sourceUnit,
                    targetUnit = eu,
                    damage = damage,
                    damageSrc = options.damageSrc or DAMAGE_SRC.ability,
                    damageType = options.damageType or DAMAGE_TYPE.common,
                    damageTypeLevel = options.damageTypeLevel,
                    breakArmor = options.breakArmor or { BREAK_ARMOR.avoid },
                })
            end
        end
    end
end