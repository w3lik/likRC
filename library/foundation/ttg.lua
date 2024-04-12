---@class ttg
ttg = ttg or {}

ttg._max = 100
ttg._count = ttg._count or 0
ttg._char = ttg._char or {}
ttg._site = ttg._site or {}

--- 注册字符对应的模型和位宽
---@param char string
---@param modelAlias string
---@param bit number
function ttg.char(char, modelAlias, bit)
    ttg._char[tostring(char)] = { modelAlias, bit }
end

--- 字串漂浮字
---@see str number 漂浮字信息
---@see width number 字间
---@see speed number 速度
---@see size number 尺寸
---@see scale {number,number} 缩放变化
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see height number 上升高度
---@see duration number 持续时间
---@param options {str:number,width:number,speed:number,size:number,scale:{number,number},x:number,y:number,z:number,height:number,duration:number}
function ttg.word(options)
    if (ttg._count > ttg._max) then
        return
    end
    local str = tostring(options.str) or ""
    local width = options.width or 10
    local speed = options.speed or 1
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local height = options.height or 200
    local duration = options.duration or 0.5
    local frequency = 0.05
    local spd = height / (duration / frequency)
    --
    local words = mbstring.split(str, 1)
    if (#words > 0) then
        x = math.floor(x)
        y = math.floor(y)
        local site = x .. y
        if (ttg._site[site] == nil) then
            ttg._site[site] = {}
        end
        if (ttg._site[site][str] == nil) then
            ttg._site[site][str] = true
            time.setTimeout(0.2, function()
                ttg._site[site][str] = nil
            end)
            ttg._count = ttg._count + 1
            local xs = {}
            local x0 = x
            for i, w in ipairs(words) do
                must(ttg._char[w] ~= nil)
                local bit = ttg._char[w][2]
                xs[i] = x0
                x0 = xs[i] + width * bit
            end
            ---@type Effect[]
            local effs = {}
            for i, w in ipairs(words) do
                local mdl = ttg._char[w][1]
                effs[i] = Effect(mdl, xs[i], y, z, -1)
                effs[i]:speed(speed)
                effs[i]:size(size)
            end
            local dur = 0
            local h = z
            local ani = 0
            time.setInterval(frequency, function(curTimer)
                dur = dur + frequency
                if (dur >= duration) then
                    destroy(curTimer)
                    for i, _ in ipairs(words) do
                        destroy(effs[i])
                    end
                    ttg._count = ttg._count - 1
                    return
                end
                h = h + spd
                local siz
                if (scale[1] ~= 1 or scale[2] ~= 1) then
                    ani = ani + frequency
                    if (ani >= 0.1) then
                        ani = 0
                        if (dur < duration * 0.5) then
                            siz = scale[1]
                            width = width * siz
                        else
                            siz = scale[2]
                            width = width * siz
                        end
                    end
                end
                for i, _ in ipairs(words) do
                    effs[i]:position(xs[i], y, h)
                    if (siz ~= nil) then
                        effs[i]:size(siz)
                    end
                end
            end)
        end
    end
end


-- 模型漂浮字
---@see model string 模型路径
---@see speed number 速度
---@see size number 尺寸
---@see scale number 缩放
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see offset number 偏移
---@see height number 上升高度
---@see duration number 持续时间
---@param options {model:string,speed:number,size:number,scale:number,x:number,y:number,z:number,offset:number,height:number,duration:number}
function ttg.model(options)
    local model = AModel(options.model)
    if (model == nil) then
        return
    end
    if (ttg._count > ttg._max) then
        return
    end
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local offset = math.floor(options.offset or 0)
    local height = options.height or 1000
    local speed = options.speed or 1
    local duration = options.duration or 1
    local frequency = 0.05
    x = math.floor(x)
    y = math.floor(y)
    local site = x .. y
    if (ttg._site[site] == nil) then
        ttg._site[site] = {}
    end
    if (ttg._site[site][model] == nil) then
        ttg._site[site][model] = true
        time.setTimeout(duration, function()
            ttg._site[site][model] = nil
        end)
        ttg._count = ttg._count + 1
        local spd = height / (duration / frequency)
        local eff = Effect(model, x, y, z, -1)
        eff:speed(speed)
        eff:size(size)
        local dur = 0
        local h = z
        local randX = 0
        local randY = 0
        if (offset ~= 0) then
            randX = math.rand(-offset, offset)
            randY = math.rand(-offset, offset)
        end
        local ani = 0
        time.setInterval(frequency, function(curTimer)
            dur = dur + frequency
            if (dur >= duration) then
                destroy(curTimer)
                destroy(eff)
                ttg._count = ttg._count - 1
                return
            end
            h = h + spd
            local siz
            if (scale[1] ~= 1 or scale[2] ~= 1) then
                ani = ani + frequency
                if (ani >= 0.1) then
                    ani = 0
                    if (dur < duration * 0.5) then
                        siz = scale[1]
                    else
                        siz = scale[2]
                    end
                end
            end
            x = x + randX
            y = y + randY
            eff:position(x, y, h)
            if (siz ~= nil) then
                eff:size(siz)
            end
        end)
    end
end