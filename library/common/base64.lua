---@class base64
base64 = base64 or {}

--- base64编码
---@param source string
---@return string
function base64.encode(source)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local en = ""
    local str = source
    while #str > 0 do
        local bytes_num = 0
        local bf = 0

        for _ = 1, 3 do
            bf = (bf * 256)
            if #str > 0 then
                bf = bf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end
        for _ = 1, (bytes_num + 1) do
            local b64char = math.fmod(math.floor(bf / 262144), 64) + 1
            en = en .. string.sub(chars, b64char, b64char)
            bf = bf * 64
        end

        for _ = 1, (3 - bytes_num) do
            en = en .. "="
        end
    end
    return en
end


-- base64解码
---@param str64 string
---@return string
function base64.decode(str64)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local temp = {}
    for i = 1, 64 do
        temp[string.sub(chars, i, i)] = i
    end
    temp["="] = 0
    local de = ""
    for i = 1, #str64, 4 do
        if i > #str64 then
            break
        end
        local data = 0
        local str_count = 0
        for j = 0, 3 do
            local str1 = string.sub(str64, i + j, i + j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1] - 1
                str_count = str_count + 1
            end
        end
        for j = 16, 0, -8 do
            if str_count > 0 then
                de = de .. string.char(math.floor(data / (2 ^ j)))
                data = math.mod(data, 2 ^ j)
                str_count = str_count - 1
            end
        end
    end
    local last = tonumber(string.byte(de, string.len(de), string.len(de)))
    if last == 0 then
        de = string.sub(de, 1, string.len(de) - 1)
    end
    return de
end