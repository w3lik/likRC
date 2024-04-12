---@class Destructable:DestructableClass
---@param modelAlias number|string 原生ID[如WTst夏季树木]或自定义modelAlias
---@param x number
---@param y number
---@param z number|nil
---@param facing number|nil
---@param modelScale number|nil
---@param variation number|nil
---@return Destructable|nil
function Destructable(modelAlias, x, y, z, facing, modelScale, variation)
    must(type(x) == "number" and type(y) == "number")
    local id
    if (type(FRAMEWORK_DESTRUCTABLE[modelAlias]) == "string") then
        id = slk.n2i("　" .. modelAlias .. "　")
    else
        id = modelAlias
    end
    must(type(id) == "string")
    return Object(DestructableClass, {
        options = {
            id = id,
            variation = variation,
            modelAlias = modelAlias,
            modelScale = modelScale,
            facing = facing,
            x = x,
            y = y,
            z = z,
        }
    })
end
