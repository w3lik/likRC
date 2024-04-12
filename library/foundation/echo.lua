--- 在屏幕打印信息给所有玩家
--- * 不支持异步，切无法释放资源，故不推荐使用
--- * 推荐自己编写UI
---@param msg string|string[]
---@param whichPlayer Player 可选，打印给某玩家
---@param duration number
---@param x number 可选，屏幕x处
---@param y number 可选，屏幕y处
function echo(msg, whichPlayer, duration, x, y)
    local _e = function(m)
        duration = duration or 0
        x = x or 0
        y = y or 0
        if (isClass(whichPlayer, PlayerClass)) then
            if (duration < 5) then
                J.DisplayTextToPlayer(whichPlayer:handle(), x, y, i18n.tr(m))
            else
                J.DisplayTimedTextToPlayer(whichPlayer:handle(), x, y, duration, i18n.tr(m))
            end
        else
            for i = 1, BJ_MAX_PLAYERS do
                if (duration == nil or duration < 5) then
                    J.DisplayTextToPlayer(J.Player(i - 1), x, y, i18n.tr(m))
                else
                    J.DisplayTimedTextToPlayer(J.Player(i - 1), x, y, duration, i18n.tr(m))
                end
            end
        end
    end
    if (type(msg) == "string") then
        _e(msg)
    elseif (type(msg) == "table" and #msg > 0) then
        for _, m in ipairs(msg) do
            _e(m)
        end
    else
        _e(tostring(msg))
    end
end
