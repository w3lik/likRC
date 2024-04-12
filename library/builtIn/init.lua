FRAMEWORK_ID = {
    ["unit_token"] = J.C2I(slk.n2i("LIK_UNIT_TOKEN")),
    ["unit_token_reborn"] = J.C2I(slk.n2i("LIK_UNIT_TOKEN_REBORN")), --- 复活时间圈
    ["item_token"] = J.C2I(slk.n2i("LIK_ITEM_TOKEN")),
    ["ability_zg"] = J.C2I(slk.n2i("LIK_ZG")), -- 扎根技能
    ["ability_invulnerable"] = J.C2I("Avul"), -- 默认无敌技能
    ["ability_locust"] = J.C2I("Aloc"), -- 蝗虫技能
    ["ability_fly"] = J.C2I("Arav"), -- 风暴之鸦技能
    ["ability_invisible"] = J.C2I(slk.n2i("LIK_ABILITY_INVISIBLE")),
    ["japi_delay"] = J.C2I(slk.n2i("LIK_JAPI_DELAY")),
}
FRAMEWORK_ID["avoid"] = {}
FRAMEWORK_ID["avoid"].add = J.C2I(slk.n2i("LIK_ABILITY_AVOID_ADD"))
FRAMEWORK_ID["avoid"].sub = J.C2I(slk.n2i("LIK_ABILITY_AVOID_SUB"))
-- 视野
FRAMEWORK_ID["sight"] = { add = {}, sub = {} }
FRAMEWORK_ID["sight_gradient"] = {}
local sights = { 1, 2, 3, 4, 5 }
local si = 1
while (si <= 1000) do
    for _, v in ipairs(sights) do
        v = math.floor(v * si)
        table.insert(FRAMEWORK_ID["sight_gradient"], v)
        FRAMEWORK_ID["sight"].add[v] = J.C2I(slk.n2i("LIK_ABILITY_SIGHT_ADD_" .. v))
        FRAMEWORK_ID["sight"].sub[v] = J.C2I(slk.n2i("LIK_ABILITY_SIGHT_SUB_" .. v))
    end
    si = si * 10
end
table.sort(FRAMEWORK_ID["sight_gradient"], function(a, b)
    return a > b
end)
-- 反隐
FRAMEWORK_ID["visible"] = {}
for j = 20, 1, -1 do
    local v = math.floor(100 * j)
    table.insert(FRAMEWORK_ID["visible"], { v, J.C2I(slk.n2i("LIK_ABILITY_VISIBLE_" .. v)) })
end

function FRAMEWORK_INIT()

    FRAMEWORK_VOICE_INIT()

    --- 只支持自定义UI
    japi.EnableWideScreen(true)
    japi.LoadToc("UI\\framework.toc")
    if (Game():hideInterface()) then
        japi.FrameHideInterface()
        japi.FrameEditBlackBorders(0, 0)
    end

    --- 预读技能
    local upr = J.Globals["prevReadToken"]
    for _, v in ipairs(FRAMEWORK_ID["sight_gradient"]) do
        J.UnitAddAbility(upr, FRAMEWORK_ID["sight"].add[v])
        J.UnitAddAbility(upr, FRAMEWORK_ID["sight"].sub[v])
        J.UnitRemoveAbility(upr, FRAMEWORK_ID["sight"].add[v])
        J.UnitRemoveAbility(upr, FRAMEWORK_ID["sight"].sub[v])
    end
    J.RemoveUnit(upr)
    J.handleUnRef(upr)

    --- view
    view._init()

    --- 默认区域
    local wb = J.GetWorldBounds()
    J.handleRef(wb)
    local w = J.GetRectMaxX(wb) - J.GetRectMinX(wb)
    local h = J.GetRectMaxY(wb) - J.GetRectMinY(wb)
    local x = J.GetRectCenterX(wb)
    local y = J.GetRectCenterY(wb)
    RegionWorld = Region("world", "square", x, y, w, h)
    RegionWorld._handle = wb

    w = (J.GetCameraBoundMaxX() + J.GetCameraMargin(CAMERA_MARGIN_RIGHT)) - (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT))
    h = (J.GetCameraBoundMaxY() + J.GetCameraMargin(CAMERA_MARGIN_TOP)) - (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    x = (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT)) + w / 2
    y = (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM)) + h / 2
    RegionPlayable = Region("playable", "square", x, y, w, h)

    w = J.GetCameraBoundMaxX() - J.GetCameraBoundMinX()
    h = J.GetCameraBoundMaxY() - J.GetCameraBoundMinY()
    x = J.GetCameraBoundMinX() + w / 2
    y = J.GetCameraBoundMinY() + h / 2
    RegionCamera = Region("camera", "square", x, y, w, h)

    --- Z
    local xMax = RegionWorld:xMax()
    local yMax = RegionWorld:yMax()
    local loc = J.Location(0, 0)
    J.handleRef(loc)
    x = RegionWorld:xMin()
    while (x < xMax) do
        y = RegionWorld:yMin()
        while (y < yMax) do
            J.MoveLocation(loc, x, y)
            local z = J.GetLocationZ(loc)
            local xi = math.floor(x / J.JapiEx["_ZI"])
            local yi = math.floor(y / J.JapiEx["_ZI"])
            local zi = math.ceil(z)
            if (zi ~= 0) then
                if (J.JapiEx["_Z"][xi] == nil) then
                    J.JapiEx["_Z"][xi] = {}
                end
                J.JapiEx["_Z"][xi][yi] = zi
            end
            z = nil
            y = y + J.JapiEx["_ZI"]
        end
        x = x + J.JapiEx["_ZI"]
    end
    J.RemoveLocation(loc)
    J.handleUnRef(loc)

    --- 游戏UI
    ---@type Frame
    FrameGameUI = Frame("UI_GAME", japi.GetGameUI(), nil)

    --- 玩家初始化
    PlayerAggressive = Player(PLAYER_NEUTRAL_AGGRESSIVE + 1)
    PlayerVictim = Player(PLAYER_NEUTRAL_VICTIM + 1)
    PlayerExtra = Player(PLAYER_NEUTRAL_EXTRA + 1)
    PlayerPassive = Player(PLAYER_NEUTRAL_PASSIVE + 1)
    for i = 1, BJ_MAX_PLAYER_SLOTS, 1 do Player(i) end

    --- 音乐
    Bgm()

    --- 镜头
    Camera()

    --- JAPI Refresh 初始化
    J.JapiEx["_Refresh"] = Array()

    --- IsTyping
    keyboard.onRelease(KEYBOARD["Enter"], "IsTyping", function(evtData)
        local pi = evtData.triggerPlayer:index()
        J.JapiEx["_IsTyping"][pi] = ((J.JapiEx["_IsTyping"][pi] or false) == false)
    end)
    keyboard.onRelease(KEYBOARD["Esc"], "IsTyping", function(evtData)
        local pi = evtData.triggerPlayer:index()
        if (J.JapiEx["_IsTyping"][pi] == true) then
            J.JapiEx["_IsTyping"][pi] = false
        end
    end)
    mouse.onLeftRelease("IsTyping", function(evtData)
        local pi = evtData.triggerPlayer:index()
        if (J.JapiEx["_IsTyping"][pi] == true) then
            J.JapiEx["_IsTyping"][pi] = false
        end
    end)

    --- 异步随机池
    for i = 1, BJ_MAX_PLAYER_SLOTS do
        async._rPool.d[i] = {}
        async._rPool.i[i] = {}
    end

    event.trigger(Game(), EVENT.Game.Init)
    event.unregister(Game(), EVENT.Game.Init)

    ---@param enumObj UIKit
    Group():forEach(UIKitClass, nil, function(enumObj)
        enumObj:setup()
    end)

    --- UI - tooltips
    for i = 0, 3 do
        FrameTooltips(i)
    end

    --- 初始化指针
    Cursor()

    --- 地形可破坏物
    local g = Group():data(DestructableClass)
    J.EnumDestructablesInRect(RegionWorld:handle(), nil, function()
        local enum = J.GetEnumDestructable()
        g:set(tostring(enum), enum)
        event.pool(destructable._evtDead, function(tgr)
            J.TriggerRegisterDeathEvent(tgr, enum)
        end)
    end)

end

--- 游戏开始
Game():onEvent(EVENT.Game.Start, "gameStart_", function()

    Game():prop("isStarted", true)

    --- 全局时钟
    local t = J.CreateTimer()
    J.handleRef(t)
    J.TimerStart(t, 0.01, true, time.clock)

    --- 鼠标
    mouse._init()

    --- 键盘
    keyboard._init()

    ---@param enumObj UIKit
    Group():forEach(UIKitClass, nil, function(enumObj)
        enumObj:start()
    end)

    --- JAPI Refresh 初始化
    J.Japi["DzFrameSetUpdateCallbackByCode"](function()
        async.call(PlayerLocal(), function()
            J.JapiEx["_Refresh"]:forEach(function(_, call)
                J.Promise(call)
            end)
        end)
    end)

    --- 默认游戏同步操作
    sync.receive("G_GAME_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "ability_effective") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = i2o(abId)
            if (isClass(ab, AbilityClass)) then
                ab:effective()
            end
        elseif (command == "ability_effective_u") then
            local abId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            ---@type Ability
            local ab = i2o(abId)
            local au = i2o(uId)
            if (isClass(ab, AbilityClass) and isClass(au, UnitClass)) then
                ab:effective({ targetUnit = au })
            end
        elseif (command == "ability_effective_xyz") then
            local abId = syncData.transferData[2]
            local tx = tonumber(syncData.transferData[3])
            local ty = tonumber(syncData.transferData[4])
            local tz = tonumber(syncData.transferData[5])
            if (tx == nil or ty == nil or tz == nil) then
                return
            end
            ---@type Ability
            local ab = i2o(abId)
            if (isClass(ab, AbilityClass)) then
                ab:effective({ targetX = tx, targetY = ty, targetZ = tz })
            end
        elseif (command == "ability_level_up") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = i2o(abId)
            if (isClass(ab, AbilityClass)) then
                if (ab:level() < ab:levelMax()) then
                    local bu = ab:bindUnit()
                    if (isClass(bu, UnitClass)) then
                        ab:bindUnit():abilityPoint('-=' .. ab:levelUpNeedPoint())
                        ab:level('+=1')
                    end
                end
            end
        elseif (command == "item_pawn") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                it:pawn()
            end
        elseif (command == "item_drop") then
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                it:drop(mx, my)
            end
        elseif (command == "item_drop_cursor") then
            async.call(syncPlayer, function()
                Cursor():followStop()
            end)
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                local eff
                if (syncPlayer:handle() == J.Common["GetLocalPlayer"]()) then
                    eff = 'UI\\Feedback\\Confirmation\\Confirmation.mdl'
                else
                    eff = ''
                end
                Effect(eff, mx, my, 2 + japi.Z(mx, my), 1)
                it:drop(mx, my)
            end
        elseif (command == "item_deliver_cursor") then
            async.call(syncPlayer, function()
                Cursor():followStop()
            end)
            local itId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            ---@type Item
            local it = i2o(itId)
            ---@type Unit
            local u = i2o(uId)
            if (isClass(it, ItemClass) and isClass(u, UnitClass)) then
                if (u:isAlive()) then
                    local mx, my = u:x(), u:y()
                    local eff
                    if (syncPlayer:handle() == J.Common["GetLocalPlayer"]()) then
                        eff = 'UI\\Feedback\\Confirmation\\Confirmation.mdl'
                    else
                        eff = ''
                    end
                    Effect(eff, mx, my, 2 + japi.Z(mx, my), 1)
                    it:deliver(u)
                end
            end
        elseif (command == "item_to_warehouse") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:selection():itemSlot():remove(it:itemSlotIndex())
                syncPlayer:warehouseSlot():insert(it)
                audio(Vcm("war3_HeroDropItem1"), syncPlayer)
            end
        elseif (command == "warehouse_to_item") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isClass(it, ItemClass)) then
                syncPlayer:warehouseSlot():remove(it:warehouseSlotIndex())
                syncPlayer:selection():itemSlot():insert(it)
                audio(Vcm("war3_PickUpItem"), syncPlayer)
            end
        elseif (command == "camera_lock") then
            local aid = tostring(syncData.transferData[2])
            local tx = tonumber(syncData.transferData[3])
            local ty = tonumber(syncData.transferData[4])
            local lt = Camera():prop("lockTokens")
            local tu = lt[aid]
            if (type(tu) == "number") then
                J.SetUnitPosition(tu, tx, ty)
                async.call(Player(tonumber(aid), function()
                    J.SetCameraTargetController(tu, 0, 0, false)
                end))
            end
        end
    end)

end)