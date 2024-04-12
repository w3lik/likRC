--- #单位 token
_slk_unit({ _parent = "ogru" })

--- #单位复活时间圈
_slk_unit({ _parent = "ogru" })

--- #模板物品
_slk_unit({ _parent = "ogru" })

--- #模板扎根
_slk_ability({ _parent = "Aro2" })

-- #隐身
_slk_ability({ _parent = "Apiv" })

--- #JAPI_DELAY
_slk_ability({ _parent = "Aamk" })

--- #回避(伤害)+
_slk_ability({ _parent = "AIlf" })
--- #回避(伤害)-
_slk_ability({ _parent = "AIlf" })

--- #视野
local sightBase = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 1000) do
    for _ = 1, #sightBase do
        -- #视野+|-
        _slk_ability({ _parent = "AIsi" })
        _slk_ability({ _parent = "AIsi" })
    end
    i = i * 10
end

-- #反隐
for _ = 1, 20, 1 do
    _slk_ability({ _parent = "Adts" })
end
