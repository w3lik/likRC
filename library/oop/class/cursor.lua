---@class CursorClass:Class
local class = Class(CursorClass)

---@private
function class:construct()
    J.EnableSelect(true, false)
    FrameBackdrop("cCursorFollow", FrameGameUI):show(false)
    FrameBackdrop("cCursorPointer", FrameGameUI):adaptive(true):size(0.01, 0.01)
    self:prop("childArea", Image("Framework\\ui\\nil.tga", 16, 16):show(false))
    self:prop("childSelection", Image("ReplaceableTextures\\Selection\\SelectionCircleLarge.blp", 72, 72):show(false))
    self:prop("sizeRate", 0)
    self:prop("dragging", false)
    self:prop("texture", {
        aim = {
            alpha = 255,
            width = 0.035,
            height = 0.035,
            normal = "Framework\\ui\\cursorAimWhite.tga",
            positive = "Framework\\ui\\cursorAimGreen.tga",
            negative = "Framework\\ui\\cursorAimRed.tga",
            neutral = "Framework\\ui\\cursorAimGold.tga",
        },
        square = {
            alpha = 150,
            positive = TEAM_COLOR_BLP_LIGHT_BLUE,
            negative = TEAM_COLOR_BLP_RED,
        },
    })
    ---@param under Unit|Item
    self:prop("tooltips", function(under, x, y)
        if (under ~= nil and under:owner() ~= PlayerLocal() and false == under:isEnemy(PlayerLocal())) then
            local tips = {}
            if (isClass(under, UnitClass)) then
                table.insert(tips, under:name())
                if (under:level() > 0) then
                    table.insert(tips, "Lv " .. under:level())
                end
            elseif (isClass(under, ItemClass)) then
                table.insert(tips, under:name())
                if (under:level() > 0) then
                    table.insert(tips, "Lv " .. under:level())
                end
            end
            FrameTooltips(0)
                :relation(FRAME_ALIGN_BOTTOM, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, x, y)
                :content({ tips = table.concat(tips, '|n') })
                :show(true)
            return
        end
        FrameTooltips(0):show(false)
    end)
    -- 指针跟踪
    japi.Refresh("LIK_CursorPointer", function()
        if (false == japi.IsWindowActive()) then
            return
        end
        local p = PlayerLocal()
        local conf = self:texture()
        local rx, ry = japi.MouseRX(), japi.MouseRY()
        local drx = japi.FrameDisAdaptive(rx)
        local _texture, _alpha, _width, _height, _align
        local _isFlashing = false
        ---@type Ability
        local ab = self:prop("ability")
        local isSafe = self:isSafe(rx, ry)
        local childArea = self:childArea()
        if (isClass(ab, AbilityClass) == false or isSafe ~= true) then
            childArea:position(0, 0)
            childArea:show(false)
        end
        ---@type Unit|Item
        local under = h2o(japi.GetUnitUnderMouse())
        if (false == inClass(under, UnitClass, ItemClass)) then
            under = nil
        else
            if (false == under:isAlive()) then
                under = nil
            else
                if (under:isEnemy(p)) then
                    _isFlashing = true
                end
            end
        end
        if (rx < 0.004 or rx > 0.796 or ry < 0.004 or ry >= 0.596) then
            _alpha = 0
            _isFlashing = false
        else
            if (self:dragging()) then
                -- 拖拽
                if (type(conf.drag) == "table") then
                    _texture = conf.drag.normal
                    _alpha = conf.drag.alpha
                    _width = conf.drag.width
                    _height = conf.drag.height
                    _align = FRAME_ALIGN_CENTER
                end
            elseif (isClass(ab, AbilityClass)) then
                local tt = ab:targetType()
                local bu = ab:bindUnit()
                if (ab:isProhibiting() or ab:coolDownRemain() > 0 or isClass(ab:bindUnit(), UnitClass) == false) then
                    self:abilityStop()
                    _alpha = 0
                else
                    local tx = japi.GetMouseTerrainX()
                    local ty = japi.GetMouseTerrainY()
                    if (tt == ABILITY_TARGET_TYPE.tag_unit or tt == ABILITY_TARGET_TYPE.tag_loc) then
                        childArea:show(false)
                        local isBan = bu:isInterrupt() or bu:isPause() or bu:isAbilityChantCasting() or bu:isAbilityKeepCasting()
                        _alpha = conf.aim.alpha
                        _texture = conf.aim.normal
                        _width = conf.aim.width
                        _height = conf.aim.height
                        _align = FRAME_ALIGN_CENTER
                        if (isBan) then
                            _alpha = math.ceil(_alpha / 2)
                        end
                        local curAimClosest = self:prop("curAimClosest")
                        if (isClass(curAimClosest, UnitClass) and curAimClosest ~= under) then
                            J.SetUnitVertexColor(curAimClosest:handle(), table.unpack(curAimClosest:rgba()))
                        end
                        if (isClass(under, UnitClass) and ab:isCastTarget(under)) then
                            local red = 255
                            local green = 255
                            local blue = 255
                            if (under:owner():isNeutral()) then
                                green = 230
                                blue = 0
                                _texture = conf.aim.neutral
                            elseif (under:isEnemy(p)) then
                                green = 0
                                blue = 0
                                _texture = conf.aim.negative
                            elseif (under:isAlly(p)) then
                                red = 127
                                blue = 0
                                _texture = conf.aim.positive
                            end
                            if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                J.SetUnitVertexColor(under:handle(), red, green, blue, under:rgba()[4] or 255)
                            end
                            self:prop("curAimClosest", under)
                        end
                    elseif (tt == ABILITY_TARGET_TYPE.tag_circle) then
                        _alpha = 0
                        _isFlashing = false
                        local castRadius = ab:castRadius()
                        local temp = conf.circle
                        if (temp == nil) then
                            local skin = p:skin()
                            if (skin ~= RACE_HUMAN_NAME and skin ~= RACE_ORC_NAME and skin ~= RACE_NIGHTELF_NAME and skin ~= RACE_UNDEAD_NAME) then
                                skin = p:race()
                            end
                            if (RACE_SELECTION_SPELL_AREA_OF_EFFECT[skin]) then
                                temp = {
                                    alpha = 255,
                                    positive = RACE_SELECTION_SPELL_AREA_OF_EFFECT[skin],
                                    negative = nil,
                                }
                            else
                                temp = {
                                    alpha = 255,
                                    positive = "ReplaceableTextures\\Selection\\SpellAreaOfEffect.blp",
                                    negative = nil,
                                }
                            end
                        end
                        local sizeRate = self:prop("sizeRate")
                        local curSize = self:prop("curSize")
                        if (sizeRate <= 0 or curSize == nil or curSize == castRadius) then
                            curSize = castRadius
                        elseif (curSize < castRadius) then
                            curSize = math.min(castRadius, curSize + sizeRate)
                        elseif (curSize > castRadius) then
                            curSize = math.max(castRadius, curSize - sizeRate)
                        end
                        self:prop("curSize", curSize)
                        local prevUnit = self:prop("curUnits")
                        local newUnits = Group():catch(UnitClass, {
                            limit = 30,
                            circle = {
                                x = tx,
                                y = ty,
                                radius = castRadius,
                            },
                            ---@param enumUnit Unit
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end
                        })
                        local renderAllow = {}
                        for _, u in ipairs(newUnits) do
                            renderAllow[u:id()] = true
                        end
                        if (type(prevUnit) == "table") then
                            for _, u in ipairs(prevUnit) do
                                if (renderAllow[u:id()] == nil) then
                                    J.SetUnitVertexColor(u:handle(), table.unpack(u:rgba()))
                                end
                            end
                        end
                        local texture
                        if (ab:isBanCursor({ x = tx, y = ty, radius = curSize, units = newUnits })) then
                            texture = temp.negative or temp.positive
                        else
                            texture = temp.positive
                        end
                        self:prop("curUnits", newUnits)
                        if (#newUnits > 0) then
                            for _, ru in ipairs(newUnits) do
                                local red = 255
                                local green = 255
                                local blue = 255
                                if (ru:owner():isNeutral()) then
                                    green = 230
                                    blue = 0
                                elseif (ru:isEnemy(p)) then
                                    green = 0
                                    blue = 0
                                elseif (ru:isAlly(p)) then
                                    red = 127
                                    blue = 0
                                end
                                if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                    J.SetUnitVertexColor(ru:handle(), red, green, blue, ru:rgba()[4] or 255)
                                end
                            end
                            newUnits = nil
                        end
                        childArea:rgba(255, 255, 255, temp.alpha)
                        childArea:texture(texture)
                        childArea:size(curSize * 2, curSize * 2)
                        childArea:position(tx, ty)
                        childArea:show(isSafe and true)
                    elseif (tt == ABILITY_TARGET_TYPE.tag_square) then
                        _alpha = 0
                        _isFlashing = false
                        local castWidth = ab:castWidth()
                        local castHeight = ab:castHeight()
                        local sizeRate = self:prop("sizeRate")
                        local w_h = castWidth / castHeight
                        local curWidth = 0
                        local curHeight = self:prop("curSize")
                        if (sizeRate <= 0 or curHeight == nil or curHeight == castHeight) then
                            curHeight = castHeight
                            curWidth = castWidth
                        elseif (curHeight < castHeight) then
                            curHeight = math.min(castHeight, curHeight + sizeRate)
                            curWidth = w_h * curHeight
                        elseif (curHeight > castHeight) then
                            curHeight = math.max(castHeight, curHeight - sizeRate)
                            curWidth = w_h * curHeight
                        end
                        self:prop("curSize", curHeight)
                        local prevUnit = self:prop("curUnits")
                        local newUnits = Group():catch(UnitClass, {
                            limit = 30,
                            square = {
                                x = tx,
                                y = ty,
                                width = curWidth,
                                height = curHeight,
                            },
                            ---@param enumUnit Unit
                            filter = function(enumUnit)
                                return ab:isCastTarget(enumUnit)
                            end
                        })
                        local renderAllow = {}
                        for _, u in ipairs(newUnits) do
                            renderAllow[u:id()] = true
                        end
                        if (type(prevUnit) == "table") then
                            for _, u in ipairs(prevUnit) do
                                if (renderAllow[u:id()] == nil) then
                                    J.SetUnitVertexColor(u:handle(), table.unpack(u:rgba()))
                                end
                            end
                        end
                        local texture
                        if (ab:isBanCursor({ x = tx, y = ty, width = curWidth, height = curHeight, units = newUnits })) then
                            texture = conf.square.negative or conf.square.positive
                        else
                            texture = conf.square.positive
                        end
                        self:prop("curUnits", newUnits)
                        if (#newUnits > 0) then
                            for _, ru in ipairs(newUnits) do
                                local red = 255
                                local green = 255
                                local blue = 255
                                if (ru:owner():isNeutral()) then
                                    green = 230
                                    blue = 0
                                elseif (ru:isEnemy(p)) then
                                    green = 0
                                    blue = 0
                                    if (conf.square.negative) then
                                        texture = conf.square.negative
                                    end
                                elseif (ru:isAlly(p)) then
                                    red = 127
                                    blue = 0
                                end
                                if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                    J.SetUnitVertexColor(ru:handle(), red, green, blue, ru:rgba()[4] or 255)
                                end
                            end
                            newUnits = nil
                        end
                        childArea:rgba(255, 255, 255, conf.square.alpha)
                        childArea:texture(texture)
                        childArea:size(curWidth, curHeight)
                        childArea:position(tx, ty)
                        childArea:show(isSafe and true)
                    end
                end
            else
                _alpha = 0
            end
        end
        -- 修改处理
        if (_texture) then
            self:childPointer():texture(_texture)
        end
        local csfi = 10
        local half = math.ceil((_alpha or 255) / 3)
        local csf = self:prop("csFlashing") or 0
        if (_isFlashing) then
            local cst = self:prop("csFlashTo") or false
            if (cst ~= true) then
                csf = csf + csfi
                if (csf >= 0) then
                    csf = 0
                    self:prop("csFlashTo", true)
                end
            else
                csf = csf - csfi
                if (csf < -half) then
                    csf = -half
                    self:prop("csFlashTo", false)
                end
            end
            self:prop("csFlashing", csf)
        else
            self:clear("csFlashing")
            self:clear("csFlashTo")
        end
        if (_alpha) then
            self:childPointer():alpha(_alpha + csf)
        end
        if (_width and _height) then
            self:childPointer():size(_width, _height)
        end
        if (_align) then
            self:childPointer():relation(_align, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, drx, ry)
        end
        self:tooltips()(under, drx, ry + 0.024)
    end)
    japi.Refresh("LIK_CursorSelection", function()
        if (false == japi.IsWindowActive()) then
            return
        end
        local p = PlayerLocal()
        local o = p:selection()
        local sel = self:prop("childSelection")
        if ((isClass(o, UnitClass) or isClass(o, ItemClass)) and o:isAlive() and false == o:isLocust()) then
            local s = 72 * o:scale()
            if (s > 0) then
                ---@type Image
                sel:size(s, s)
                sel:position(o:x(), o:y())
                if (o:owner() == p) then
                    sel:rgba(0, 255, 0, 255)
                elseif (o:isEnemy(p)) then
                    sel:rgba(255, 0, 0, 255)
                else
                    sel:rgba(255, 255, 0, 255)
                end
                sel:show(true)
            else
                sel:show(false)
            end
        else
            sel:show(false)
        end
    end)
end

--- 子跟踪贴图对象
---@return FrameBackdrop
function class:childFollow()
    return FrameBackdrop("cCursorFollow")
end

--- 子指针图对象
---@return FrameBackdrop
function class:childPointer()
    return FrameBackdrop("cCursorPointer")
end

--- 子区域图对象
---@return Image
function class:childArea()
    return self:prop("childArea")
end

--- UI kit配置
--- 虽然指针不是Frame对象，但可以为指针配置一个uiKit
--- 方便写于UI时，引入资源
--- 而挂靠于UI也是一种比较舒适的写法
---@param modify nil|string
---@return self|string
function class:uiKit(modify)
    return self:prop("uiKit", modify)
end

--- 设置各种贴图
--- 【aim瞄准准星】必须准备4个贴图：常规、正面、负面、中立（常见：白、绿、红、金）
--- 【drag拖拽准星】必须准备1个贴图：常规（常见：灰）
--- 【circle圆形选区】必须准备2个贴图：正面、负面（常见：白、红）当为nil时采用魔兽原生4族
--- 【square方形选区】必须准备2个贴图：正面、负面（常见：白、红）当为nil时采用魔兽原生建造贴图
---@alias noteCursorTextureAim {alpha:number,width:number,height:number,normal:string,positive:string,negative:string,neutral:string}
---@alias noteCursorTextureDrag {alpha:number,width:number,height:number,normal:string}
---@alias noteCursorTextureCircle {alpha:number,positive:string,negative:string}
---@alias noteCursorTextureSquare {alpha:number,positive:string,negative:string}
---@alias noteCursorTexture {aim:noteCursorTextureAim,drag:noteCursorTextureDrag,circle:noteCursorTextureCircle,square:noteCursorTextureSquare}
---@param modify nil|noteCursorTexture
---@return self|noteCursorTexture
function class:texture(modify)
    ---@type noteCursorTexture
    local data
    if (type(modify) == "table") then
        data = self:prop("texture")
        local aim = modify.aim
        if (type(aim) == "table" and aim.normal and aim.positive and aim.negative and aim.neutral) then
            data.aim = data.aim or {}
            data.aim.alpha = aim.alpha or data.aim.alpha or 255
            data.aim.width = aim.width or data.aim.width or 0.03
            data.aim.height = aim.height or data.aim.height or 0.03
            data.aim.normal = AUIKit(self:uiKit(), aim.normal, "tga")
            data.aim.positive = AUIKit(self:uiKit(), aim.positive, "tga")
            data.aim.negative = AUIKit(self:uiKit(), aim.negative, "tga")
            data.aim.neutral = AUIKit(self:uiKit(), aim.neutral, "tga")
        end
        local drag = modify.drag
        if (type(drag) == "table" and drag.normal) then
            data.drag = data.drag or {}
            data.drag.alpha = drag.alpha or data.drag.alpha or 255
            data.drag.width = drag.width or data.drag.width or 0.04
            data.drag.height = drag.height or data.drag.height or 0.04
            data.drag.normal = AUIKit(self:uiKit(), drag.normal, "tga")
        end
        local circle = modify.circle
        if (type(circle) == "table" and circle.positive and circle.negative) then
            data.circle = data.circle or {}
            data.circle.alpha = circle.alpha or data.circle.alpha or 255
            data.circle.positive = AUIKit(self:uiKit(), circle.positive, "tga")
            data.circle.negative = AUIKit(self:uiKit(), circle.negative, "tga")
        end
        local square = modify.square
        if (type(square) == "table" and square.positive and square.negative) then
            data.square = data.square or {}
            data.square.alpha = square.alpha or data.square.alpha or 255
            data.square.positive = AUIKit(self:uiKit(), square.positive, "tga")
            data.square.negative = AUIKit(self:uiKit(), square.negative, "tga")
        end
    end
    return self:prop("texture", data)
end

--- 尺寸变化量
--- 方形时以高为1做比例替换
--- 默认为-1，即瞬间变化完成
---@param modify number
---@return self|number
function class:sizeRate(modify)
    return self:prop("sizeRate", modify)
end

--- 是否安全区
--- 只有安全区可以显示指针
--- 自动根据 FrameTextBlockClass 对象计算
---@param rx number|nil
---@param ry number|nil
---@return boolean
function class:isSafe(rx, ry)
    local is = true
    rx = rx or japi.MouseRX()
    ry = ry or japi.MouseRY()
    if (rx < 0.02 or rx > 0.78 or ry < 0.02 or ry > 0.58) then
        return false
    end
    local top, bottom = japi.GetFrameBorders()
    if (ry < bottom or ry > (0.8 - top)) then
        return false
    end
    if (Group():count(FrameTextBlockClass) == 0) then
        return is
    end
    ---@param b FrameTextBlockClass
    Group():data(FrameTextBlockClass):forEach(function(_, b)
        if (b:isInner(rx, ry)) then
            is = false
            return false
        end
    end)
    return is
end

--- 指针浮动提示
---@param modify nil|fun(obj:Unit|Item)
---@return self|string
function class:tooltips(modify)
    if (type(modify) == "function") then
        self:prop("tooltips", modify)
        return self
    end
    return self:prop("tooltips")
end

--- 当前引用技能对象
---@param modify Ability|nil
---@return self|Ability
function class:ability(modify)
    if (modify ~= nil) then
        async.must()
        return self:prop("ability", modify)
    end
    return self:prop("ability")
end

--- 停止引用技能对象
---@return void
function class:abilityStop()
    self:prop("ability", false)
end

--- 调用技能对象
---@param whichAbility Ability
---@return void
function class:abilityQuote(whichAbility)
    if (self:isFollowing() or self:dragging()) then
        return
    end
    if (isClass(whichAbility, AbilityClass)) then
        local p = PlayerLocal()
        if (table.equal(whichAbility:bindUnit():owner(), p) == false) then
            return
        end
        local tt = whichAbility:targetType()
        if (tt == nil or tt == ABILITY_TARGET_TYPE.pas) then
            return
        end
        if (whichAbility:isProhibiting() == true) then
            p:alert(colour.hex(colour.gold, whichAbility:prohibitReason()))
            return
        end
        if (whichAbility:bindUnit():isInterrupt() or whichAbility:bindUnit():isPause()) then
            p:alert(colour.hex(colour.red, "无法行动"))
            return
        end
        if (whichAbility:bindUnit():isAbilityChantCasting() or whichAbility:bindUnit():isAbilityKeepCasting()) then
            p:alert(colour.hex(colour.gold, "施法中"))
            return
        end
        audio(Vcm("war3_MouseClick1"))
        if (tt == ABILITY_TARGET_TYPE.tag_nil) then
            sync.send("G_GAME_SYNC", { "ability_effective", whichAbility:id() })
            return
        elseif (tt == ABILITY_TARGET_TYPE.TAG_U and whichAbility == Cursor():ability()) then
            local u = whichAbility:bindUnit()
            if (whichAbility:isCastTarget(u)) then
                sync.send("G_GAME_SYNC", { "ability_effective_u", whichAbility:id(), whichAbility:bindUnit():id() })
                return
            end
        end
        Cursor():ability(whichAbility)
    end
end

--- 调用物品对象
---@param whichItem Item
---@return void
function class:itemQuote(whichItem)
    if (self:isFollowing() or self:dragging()) then
        return
    end
    if (isClass(whichItem, ItemClass)) then
        if (whichItem:charges() <= 0 and whichItem:consumable()) then
            return
        end
        self:abilityQuote(whichItem:ability())
    end
end

--- 跟踪图层关联对象
---@param modify Object|nil
---@return self|Object
function class:followObj(modify)
    return self:prop("followObj", modify)
end

--- 跟踪图层
---@alias noteFollowData {texture:string,size:table,frame:FrameBackdrop|FrameBackdropTile|FrameButton}
---@alias noteFollowStopFunc fun(stopData:{followObj:Object,...})
---@param obj Object
---@param data noteFollowData
---@param stopFunc noteFollowStopFunc|nil
---@return void
function class:followCall(obj, data, stopFunc)
    async.must()
    if (obj ~= nil) then
        self:prop("followData", data)
        self:prop("followStopFunc", stopFunc)
        self:followObj(obj)
    end
end

--- 停止跟踪图层
---@param stopFunc noteFollowStopFunc|nil
---@return void
function class:followStop(stopFunc)
    if (type(stopFunc) == "function") then
        self:prop("followStopFunc", stopFunc)
    end
    self:followObj(false)
end

--- 拖拽跟踪
---@param modify boolean|nil
---@return self|boolean
function class:dragging(modify)
    return self:prop("dragging", modify)
end

--- 是否跟踪图层中
---@return boolean
function class:isFollowing()
    return nil ~= self:followObj()
end