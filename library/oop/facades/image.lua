---@class Image:ImageClass
---@param texture string
---@param width number
---@param height number
---@return Image|nil
function Image(texture, width, height)
    must(type(texture) == "string")
    must(type(width) == "number")
    if (type(height) ~= "number") then
        height = width
    end
    return Object(ImageClass, {
        options = {
            texture = texture,
            width = width,
            height = height,
        }
    })
end