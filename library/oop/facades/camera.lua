---@class Camera:CameraClass
---@return Camera
function Camera()
    return Object(CameraClass, {
        protect = true,
        static = '_',
    })
end