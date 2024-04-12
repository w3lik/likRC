---@class datum 数据
datum = datum or {}

--- 比较两个数据是否相同
---@param data1 table array
---@param data2 table array
---@return boolean
function datum.equal(data1, data2)
    if (data1 == nil and data2 == nil) then
        return true
    end
    if (data1 == nil or data2 == nil) then
        return false
    end
    if (type(data1) ~= type(data2)) then
        return false
    end
    if (type(data1) == "table") then
        return table.equal(data1, data2)
    end
    return data1 == data2
end

--- 返回一个key<string>和function
--- 当复合参数key不存在时，key默认为default
--- 当func不存在时，为nil
---@vararg string|function
---@return string,function|nil
function datum.keyFunc(...)
    local data = { ... }
    local key = "default"
    if (type(data[1]) == "string") then
        key = data[1]
        table.remove(data, 1)
    end
    return key, table.unpack(data)
end

--- 三目值
---@param bool boolean 当有且仅有等于true时返回tVal，否则返回fVal
---@param tVal any True值
---@param fVal any False值
---@return any
function datum.ternary(bool, tVal, fVal)
    if (bool == true) then
        return tVal
    else
        return fVal
    end
end