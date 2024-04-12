---@class Cursor:CursorClass
---@return Cursor|nil
function Cursor()
    return Object(CursorClass, {
        protect = true,
        static = '_',
    })
end
