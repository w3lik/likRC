---@class mbstring 多字节字符串
mbstring = mbstring or {}

--- 获取多字节字符串真实长度
---@param str string
---@return number
function mbstring.len(str)
    local lenInByte = #str
    local width = 0
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        i = i + byteCount -- 重置下一字节的索引
        width = width + 1 -- 字符的个数（长度）
    end
    return width
end

--- 获取多字节字符串视图长度
---@see file variable/font
---@param str string
---@param fontSize number 字体大小,默认10
---@param width number 一个字符占的位置
---@param widthCN number 一个汉字占的位置
---@return number
function mbstring.viewWidth(str, fontSize, width, widthCN)
    if (type(str) == "number") then
        str = tostring(str)
    end
    if (type(str) ~= "string") then
        return 0
    end
    local cff = string.subCount(str, "|cff") * 12
    local l1 = string.len(str) - cff
    local l2 = mbstring.len(str) - cff
    local cn = (l1 - l2) / 2
    local xn = l2 - cn
    local fv = FONT_VIEW[FRAMEWORK_FONT] or FONT_VIEW.default
    fontSize = (fontSize or 10) * 0.001
    width = width or (fontSize * fv.cr)
    widthCN = widthCN or (fontSize * fv.zh)
    return xn * width + cn * widthCN
end

--- 获取字视图高度
---@see file variable/font
---@param line number 行数
---@param fontSize number 字体大小,默认10
---@param height number 一个字符占的高度
---@return number
function mbstring.viewHeight(line, fontSize, height)
    if (line <= 0) then
        return 0
    end
    local fv = FONT_VIEW[FRAMEWORK_FONT] or FONT_VIEW.default
    fontSize = (fontSize or 10) * 0.001
    height = height or (fontSize * fv.h)
    return line * height
end

--- 多字节字符串截取
---@param s string
---@param i number
---@param j number
---@return string
function mbstring.sub(s, i, j)
    if (type(i) ~= "number") then
        return s
    end
    if (i < 1) then
        return ''
    end
    if (type(j) == "number") then
        if (j < i) then
            return ''
        end
    else
        j = nil
    end
    local lenInByte = #s
    if (lenInByte <= 0) then
        return ''
    end
    local count = 0
    local s1, s2 = 0, 0
    local k = 1
    while (k <= lenInByte) do
        local curByte = string.byte(s, k)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        count = count + 1 -- 字符的个数（长度）
        if (count == i) then
            s1 = k
        end
        k = k + byteCount -- 下一字节的索引
        if (s1 ~= 0) then
            if (j == nil) then
                s2 = lenInByte
                break
            elseif (j == count) then
                s2 = k - 1
                break
            end
        end
    end
    return string.sub(s, s1, s2)
end

--- 分隔多字节字符串
---@param str string
---@param size number 每隔[size]个字切一次
---@return string[]
function mbstring.split(str, size)
    local sp = {}
    local lenInByte = #str
    if (lenInByte <= 0) then
        return sp
    end
    size = size or 1
    local count = 0
    local i0 = 1
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        count = count + 1 -- 阶段字符的个数（长度）
        i = i + byteCount -- 下一字节的索引
        if (count >= size) then
            table.insert(sp, string.sub(str, i0, i - 1))
            i0 = i
            count = 0
        elseif (i > lenInByte) then
            table.insert(sp, string.sub(str, i0, lenInByte))
        end
    end
    return sp
end