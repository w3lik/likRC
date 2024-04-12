---@class destructable
destructable = destructable or {}

destructable._evtDead = destructable._evtDead or J.Condition(function()
    local deadDest = J.GetTriggerDestructable()
    if (deadDest == nil) then
        return
    end
    event.trigger(RegionWorld, EVENT.Destructable.Dead, {
        triggerDestructable = deadDest,
        name = J.GetDestructableName(deadDest),
        x = J.GetDestructableX(deadDest),
        y = J.GetDestructableY(deadDest),
    })
end)

---@param id string
---@return table
function destructable.slk(id)
    must(type(id) == "string")
    local v = slk.i2v(id)
    if (v) then
        v = v.slk
    else
        v = J.Slk["destructable"][id]
    end
    must(v ~= nil)
    return v
end

---@param whichDest number|Destructable
function destructable.kill(whichDest)
    if (isClass(whichDest, DestructableClass)) then
        whichDest = whichDest:handle()
    end
    if (type(whichDest) == "number") then
        J.KillDestructable(whichDest)
        event.trigger(RegionWorld, EVENT.Destructable.Dead, {
            triggerDestructable = whichDest,
            name = J.GetDestructableName(whichDest),
            x = J.GetDestructableX(whichDest),
            y = J.GetDestructableY(whichDest),
        })
    end
end

---@param whichDest number|Destructable
---@param hasAnimate boolean
function destructable.reborn(whichDest, hasAnimate)
    if (isClass(whichDest, DestructableClass)) then
        whichDest = whichDest:handle()
    end
    if (type(whichDest) == "number") then
        J.DestructableRestoreLife(whichDest, J.GetDestructableMaxLife(whichDest), hasAnimate or false)
    end
end