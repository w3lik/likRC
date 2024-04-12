---@class japi JAPI
japi = japi or {}

---@type string[]
japi._tips = {}

---@private
function japi._msg(msg)
    if (japi._tips[msg] == nil) then
        japi._tips[msg] = 1
        if (DEBUGGING) then
            print("JAPI " .. msg)
        else
            echo("JAPI " .. msg)
        end
    end
end

---@private
---@param method string
---@vararg any
---@return any
function japi._exec(method, ...)
    if (type(method) ~= "string") then
        return false
    end
    if (J.Japi == nil) then
        return false
    end
    local call = J.JapiEx[method] or J.Japi[method]
    if (type(call) ~= "function") then
        japi._msg(method .. "_FUNCTION_NOT_EXIST")
        return false
    end
    return call(...)
end

------------------------------------------------------------------------------------------------------------------------

function japi.Map_ChangeStoreItemCoolDown(...)
    return japi._exec("DzAPI_Map_ChangeStoreItemCoolDown", ...)
end

function japi.Map_ChangeStoreItemCount(...)
    return japi._exec("DzAPI_Map_ChangeStoreItemCount", ...)
end

---@return string
function japi.Map_GetActivityData()
    return japi._exec("DzAPI_Map_GetActivityData")
end

--- 获取当前游戏时间
--- 获取创建地图的游戏时间
--- 时间换算为时间戳
---@return number
function japi.Map_GetGameStartTime()
    return japi._exec("DzAPI_Map_GetGameStartTime")
end

--- 获取公会名称
---@param whichPlayer number
---@return string
function japi.Map_GetGuildName(whichPlayer)
    return japi._exec("DzAPI_Map_GetGuildName", whichPlayer)
end

--- 获取公会职责
--- 获取公会职责 Member=10 Admin=20 Leader=30
---@param whichPlayer number
---@return number
function japi.Map_GetGuildRole(whichPlayer)
    return japi._exec("DzAPI_Map_GetGuildRole", whichPlayer)
end

--- 获取天梯等级
--- 取值1~25，青铜V是1级
---@param whichPlayer number
---@return number
function japi.Map_GetLadderLevel(whichPlayer)
    return japi._exec("DzAPI_Map_GetLadderLevel", whichPlayer)
end

--- 获取天梯排名
--- 排名>1000的获取值为0
---@param whichPlayer number
---@return number
function japi.Map_GetLadderRank(whichPlayer)
    return japi._exec("DzAPI_Map_GetLadderRank", whichPlayer)
end

--- 获取全局服务器存档值
---@param key string
---@return number
function japi.Map_GetMapConfig(key)
    return japi._exec("DzAPI_Map_GetMapConfig", key)
end

--- 获取玩家地图等级
--- 获取玩家地图等级【RPG大厅限定】
---@param whichPlayer number
---@return number
function japi.Map_GetMapLevel(whichPlayer)
    return japi._exec("DzAPI_Map_GetMapLevel", whichPlayer)
end

--- 获取玩家地图等级排名
--- 排名>100的获取值为0
---@param whichPlayer number
---@return number
function japi.Map_GetMapLevelRank(whichPlayer)
    return japi._exec("DzAPI_Map_GetMapLevelRank", whichPlayer)
end

--- 获取玩家平台VIP标志
---@param whichPlayer number
---@return number
function japi.Map_GetPlatformVIP(whichPlayer)
    return japi._exec("DzAPI_Map_GetPlatformVIP", whichPlayer)
end

--- 读取公共服务器存档组数据
--- 服务器存档组有100个KEY，每个KEY64个字符长度，可以多张地图读取和保存，使用前先在作者之家服务器存档组设置
---@param whichPlayer number
---@param key string
---@return string
function japi.Map_GetPublicArchive(whichPlayer, key)
    return japi._exec("DzAPI_Map_GetPublicArchive", whichPlayer, key)
end

--- 读取服务器Boss掉落装备类型
---@param whichPlayer number
---@param key string
---@return string
function japi.Map_GetServerArchiveDrop(whichPlayer, key)
    return japi._exec("DzAPI_Map_GetServerArchiveDrop", whichPlayer, key)
end

---@param whichPlayer number
---@param key string
---@return number
function japi.Map_GetServerArchiveEquip(whichPlayer, key)
    return japi._exec("DzAPI_Map_GetServerArchiveEquip", whichPlayer, key)
end

--- 获取服务器存档
---@param whichPlayer number
---@param key string
---@return any|string
function japi.Map_GetServerValue(whichPlayer, key)
    return japi._exec("DzAPI_Map_GetServerValue", whichPlayer, key)
end

---@param whichPlayer number
---@return number
function japi.Map_GetServerValueErrorCode(whichPlayer)
    return japi._exec("DzAPI_Map_GetServerValueErrorCode", whichPlayer)
end

function japi.Map_GetUserID(...)
    return japi._exec("DzAPI_Map_GetUserID", ...)
end

--- 玩家是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer number
---@param key string
---@return boolean
function japi.Map_HasMallItem(whichPlayer, key)
    return japi._exec("DzAPI_Map_HasMallItem", whichPlayer, key)
end

--- 判断是否是蓝V
---@param whichPlayer number
---@return boolean
function japi.Map_IsBlueVIP(whichPlayer)
    return japi._exec("DzAPI_Map_IsBlueVIP", whichPlayer)
end

--- 判断地图是否在RPG天梯
---@return boolean
function japi.Map_IsRPGLadder()
    return japi._exec("DzAPI_Map_IsRPGLadder")
end

--- 判断当前地图是否rpg大厅来的
---@return boolean
function japi.Map_IsRPGLobby()
    return japi._exec("DzAPI_Map_IsRPGLobby")
end

--- 判断是否是红V
---@param whichPlayer number
---@return boolean
function japi.Map_IsRedVIP(whichPlayer)
    return japi._exec("DzAPI_Map_IsRedVIP", whichPlayer)
end

---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_Ladder_SetPlayerStat(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_Ladder_SetPlayerStat", whichPlayer, key, value)
end

--- 天梯提交字符串数据
---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_Ladder_SetStat(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_Ladder_SetStat", whichPlayer, key, value)
end

--- 活动完成
--- 完成平台活动[RPG大厅限定]
---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_MissionComplete(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_MissionComplete", whichPlayer, key, value)
end

--- 触发boss击杀
---@param whichPlayer number
---@param key string
function japi.Map_OrpgTrigger(whichPlayer, key)
    return japi._exec("DzAPI_Map_OrpgTrigger", whichPlayer, key)
end

--- 服务器公共存档组保存
--- 存储服务器存档组，服务器存档组有100个KEY，每个KEY64个字符串长度，使用前请在作者之家服务器存档组进行设置
---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_SavePublicArchive(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_SavePublicArchive", whichPlayer, key, value)
end

--- 保存服务器存档
---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_SaveServerValue(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_SaveServerValue", whichPlayer, key, value)
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
function japi.Map_Stat_SetStat(whichPlayer, key, value)
    return japi._exec("DzAPI_Map_Stat_SetStat", whichPlayer, key, value)
end

--- 平台统计
--- 一般用于统计游戏里某些事件的触发次数，可在作者之家查看。【第二个子key是以后备用暂时不要填】
---@param whichPlayer number
---@param eventKey string
---@param eventType string
---@param value number integer
function japi.Map_Statistics(whichPlayer, eventKey, eventType, value)
    return japi._exec("DzAPI_Map_Statistics", whichPlayer, eventKey, eventType, value)
end

function japi.Map_ToggleStore(...)
    return japi._exec("DzAPI_Map_ToggleStore", ...)
end

function japi.Map_UpdatePlayerHero(...)
    return japi._exec("DzAPI_Map_UpdatePlayerHero", ...)
end

--- 局数消耗商品调用
--- 仅对局数消耗型商品有效
---@param whichPlayer number
---@param key string
function japi.Map_UseConsumablesItem(whichPlayer, key)
    return japi._exec("DzAPI_Map_UseConsumablesItem", whichPlayer, key)
end

--- 获取玩家完整昵称
--- 当不存在时，调试环境返回User#+PlayerIndex，非调试返回空字符串
---@param whichPlayer number
---@return string
function japi.Map_GetPlayerUserName(whichPlayer)
    return japi._exec("DzAPI_Map_GetPlayerUserName", whichPlayer)
end

--- 地图坐标转屏幕相对左下角坐标
---@param x number
---@param y number
---@param z number
---@return number,number
function japi.ConvertWorldPosition(x, y, z)
    return japi._exec("ConvertWorldPosition", x, y, z)
end

--- 新建Frame
--- 名字为fdf文件中的名字，ID默认填0。重复创建同名Frame会导致游戏退出时显示崩溃消息，如需避免可以使用Tag创建
---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.CreateFrame(frame, parent, id)
    return japi._exec("DzCreateFrame", frame, parent, id)
end

--- 新建Frame[Tag]
--- 此处名字可以自定义，类型和模版填写fdf文件中的内容。通过此函数创建的Frame无法获取到子Frame
---@param frameType string
---@param name string
---@param parent number integer
---@param template string
---@param id number integer
---@return number integer frameId
function japi.CreateFrameByTagName(frameType, name, parent, template, id)
    return japi._exec("DzCreateFrameByTagName", frameType, name, parent, template, id) or 0
end

---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.CreateSimpleFrame(frame, parent, id)
    return japi._exec("DzCreateSimpleFrame", frame, parent, id)
end

--- 销毁
--- 销毁一个被重复创建过的Frame会导致游戏崩溃，重复创建同名Frame请使用Tag创建
---@param frameId number integer
function japi.DestroyFrame(frameId)
    return japi._exec("DzDestroyFrame", frameId)
end

--- 设置可破坏物位置
---@param d number destructable
---@param x number
---@param y number
function japi.DestructablePosition(d, x, y)
    return japi._exec("DzDestructablePosition", d, x, y)
end

--- 原生 - 使用宽屏模式
---@param enable boolean
function japi.EnableWideScreen(enable)
    J.JapiEx["_IsWideScreen"] = enable
    return japi._exec("DzEnableWideScreen", enable)
end

--- 异步执行函数
---@param funcName string
function japi.ExecuteFunc(funcName)
    return japi._exec("DzExecuteFunc", funcName)
end

--- 限制鼠标移动，在frame内
---@param frame number integer
---@param enable boolean
function japi.FrameCageMouse(frame, enable)
    return japi._exec("DzFrameCageMouse", frame, enable)
end

--- 清空frame所有锚点
---@param frame number integer
function japi.FrameClearAllPoints(frame)
    return japi._exec("DzFrameClearAllPoints", frame)
end

--- 修改游戏渲染黑边: 上方高度:topHeight,下方高度:bottomHeight
--- 上下加起来不要大于0.6
---@param topHeight number
---@param bottomHeight number
function japi.FrameEditBlackBorders(topHeight, bottomHeight)
    J.JapiEx["_FrameBlackTop"] = topHeight
    J.JapiEx["_FrameBlackBottom"] = bottomHeight
    J.JapiEx["_FrameInnerHeight"] = 0.6 - topHeight - bottomHeight
    return japi._exec("DzFrameEditBlackBorders", topHeight, bottomHeight)
end

--- 获取名字为name的子FrameID:Id"
--- ID默认填0，同名时优先获取最后被创建的。非Simple类的Frame类型都用此函数来获取子Frame
---@param name string
---@param id number integer
---@return number integer
function japi.FrameFindByName(name, id)
    return japi._exec("DzFrameFindByName", name, id)
end

--- 获取Frame的透明度(0-255)
---@param frame number integer
---@return number integer
function japi.FrameGetAlpha(frame)
    return japi._exec("DzFrameGetAlpha", frame)
end

--- 原生 - 玩家聊天信息框
---@return number integer
function japi.FrameGetChatMessage()
    return japi._exec("DzFrameGetChatMessage")
end

--- 原生 - 技能按钮
--- 技能按钮:(row, column)
--- 参考物编中的技能按钮(x,y)坐标
--- (x,y)对应(column,row)反一下
---@param row number integer
---@param column number integer
---@return number integer
function japi.FrameGetCommandBarButton(row, column)
    return japi._exec("DzFrameGetCommandBarButton", row, column)
end

--- frame控件是否启用
---@param frame number integer
---@return boolean
function japi.FrameGetEnable(frame)
    return japi._exec("DzFrameGetEnable", frame)
end

--- 获取Frame的高度
---@param frame number integer
---@return number floor
function japi.FrameGetHeight(frame)
    return japi._exec("DzFrameGetHeight", frame)
end

--- 原生 - 英雄按钮
--- 左侧的英雄头像，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetHeroBarButton(buttonId)
    return japi._exec("DzFrameGetHeroBarButton", buttonId)
end

--- 原生 - 英雄血条
--- 左侧的英雄头像下的血条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetHeroHPBar(buttonId)
    return japi._exec("DzFrameGetHeroHPBar", buttonId)
end

--- 原生 - 英雄蓝条
--- 左侧的英雄头像下的蓝条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetHeroManaBar(buttonId)
    return japi._exec("DzFrameGetHeroManaBar", buttonId)
end

--- 原生 - 物品栏按钮
--- 索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetItemBarButton(buttonId)
    return japi._exec("DzFrameGetItemBarButton", buttonId)
end

--- 原生 - 小地图
---@return number integer
function japi.FrameGetMinimap()
    return japi._exec("DzFrameGetMinimap")
end

--- 原生 - 小地图按钮
--- 小地图右侧竖排按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetMinimapButton(buttonId)
    return japi._exec("DzFrameGetMinimapButton", buttonId)
end

--- 获取 Frame 的名称
---@param frame number integer
---@return string
function japi.FrameGetName(frame)
    return japi._exec("DzFrameGetName", frame)
end

--- 获取 Frame 的 Parent
---@param frame number integer
---@return number integer
function japi.FrameGetParent(frame)
    return japi._exec("DzFrameGetParent", frame)
end

--- 原生 - 单位大头像
--- 小地图右侧的大头像
---@return number integer
function japi.FrameGetPortrait()
    return japi._exec("DzFrameGetPortrait")
end

--- 获取 Frame 内的文字
--- 支持EditBox, TextFrame, TextArea, SimpleFontString
---@param frame number integer
---@return string
function japi.FrameGetText(frame)
    return japi._exec("DzFrameGetText", frame)
end

--- 获取 Frame 的字数限制
--- 支持EditBox
---@param frame number integer
---@return number integer
function japi.FrameGetTextSizeLimit(frame)
    return japi._exec("DzFrameGetTextSizeLimit", frame)
end

--- 原生 - 鼠标提示
--- 鼠标移动到物品或技能按钮上显示的提示窗，初始位于技能栏上方
---@return number integer
function japi.FrameGetTooltip()
    return japi._exec("DzFrameGetTooltip")
end

--- 原生 - 上方消息框
--- 高维修费用 等消息
---@return number integer
function japi.FrameGetTopMessage()
    return japi._exec("DzFrameGetTopMessage")
end

--- 原生 - 系统消息框
--- 包含显示消息给玩家 及 显示Debug消息等
---@return number integer
function japi.FrameGetUnitMessage()
    return japi._exec("DzFrameGetUnitMessage")
end

--- 原生 - 界面按钮
--- 左上的菜单等按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.FrameGetUpperButtonBarButton(buttonId)
    return japi._exec("DzFrameGetUpperButtonBarButton", buttonId)
end

--- 获取frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@return number floor
function japi.FrameGetValue(frame)
    return japi._exec("DzFrameGetValue", frame)
end

--- 原生 - 隐藏界面元素
--- 不在地图初始化时调用则会残留小地图和时钟模型
function japi.FrameHideInterface()
    return japi._exec("DzFrameHideInterface")
end

--- 设置绝对位置
--- 设置 frame 的 Point 锚点 在 (x, y)
---@param frame number integer
---@param point number integer
---@param x number
---@param y number
function japi.FrameSetAbsolutePoint(frame, point, x, y)
    return japi._exec("DzFrameSetAbsolutePoint", frame, point, x, y)
end

--- 移动所有锚点到Frame
--- 移动 frame 的 所有锚点 到 relativeFrame 上
---@param frame number integer
---@param relativeFrame number integer
---@return boolean
function japi.FrameSetAllPoints(frame, relativeFrame)
    return japi._exec("DzFrameSetAllPoints", frame, relativeFrame)
end

--- 设置frame的透明度(0-255)
---@param frame number integer
---@param alpha number integer
function japi.FrameSetAlpha(frame, alpha)
    return japi._exec("DzFrameSetAlpha", frame, alpha)
end

--- 设置动画
---@param frame number integer
---@param animId number integer 播放序号的动画
---@param autoCast boolean 自动播放
function japi.FrameSetAnimate(frame, animId, autoCast)
    return japi._exec("DzFrameSetAnimate", frame, animId, autoCast)
end

--- 设置动画进度
--- 自动播放为false时可用
---@param frame number integer
---@param offset number 进度
function japi.FrameSetAnimateOffset(frame, offset)
    return japi._exec("DzFrameSetAnimateOffset", frame, offset)
end

--- 启用/禁用 frame
---@param frame number integer
---@param enable boolean
function japi.FrameSetEnable(frame, enable)
    return japi._exec("DzFrameSetEnable", frame, enable)
end

--- 设置frame获取焦点
---@param frame number integer
---@param enable boolean
---@return boolean
function japi.FrameSetFocus(frame, enable)
    return japi._exec("DzFrameSetFocus", frame, enable)
end

--- 设置字体
--- 设置 frame 的字体为 font, 大小 height, flag flag
--- 支持EditBox、SimpleFontString、SimpleMessageFrame以及非SimpleFrame类型的例如TEXT，flag作用未知
---@param frame number integer
---@param fileName string
---@param height number
---@param flag number integer
function japi.FrameSetFont(frame, fileName, height, flag)
    return japi._exec("DzFrameSetFont", frame, fileName, height, flag)
end

--- 设置最大/最小值
--- 设置 frame 的 最小值为 Min 最大值为 Max
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param minValue number
---@param maxValue number
function japi.FrameSetMinMaxValue(frame, minValue, maxValue)
    return japi._exec("DzFrameSetMinMaxValue", frame, minValue, maxValue)
end

--- 设置模型
--- 设置 frame 的模型文件为 modelFile ModelType:modelType Flag:flag
---@param frame number integer
---@param modelFile string
---@param modelType number integer
---@param flag number integer
function japi.FrameSetModel(frame, modelFile, modelType, flag)
    return japi._exec("DzFrameSetModel", frame, modelFile, modelType, flag)
end

--- 设置父窗口
--- 设置 frame 的父窗口为 parent
---@param frame number integer
---@param parent number integer
function japi.FrameSetParent(frame, parent)
    return japi._exec("DzFrameSetParent", frame, parent)
end

--- 设置相对位置
--- 设置 frame 的 Point 锚点 (跟随relativeFrame 的 relativePoint 锚点) 偏移(x, y)
---@param frame number integer
---@param point number integer
---@param relativeFrame number integer
---@param relativePoint number integer
---@param x number
---@param y number
function japi.FrameSetPoint(frame, point, relativeFrame, relativePoint, x, y)
    return japi._exec("DzFrameSetPoint", frame, point, relativeFrame, relativePoint, x, y)
end

--- 设置优先级
--- 设置 frame 优先级:int
---@param frame number integer
---@param priority number integer
function japi.FrameSetPriority(frame, priority)
    return japi._exec("DzFrameSetPriority", frame, priority)
end

--- 设置缩放
--- 设置 frame 的缩放 scale
---@param frame number integer
---@param scale number
function japi.FrameSetScale(frame, scale)
    return japi._exec("DzFrameSetScale", frame, scale)
end

--- 设置frame大小
---@param frame number integer
---@param w number 宽
---@param h number 高
function japi.FrameSetSize(frame, w, h)
    return japi._exec("DzFrameSetSize", frame, w, h)
end

--- 设置frame步进值
--- 支持Slider
---@param frame number integer
---@param step number 步进
function japi.FrameSetStepValue(frame, step)
    return japi._exec("DzFrameSetStepValue", frame, step)
end

--- 设置frame文本
--- 支持EditBox, TextFrame, TextArea, SimpleFontString、GlueEditBoxWar3、SlashChatBox、TimerTextFrame、TextButtonFrame、GlueTextButton
---@param frame number integer
---@param text string
function japi.FrameSetText(frame, text)
    return japi._exec("DzFrameSetText", frame, text)
end

--- 设置frame文本对齐方式
--- 支持TextFrame、SimpleFontString、SimpleMessageFrame
---@param frame number integer
---@param align number integer ，参考blizzard:^TEXT_ALIGN
function japi.FrameSetTextAlignment(frame, align)
    return japi._exec("DzFrameSetTextAlignment", frame, align)
end

---@param frame number integer
---@param color number integer
function japi.FrameSetTextColor(frame, color)
    return japi._exec("DzFrameSetTextColor", frame, color)
end

--- 设置frame字数限制
---@param frame number integer
---@param limit number integer
function japi.FrameSetTextSizeLimit(frame, limit)
    return japi._exec("DzFrameSetTextSizeLimit", frame, limit)
end

--- 设置frame贴图
--- 支持Backdrop、SimpleStatusBar
---@param frame number integer
---@param texture string 贴图路径
---@param flag number integer 是否平铺
function japi.FrameSetTexture(frame, texture, flag)
    return japi._exec("DzFrameSetTexture", frame, texture, flag)
end

--- 设置提示
--- 设置 frame 的提示Frame为 tooltip
--- 设置tooltip
---@param frame number integer
---@param tooltip number integer
function japi.FrameSetTooltip(frame, tooltip)
    return japi._exec("DzFrameSetTooltip", frame, tooltip)
end

--- 设置frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param value number
function japi.FrameSetValue(frame, value)
    return japi._exec("DzFrameSetValue", frame, value)
end

--- 设置frame颜色
---@param frame number integer
---@param vertexColor number integer
function japi.FrameSetVertexColor(frame, vertexColor)
    return japi._exec("DzFrameSetVertexColor", frame, vertexColor)
end

--- 设置frame显示与否
---@param frame number integer
---@param enable boolean
function japi.FrameShow(frame, enable)
    return japi._exec("DzFrameShow", frame, enable)
end

--- 自适应frame大小
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.FrameAdaptive(w)
    return japi._exec("FrameAdaptive", w)
end

--- 自适应frame大小反算
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.FrameDisAdaptive(w)
    return japi._exec("FrameDisAdaptive", w)
end

function japi.GetClientHeight(...)
    return japi._exec("DzGetClientHeight", ...)
end

function japi.GetClientWidth(...)
    return japi._exec("DzGetClientWidth", ...)
end

--- 取 RGBA 色值
--- 返回一个整数，用于设置Frame颜色
---@param r number integer
---@param g number integer
---@param b number integer
---@param a number integer
---@return number integer
function japi.GetColor(r, g, b, a)
    return japi._exec("DzGetColor", r, g, b, a)
end

--- 原生 - 游戏UI
--- 一般用作创建自定义UI的父节点
---@return number integer
function japi.GetGameUI()
    return japi._exec("DzGetGameUI")
end

--- 获取客户端语言
--- 对不同语言客户端返回不同
---@return string
function japi.GetLocale()
    return japi._exec("DzGetLocale")
end

--- 鼠标所在的Frame控件指针
--- 不是所有类型的Frame都能响应鼠标，能响应的有BUTTON，TEXT等
---@return number integer
function japi.GetMouseFocus()
    return japi._exec("DzGetMouseFocus")
end

--- 获取鼠标在游戏内的坐标X
---@return number
function japi.GetMouseTerrainX()
    return japi._exec("DzGetMouseTerrainX")
end

--- 获取鼠标在游戏内的坐标Y
---@return number
function japi.GetMouseTerrainY()
    return japi._exec("DzGetMouseTerrainY")
end

--- 获取鼠标在游戏内的坐标Z
---@return number
function japi.GetMouseTerrainZ()
    return japi._exec("DzGetMouseTerrainZ")
end

--- 获取鼠标在屏幕的坐标X
---@return number
function japi.GetMouseX()
    return japi._exec("DzGetMouseX")
end

--- 获取鼠标游戏窗口坐标X
---@return number integer
function japi.GetMouseXRelative()
    return japi._exec("DzGetMouseXRelative")
end

--- 获取鼠标在屏幕的坐标Y
---@return number
function japi.GetMouseY()
    return japi._exec("DzGetMouseY")
end

--- 获取鼠标游戏窗口坐标Y
---@return number integer
function japi.GetMouseYRelative()
    return japi._exec("DzGetMouseYRelative")
end

--- 事件响应 - 获取触发的按键
--- 响应 [硬件] - 按键事件
---@return number integer
function japi.GetTriggerKey()
    return japi._exec("DzGetTriggerKey")
end

--- 事件响应 - 获取触发硬件事件的玩家
--- 响应 [硬件] - 按键事件 滚轮事件 窗口大小变化事件
---@return number player
function japi.GetTriggerKeyPlayer()
    return japi._exec("DzGetTriggerKeyPlayer")
end

--- 事件响应 - 获取同步的数据
--- 响应 [同步] - 同步消息事件
---@return string
function japi.GetTriggerSyncData()
    return japi._exec("DzGetTriggerSyncData")
end

--- 事件响应 - 获取同步数据的玩家
--- 响应 [同步] - 同步消息事件
---@return number player
function japi.GetTriggerSyncPlayer()
    return japi._exec("DzGetTriggerSyncPlayer")
end

--- 获取升级所需经验
--- 获取单位 unit 的 level级 升级所需经验
---@param whichUnit number
---@param level number integer
---@return number integer
function japi.GetUnitNeededXP(whichUnit, level)
    return japi._exec("DzGetUnitNeededXP", whichUnit, level)
end

--- 获取鼠标指向的单位
---@return number unit
function japi.GetUnitUnderMouse()
    return japi._exec("DzGetUnitUnderMouse")
end

--- 事件响应 - 获取滚轮变化值
--- 响应 [硬件] - 鼠标滚轮事件，正负区分上下
---@return number integer
function japi.GetWheelDelta()
    return japi._exec("DzGetWheelDelta")
end

--- 获取魔兽窗口高度
---@return number integer
function japi.GetWindowHeight()
    return japi._exec("DzGetWindowHeight")
end

--- 获取魔兽窗口宽度
---@return number integer
function japi.GetWindowWidth()
    return japi._exec("DzGetWindowWidth")
end

--- 获取魔兽窗口X坐标
---@return number integer
function japi.GetWindowX()
    return japi._exec("DzGetWindowX")
end

--- 获取魔兽窗口Y坐标
---@return number integer
function japi.GetWindowY()
    return japi._exec("DzGetWindowY")
end

--- 判断按键是否按下
---@param iKey number integer 参考blizzard:^GAME_KEY
---@return boolean
function japi.IsKeyDown(iKey)
    return japi._exec("DzIsKeyDown", iKey)
end

--- 鼠标是否在游戏内
---@return boolean
function japi.IsMouseOverUI()
    return japi._exec("DzIsMouseOverUI")
end

--- 判断游戏窗口是否处于活动状态
---@return boolean
function japi.IsWindowActive()
    return japi._exec("DzIsWindowActive")
end

--- 玩家是否正在聊天框输入
---@return boolean
function japi.IsTyping()
    return japi._exec("IsTyping")
end

--- 获取某个坐标的Z轴高度
---@param x number
---@param y number
---@return number
function japi.Z(x, y)
    return japi._exec("Z", x, y)
end

--- 加载Toc文件列表
--- 加载--> file.toc
--- 载入自己的fdf列表文件
---@return boolean
function japi.LoadToc(tocFilePath)
    if (J.JapiEx["_DzLoadToc"][tocFilePath] == true) then
        return true
    end
    J.JapiEx["_DzLoadToc"][tocFilePath] = true
    return japi._exec("DzLoadToc", tocFilePath)
end

---@param enable boolean
function japi.OriginalUIAutoResetPoint(enable)
    return japi._exec("DzOriginalUIAutoResetPoint", enable)
end

--- 原生 - 修改屏幕比例(FOV)
---@param value number
function japi.SetCustomFovFix(value)
    return japi._exec("DzSetCustomFovFix", value)
end

--- 设置内存数值
--- 设置内存数据 address=value
---@param address number integer
---@param value number
function japi.SetMemory(address, value)
    return japi._exec("DzSetMemory", address, value)
end

--- 设置鼠标的坐标
---@param x number integer
---@param y number integer
function japi.SetMousePos(x, y)
    return japi._exec("DzSetMousePos", x, y)
end

--- 替换单位类型
--- 替换whichUnit的单位类型为:id
--- 不会替换大头像中的模型
---@param whichUnit number
---@param id number|string
function japi.SetUnitID(whichUnit, id)
    return japi._exec("DzSetUnitID", whichUnit, id)
end

--- 替换单位模型
--- 替换whichUnit的模型:path(必须带.mdl)
--- 不会替换大头像中的模型
---@param whichUnit number
---@param model string
function japi.SetUnitModel(whichUnit, model)
    return japi._exec("DzSetUnitModel", whichUnit, model)
end

--- 设置单位位置 - 本地调用
---@param whichUnit number
---@param x number
---@param y number
function japi.SetUnitPosition(whichUnit, x, y)
    return japi._exec("DzSetUnitPosition", whichUnit, x, y)
end

--- 替换单位贴图
--- 只能替换模型中有Replaceable ID x 贴图的模型，ID为索引。不会替换大头像中的模型
---@param whichUnit number
---@param path string
---@param texId number integer
function japi.SetUnitTexture(whichUnit, path, texId)
    return japi._exec("DzSetUnitTexture", whichUnit, path, texId)
end

--- 原生 - 设置小地图背景贴图
---@param blp string
function japi.SetWar3MapMap(blp)
    return japi._exec("DzSetWar3MapMap", blp)
end

--- 获取子SimpleFontString
--- ID默认填0，同名时优先获取最后被创建的。SimpleFontString为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.SimpleFontStringFindByName(name, id)
    return japi._exec("DzSimpleFontStringFindByName", name, id)
end

--- 获取子SimpleFrame
--- ID默认填0，同名时优先获取最后被创建的。SimpleFrame为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.SimpleFrameFindByName(name, id)
    return japi._exec("DzSimpleFrameFindByName", name, id)
end

--- 获取子SimpleTexture
--- ID默认填0，同名时优先获取最后被创建的。SimpleTexture为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.SimpleTextureFindByName(name, id)
    return japi._exec("DzSimpleTextureFindByName", name, id)
end

function japi.SyncBuffer(...)
    return japi._exec("DzSyncBuffer", ...)
end

--- 同步游戏数据
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function japi.SyncData(prefix, data)
    return japi._exec("DzSyncData", prefix, data)
end

--- 同步游戏数据(立刻)
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function japi.SyncDataImmediately(prefix, data)
    return japi._exec("DzSyncDataImmediately", prefix, data)
end

--- 数据同步
--- 标签为 prefix 的数据被同步 | 来自平台:server
--- 来自平台的参数填false
---@param trig number
---@param prefix string
---@param server boolean
function japi.TriggerRegisterSyncData(trig, prefix, server)
    return japi._exec("DzTriggerRegisterSyncData", trig, prefix, server)
end

--- 轮盘队列
--- 此方法自带延迟策略，并且自动合并请求
--- 从而可以大大减轻执行压力
--- 只适用于无返回执行
---@param whichPlayer number
---@param key string
---@param func function
---@return void
function japi.Roulette(func, whichPlayer, key, value)
    japi._exec("Roulette", func, whichPlayer, key, value)
end

function japi.UnitDisableAttack(...)
    return japi._exec("DzUnitDisableAttack", ...)
end

function japi.UnitDisableInventory(...)
    return japi._exec("DzUnitDisableInventory", ...)
end

function japi.UnitSilence(...)
    return japi._exec("DzUnitSilence", ...)
end

function japi.EXBlendButtonIcon(...)
    return japi._exec("EXBlendButtonIcon", ...)
end

function japi.EXDclareButtonIcon(...)
    return japi._exec("EXDclareButtonIcon", ...)
end

function japi.EXDisplayChat(...)
    return japi._exec("EXDisplayChat", ...)
end

--- 重置特效变换
--- 重置 effect
--- 清空所有的旋转和缩放，重置为初始状态
---@param effect number
function japi.EXEffectMatReset(effect)
    return japi._exec("EXEffectMatReset", effect)
end

--- 特效绕X轴旋转
--- effect 绕X轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number
function japi.EXEffectMatRotateX(effect, angle)
    return japi._exec("EXEffectMatRotateX", effect, angle)
end

--- 特效绕Y轴旋转
--- effect 绕Y轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number
function japi.EXEffectMatRotateY(effect, angle)
    return japi._exec("EXEffectMatRotateY", effect, angle)
end

--- 特效绕Z轴旋转
--- effect 绕Z轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number
function japi.EXEffectMatRotateZ(effect, angle)
    return japi._exec("EXEffectMatRotateZ", effect, angle)
end

--- 缩放特效
--- 设置 effect 的X轴缩放，Y轴缩放，Z轴缩放
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态。设置为2,2,2时相当于大小变为2倍。设置为负数时，就是镜像翻转
---@param effect number
---@param x number
---@param y number
---@param z number
function japi.EXEffectMatScale(effect, x, y, z)
    return japi._exec("EXEffectMatScale", effect, x, y, z)
end

---@param script string
function japi.EXExecuteScript(script)
    return japi._exec("EXExecuteScript", script)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return number integer
function japi.EXGetAbilityDataInteger(abil, level, dataType)
    return japi._exec("EXGetAbilityDataInteger", abil, level, dataType)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return number float
function japi.EXGetAbilityDataReal(abil, level, dataType)
    return japi._exec("EXGetAbilityDataReal", abil, level, dataType)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return string
function japi.EXGetAbilityDataString(abil, level, dataType)
    return japi._exec("EXGetAbilityDataString", abil, level, dataType)
end

---@param abil number ability
---@return number integer
function japi.EXGetAbilityId(abil)
    return japi._exec("EXGetAbilityId", abil)
end

---@param abil number ability
---@param stateType number integer
---@return number float
function japi.EXGetAbilityState(abil, stateType)
    return japi._exec("EXGetAbilityState", abil, stateType)
end

function japi.EXGetAbilityString(...)
    return japi._exec("EXGetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@return string
function japi.EXGetBuffDataString(buffCode, dataType)
    return japi._exec("EXGetBuffDataString", buffCode, dataType)
end

--- 获取特效大小
---@param effect number
---@return number float
function japi.EXGetEffectSize(effect)
    return japi._exec("EXGetEffectSize", effect)
end

--- 获取特效X轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectX(effect)
    return japi._exec("EXGetEffectX", effect)
end

--- 获取特效Y轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectY(effect)
    return japi._exec("EXGetEffectY", effect)
end

--- 获取特效Z轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectZ(effect)
    return japi._exec("EXGetEffectZ", effect)
end

---@param eddType number integer
---@return number integer
function japi.EXGetEventDamageData(eddType)
    return japi._exec("EXGetEventDamageData", eddType)
end

---@param itemCode number integer
---@param dataType number integer
---@return string
function japi.EXGetItemDataString(itemCode, dataType)
    return japi._exec("EXGetItemDataString", itemCode, dataType)
end

---@param whichUnit number
---@param abilityID number string|integer
function japi.EXGetUnitAbility(whichUnit, abilityID)
    if (type(abilityID) == "string") then
        abilityID = J.C2I(abilityID)
    end
    return japi._exec("EXGetUnitAbility", whichUnit, abilityID)
end

---@param whichUnit number
---@param index number integer
function japi.EXGetUnitAbilityByIndex(whichUnit, index)
    return japi._exec("EXGetUnitAbilityByIndex", whichUnit, index)
end

function japi.EXGetUnitArrayString(...)
    return japi._exec("EXGetUnitArrayString", ...)
end

function japi.EXGetUnitInteger(...)
    return japi._exec("EXGetUnitInteger", ...)
end

function japi.EXGetUnitReal(...)
    return japi._exec("EXGetUnitReal", ...)
end

function japi.EXGetUnitString(...)
    return japi._exec("EXGetUnitString", ...)
end

---@param whichUnit number
---@param enable boolean
function japi.EXPauseUnit(whichUnit, enable)
    return japi._exec("EXPauseUnit", whichUnit, enable)
end

function japi.EXSetAbilityAEmeDataA(...)
    return japi._exec("EXSetAbilityAEmeDataA", ...)
end

function japi.EXSetAbilityDataInteger(...)
    return japi._exec("EXSetAbilityDataInteger", ...)
end

function japi.EXSetAbilityDataReal(...)
    return japi._exec("EXSetAbilityDataReal", ...)
end

function japi.EXSetAbilityDataString(...)
    return japi._exec("EXSetAbilityDataString", ...)
end

---@param ability number
---@param stateType number integer
---@param value number
function japi.EXSetAbilityState(ability, stateType, value)
    return japi._exec("EXSetAbilityState", ability, stateType, value)
end

function japi.EXSetAbilityString(...)
    return japi._exec("EXSetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@param value string
function japi.EXSetBuffDataString(buffCode, dataType, value)
    return japi._exec("EXSetBuffDataString", buffCode, dataType, value)
end

--- 设置特效大小
---@param e number
---@param size number
function japi.EXSetEffectSize(e, size)
    return japi._exec("EXSetEffectSize", e, size)
end

--- 设置特效动画速度
---@param e number
---@param speed number
function japi.EXSetEffectSpeed(e, speed)
    return japi._exec("EXSetEffectSpeed", e, speed)
end

--- 移动特效到坐标
---@param e number
---@param x number
---@param y number
function japi.EXSetEffectXY(e, x, y)
    return japi._exec("EXSetEffectXY", e, x, y)
end

---设置特效高度
---@param e number
---@param z number
function japi.EXSetEffectZ(e, z)
    return japi._exec("EXSetEffectZ", e, z)
end

---@param amount number
---@return boolean
function japi.EXSetEventDamage(amount)
    return japi._exec("EXSetEventDamage", amount)
end

---@param itemCode number integer
---@param dataType number integer
---@param value string
---@return boolean
function japi.EXSetItemDataString(itemCode, dataType, value)
    return japi._exec("EXSetItemDataString", itemCode, dataType, value)
end

function japi.EXSetUnitArrayString(...)
    return japi._exec("EXSetUnitArrayString", ...)
end

--- 设置单位的碰撞类型
--- 启用/禁用 单位u 对 t 的碰撞
---@param enable boolean
---@param u number
---@param t number integer 碰撞类型，参考blizzard:^COLLISION_TYPE
function japi.EXSetUnitCollisionType(enable, u, t)
    return japi._exec("EXSetUnitCollisionType", enable, u, t)
end

--- 设置单位面向角度
--- 立即转身
---@param u number
---@param angle number
function japi.EXSetUnitFacing(u, angle)
    return japi._exec("EXSetUnitFacing", u, angle)
end

function japi.EXSetUnitInteger(...)
    return japi._exec("EXSetUnitInteger", ...)
end

--- 设置单位的移动类型
---@param u number
---@param t number integer 移动类型，参考blizzard:^MOVE_TYPE
function japi.EXSetUnitMoveType(u, t)
    return japi._exec("EXSetUnitMoveType", u, t)
end

function japi.EXSetUnitReal(...)
    return japi._exec("EXSetUnitReal", ...)
end

function japi.EXSetUnitString(...)
    return japi._exec("EXSetUnitString", ...)
end

--- 伤害值
---@return number
function japi.GetEventDamage()
    return japi._exec("GetEventDamage")
end

---@param whichUnit number
---@param state number unitstate
---@return number
function japi.GetUnitState(whichUnit, state)
    return japi._exec("GetUnitState", whichUnit, state)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return boolean
function japi.RequestExtraBooleanData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi._exec("RequestExtraBooleanData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number integer
function japi.RequestExtraIntegerData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi._exec("RequestExtraIntegerData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number
function japi.RequestExtraRealData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi._exec("RequestExtraRealData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return string
function japi.RequestExtraStringData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi._exec("RequestExtraStringData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

--- 设置单位属性
---@param whichUnit number
---@param state number unitstate
---@param value number
function japi.SetUnitState(whichUnit, state, value)
    japi._exec("SetUnitState", whichUnit, state, value)
    if (whichUnit ~= nil and state == UNIT_STATE_ATTACK_WHITE or state == UNIT_STATE_DEFEND_WHITE) then
        J.UnitAddAbility(whichUnit, SINGLUAR_ID["japi_delay"])
        J.UnitRemoveAbility(whichUnit, SINGLUAR_ID["japi_delay"])
    end
end

--------------------------------------------------------------------------

--- 玩家是否平台VIP
---@param whichPlayer number
---@return boolean
function japi.Map_IsPlatformVIP(whichPlayer)
    local res = japi.Map_GetPlatformVIP(whichPlayer)
    if (type(res) == "number") then
        return math.round(res) > 0
    end
    return false
end

--- 玩家是否参与过内测
---@param whichPlayer number
---@return boolean
function japi.Map_IsPresetAward(whichPlayer)
    if (japi.ServerAlready(whichPlayer)) then
        return "1" == japi.Map_GetServerValue(whichPlayer, "preset_map_award")
    end
    return false
end

--- 天梯提交玩家排名
---@param whichPlayer number
---@param value number
function japi.Map_Ladder_SubmitPlayerRank(whichPlayer, value)
    return japi.Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

--- 天梯提交获得称号
---@param whichPlayer number
---@param value string
function japi.Map_Ladder_SubmitTitle(whichPlayer, value)
    return japi.Map_Ladder_SetStat(whichPlayer, value, "1")
end

--- 设置玩家额外分
---@param whichPlayer number
---@param value string
function japi.Map_Ladder_SubmitPlayerExtraExp(whichPlayer, value)
    return japi.Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

--- 注册实时购买商品事件（玩家获得平台道具事件）
--- 玩家在游戏中购买商城道具触发，可以配合打开商城界面使用，读取用实时购买玩家和实时购买商品
--- 玩家背包中新获得了当前地图道具的回调事件，用于地图实现玩家在游戏内商城购买成功后在游戏内立即生效。
--- 可在事件内配合<事件响应 - 获取同步数据的玩家><事件响应 - 获取同步的数据>获得回调数据
function japi.TriggerRegisterMallItemSyncData(trig)
    japi.TriggerRegisterSyncData(trig, "DZMIA", true)
end

--- 全局存档变化事件
--- 本局游戏或其他游戏保存的全局存档都会触发这个事件，请使用[同步]分类下的获取同步数据来获得发生变化的全局存档KEY值
function japi.Map_Global_ChangeMsg(trig)
    japi.TriggerRegisterSyncData(trig, "DZGAU", true)
end

--- 本局游戏的地图模式
--- 获取本局游戏所选择地图模式，地图模式均由作者在作者之家进行配置
--- 包括天梯排位赛模式、快速匹配模式、建房间时房主所选定的地图模式
---@return number int 本局游戏所选择的地图模式Key，该Key由作者在作者之家进行配置
function japi.Map_GetMatchType()
    return japi.RequestExtraIntegerData(13, nil, nil, nil, false, 0, 0, 0)
end

--- 地图配置参数
--- 获取作者在作者之家配置的地图参数（原只读类型的地图全局存档）
--- 作者可以通过此接口实现节日活动开关、口令等功能
---@param key string 栏位键，用于作者之家进行配置
---@return string 作者配置在作者之家上的参数值
function japi.Map_GetMapConfig(key)
    return japi.RequestExtraStringData(21, nil, key, nil, false, 0, 0, 0)
end

--- 在游戏内的关键行为操作进行埋点，以便进行游戏内的玩家行为数据统计分析（比如某个英雄选择次数）
--- 上报前需先在作者之家创建埋点。
---@param whichPlayer number
---@param eventKey string 作者之家创建埋点时所填写的Key
---@param eventType string 预留参数，保持为空即可
---@param value number int 事件发生次数
function japi.Map_Statistics(whichPlayer, eventKey, eventType, value)
    return japi.RequestExtraBooleanData(34, whichPlayer, eventKey, eventType, false, value, 0, 0)
end

--- 本局游戏是否快速匹配
--- 判断玩家是否是通过匹配模式进入游戏
--- 具体模式ID使用 获取天梯和匹配的模式 获取
---@return boolean
function japi.Map_IsRPGQuickMatch()
    return japi.RequestExtraBooleanData(40, nil, nil, nil, false, 0, 0, 0)
end

--- 玩家平台道具剩余数量
--- 获取玩家 key 指定道具的剩余数量
--- 仅对次数消耗型商品有效
---@param whichPlayer number
---@param key string
---@return number integer
function japi.Map_GetMallItemCount(whichPlayer, key)
    return japi.RequestExtraIntegerData(41, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 使用商城道具（次数型）
--- 使用玩家 key 商城道具 value 次
--- 仅对次数消耗型商品有效，只能使用不能恢复，请谨慎使用
---@param whichPlayer number
---@param key string
---@param value number integer
---@return boolean
function japi.Map_ConsumeMallItem(whichPlayer, key, value)
    return japi.RequestExtraBooleanData(42, whichPlayer, key, nil, false, value, 0, 0)
end

--- 修改平台功能设置
---@param whichPlayer number
---@param option number integer;1为锁定镜头距离、2为显示血、蓝条、3为智能施法
---@param enable boolean
---@return boolean
function japi.Map_EnablePlatformSettings(whichPlayer, option, enable)
    return japi.RequestExtraBooleanData(43, whichPlayer, nil, nil, enable, option, 0, 0)
end

--- 获取玩家中游戏局数
---@param whichPlayer number
---@return number
function japi.Map_PlayedGames(whichPlayer)
    return japi.RequestExtraIntegerData(45, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家的评论次数
--- 该功能已失效，始终返回1
---@param whichPlayer number
---@return number|1
function japi.Map_CommentCount(whichPlayer)
    return japi.RequestExtraIntegerData(46, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家平台好友数量
---@param whichPlayer number
---@return number
function japi.Map_FriendCount(whichPlayer)
    return japi.RequestExtraIntegerData(47, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是鉴赏家
--- 评论里的鉴赏家
---@param whichPlayer number
---@return boolean
function japi.Map_IsConnoisseur(whichPlayer)
    return japi.RequestExtraBooleanData(48, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家登录的是战网账号
---@param whichPlayer number
---@return boolean
function japi.Map_IsBattleNetAccount(whichPlayer)
    return japi.RequestExtraBooleanData(49, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是地图作者
---@param whichPlayer number
---@return boolean
function japi.Map_IsAuthor(whichPlayer)
    return japi.RequestExtraBooleanData(50, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 地图评论次数
--- 获取该图总评论次数
---@return number integer
function japi.Map_CommentTotalCount()
    return japi.RequestExtraIntegerData(51, nil, nil, nil, false, 0, 0, 0)
end

--- 获取自定义排行榜玩家排名
--- 100名以外的玩家排名为0
--- 该功能适用于作者之家-服务器存档-自定义排行榜
--- 等同 DzAPI_Map_CommentTotalCount1
---@param whichPlayer number
---@param id number integer
---@return number integer
function japi.Map_CustomRanking(whichPlayer, id)
    return japi.RequestExtraIntegerData(52, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家曾经是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.Map_IsMapReturnUsed(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 1, 0, 0)
end

--- 玩家当前是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.Map_IsPlatformReturn(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 2, 0, 0)
end

--- 玩家曾经是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.Map_IsPlatformReturnUsed(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 4, 0, 0)
end

--- 玩家当前是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.Map_IsMapReturn(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 8, 0, 0)
end

--- 玩家收藏过地图
---@param whichPlayer number
---@return boolean
function japi.Map_IsCollected(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 16, 0, 0)
end

--- 获取玩家在指定地图的地图签到数据
--- 玩家每天登录游戏后，自动签到
---@param whichPlayer number
---@return number integer
function japi.Map_ContinuousCount(whichPlayer, id)
    return japi.RequestExtraIntegerData(54, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家是真实玩家
--- 用于区别平台AI玩家。现在平台已经添加虚拟电脑玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
---@param whichPlayer number
---@return boolean
function japi.Map_IsPlayer(whichPlayer)
    return japi.RequestExtraBooleanData(55, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 所有地图的总游戏时长
---@param whichPlayer number
---@return number
function japi.Map_MapsTotalPlayed(whichPlayer)
    return japi.RequestExtraIntegerData(56, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 指定地图的地图等级
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.Map_MapsLevel(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(57, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台金币消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.Map_MapsConsumeGold(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(58, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台木头消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.Map_MapsConsumeLumber(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(59, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（1~199）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.Map_MapsConsume_1_199(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(60, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（200~499）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.Map_MapsConsume_200_499(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(61, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（500~999）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.Map_MapsConsume_500_999(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(62, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图消费在（1000+）以上
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.Map_MapsConsume_1000(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(63, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 玩家是否装备指定平台装饰
--- 检查玩家是否装备着指定平台装饰（仅限平台和地图的合作装饰）。
--- 访问授权限制
--- 高级接口，仅限有出品平台和地图合作装饰的地图使用，平台道具ID请联系平台运营人员提供
---@param whichPlayer number
---@param skinType number int
---@param id  number int
---@return boolean
function japi.Map_IsPlayerUsingSkin(whichPlayer, skinType, id)
    return japi.RequestExtraBooleanData(64, whichPlayer, nil, nil, false, skinType, id, 0)
end

--- 获取论坛数据
--- 是否发过贴子,是否版主时，返回为1代表肯定
---@param whichPlayer number
---@param data number integer 0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量
---@return boolean
function japi.Map_GetForumData(whichPlayer, data)
    return japi.RequestExtraIntegerData(65, whichPlayer, nil, nil, false, data, 0, 0)
end

--- 游戏中弹出商城道具购买界面
--- 可以在游戏里打开指定商城道具购买界面（包括下架商品）,商品购买之后，请配合实时购买触发功能使用
---@param whichPlayer number
---@param key string
---@return boolean
function japi.Map_OpenMall(whichPlayer, key)
    return japi.RequestExtraIntegerData(66, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 玩家最近一次上安利墙时间
--- 获取玩家最近一次在当前地图的优质评论被推荐上安利墙的时间
---@param whichPlayer number
---@return number int 时间戳
function japi.Map_GetLastRecommendTime(whichPlayer)
    return japi.RequestExtraIntegerData(67, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家在当前地图的宝箱累计抽取次数
---@param whichPlayer number
---@return number int
function japi.Map_GetLotteryUsedCount(whichPlayer)
    return japi.RequestExtraIntegerData(68, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 上报本局游戏玩家数据
--- 上报本局游戏的玩家数据，比如战斗力、杀敌数等。
--- 以下数据项 key 由平台统一定义，请勿随意自行上传：
--- RankIndex: 乱斗模式排名
--- InnerGameMode: 地图模式名称
--- GameResult: 游戏结果（上报后立即结束游戏），1=胜利，0=失败
--- GameResultNoEnd: 游戏结果（上报后不会立即结束游戏），1=胜利，0=失败
---@param whichPlayer number
---@param key string
---@param value string
---@return number int
function japi.Map_GameResult_CommitData(whichPlayer, key, value)
    return japi.RequestExtraIntegerData(69, whichPlayer, key, tostring(value), false, 0, 0, 0)
end

--- 玩家本局游戏距上一局游戏的时间差
--- 查询该玩家上次玩游戏时间至本次玩游戏时间的差值，可以利用此接口实现离线收益之类的功能。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用
---@param whichPlayer number
---@return number int 时间差，单位为秒
function japi.Map_GetSinceLastPlayedSeconds(whichPlayer)
    return japi.RequestExtraIntegerData(70, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 打开牛币快速购买窗口
--- 弹出提示框询问玩家是否使用牛币直接购买指定道具，作者需已在商城上架对应商品（商品信息中的道具和数量与接口所请求的参数一致）。
--- 如果前一次购买的提示框未关闭的情况下再次调用此接口，后续请求无效。
--- 购买成功后可通过玩家获得平台道具事件实现在游戏内立即生效
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param whichPlayer number
---@param key string 平台道具key
---@param count number int 数量
---@param seconds number int 购买倒计时（秒数），最小5秒，最大99秒，0表示始终显示
---@return boolean
function japi.Map_CancelQuickBuy(whichPlayer, key, count, seconds)
    return japi.RequestExtraBooleanData(72, whichPlayer, key, nil, false, count, seconds, 0)
end

--- 关闭牛币快速购买窗口
--- 关闭最后一次打开的牛币快速购买窗口，结合打开牛币快速购买窗口使用。
--- 适用于游戏场景切换后，之前的提示购买已不再适用的情况，比如游戏开始前1分钟可以更换英雄，提示玩家购买英雄更换道具，1分钟后关闭提示防止玩家误购买。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param whichPlayer number
---@return boolean
function japi.Map_CancelQuickBuy(whichPlayer)
    return japi.RequestExtraBooleanData(73, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 本局游戏是否处于平台自测服
---@return boolean
function japi.Map_IsMapTest()
    return japi.RequestExtraBooleanData(74, nil, nil, nil, false, 0, 0, 0)
end

--------------------------------------------------------------------------

--- 读取游戏运行FPS
---@return number
function japi.FPS()
    return FRAMEWORK_FPS
end

--- 读取玩家服务器存档成功
--- 如果返回false代表读取失败,反之成功,之后游戏里平台不会再发送“服务器保存失败”的信息，所以希望地图作者在游戏开始给玩家发下信息服务器存档是否正确读取。
---@param whichPlayer number
---@return boolean
function japi.ServerAlready(whichPlayer)
    local res = japi.Map_GetServerValueErrorCode(whichPlayer)
    if (type(res) == "number") then
        return math.floor(res) == 0
    end
    return false
end

--- 保存服务器存档
--- 会根据数据类型自动添加前缀
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveValue(whichPlayer, key, value)
    if (string.len(key) > 63) then
        japi._msg("63_KEY_TOO_LONG")
        return
    end
    if (type(value) == "boolean") then
        if (value == true) then
            value = "B:1"
        else
            value = "B:0"
        end
    elseif (type(value) == "number") then
        value = "N:" .. tostring(value)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        japi._msg("63_VALUE_TOO_LONG")
        return
    end
    japi.Roulette(japi.Map_SaveServerValue, whichPlayer, key, value)
end

--- 获取服务器存档
--- 会处理根据数据类型自动添加前缀的数据
---@param whichPlayer number
---@param key string
---@return any
function japi.ServerLoadValue(whichPlayer, key)
    if (string.len(key) > 63) then
        japi._msg("63_KEY_TOO_LONG")
        return
    end
    if (japi.ServerAlready(whichPlayer)) then
        local result = japi.Map_GetServerValue(whichPlayer, key)
        if (type(result) == "string") then
            local valType = string.sub(result, 1, 2)
            if (valType == "B:") then
                local v = string.sub(result, 3)
                return "1" == v
            elseif (valType == "N:") then
                local v = string.sub(result, 3)
                return tonumber(v or 0)
            end
            if (result == '') then
                return nil
            end
            return result
        end
    end
    return nil
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveRoom(whichPlayer, key, value)
    if (string.len(key) > 63) then
        japi._msg("63_KEY_TOO_LONG")
        return
    end
    key = string.upper(key)
    if (type(value) == "boolean") then
        if (value == true) then
            value = "true"
        else
            value = "false"
        end
    elseif (type(value) == "number") then
        value = math.numberFormat(value, 2)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        japi._msg("63_VALUE_TOO_LONG")
        return
    end
    japi.Roulette(japi.Map_Stat_SetStat, whichPlayer, key, value)
end

--- 获得游戏渲染的：离顶黑边高、离底黑边高、中间显示高、
---@return number,number,number
function japi.GetFrameBorders()
    return J.JapiEx["_FrameBlackTop"], J.JapiEx["_FrameBlackBottom"], J.JapiEx["_FrameInnerHeight"]
end

--- 是否宽屏模式
---@return boolean
function japi.IsWideScreen()
    return J.JapiEx["_IsWideScreen"]
end

--- 是物理伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventPhysicalDamage()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end

--- 是攻击伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventAttackDamage()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end

--- 是远程伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventRangedDamage()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end

--- 单位所受伤害的伤害类型是 damageType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param damageType number 参考 blizzard:^DAMAGE_TYPE
---@return boolean
function japi.IsEventDamageType(damageType)
    return damageType == J.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end

--- 单位所受伤害的武器类型是 是 weaponType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param weaponType number 参考 blizzard:^WEAPON_TYPE
---@return boolean
function japi.IsEventWeaponType(weaponType)
    return weaponType == J.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end

--- 单位所受伤害的攻击类型是 是 attackType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param attackType number 参考 blizzard:^ATTACK_TYPE
---@return boolean
function japi.IsEventAttackType(attackType)
    return attackType == J.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end

--- 新建一个Tag索引
---@return string
function japi.FrameTagIndex()
    J.JapiEx["_FrameTagIndex"] = J.JapiEx["_FrameTagIndex"] + 1
    return "Frame#" .. J.JapiEx["_FrameTagIndex"]
end

--- X比例 转 像素
---@param x number
---@return number
function japi.PX(x)
    return japi.GetClientWidth() * x / 0.8
end

--- Y比例 转 像素
---@param y number
---@return number
function japi.PY(y)
    return japi.GetClientHeight() * y / 0.6
end

--- X像素 转 比例
---@param x number
---@return number
function japi.RX(x)
    return x / japi.GetClientWidth() * 0.8
end

--- Y像素 转 比例
---@param y number
---@return number
function japi.RY(y)
    return y / japi.GetClientHeight() * 0.6
end

--- 鼠标客户端内X像素
---@return number
function japi.MousePX()
    return japi.GetMouseXRelative()
end
--- 鼠标客户端内Y像素
---@return number
function japi.MousePY()
    return japi.GetClientHeight() - japi.GetMouseYRelative()
end

--- 鼠标X像素 转 比例
---@return number
function japi.MouseRX()
    return japi.RX(japi.MousePX())
end
--- 鼠标Y像素 转 比例
---@return number
function japi.MouseRY()
    return japi.RY(japi.MousePY())
end

--- 判断XY是否在客户端内
---@param x number
---@param y number
---@return boolean
function japi.InWindow(x, y)
    return x > 0 and x < 0.8 and y > 0 and y < 0.6
end
--- 判断鼠标是否在客户端内
---@return boolean
function japi.InWindowMouse()
    return japi.InWindow(japi.MouseRX(), japi.MouseRY())
end

--- 异步执行刷新
---@param key string
---@param callFunc function|nil
---@return void
function japi.Refresh(key, callFunc)
    if (type(callFunc) == "function") then
        J.JapiEx["_Refresh"]:set(key, callFunc)
    else
        J.JapiEx["_Refresh"]:set(key, nil)
    end
end