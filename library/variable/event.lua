-- 事件定义
EVENT = EVENT or {}

---@alias noteOnPropBase {key:"对应属性key", old:"旧值", new:"新值"}
---@alias noteOnPropGame noteOnPropBase|{triggerObject:Game}
---@alias noteOnPropPlayer noteOnPropBase|{triggerObject:Player}
---@alias noteOnPropUnit noteOnPropBase|{triggerObject:Unit}
---@alias noteOnPropAbility noteOnPropBase|{triggerObject:Ability}
---@alias noteOnPropItem noteOnPropBase|{triggerObject:Item}
EVENT.Prop = {
    --- 游戏参数改变前
    BeforeChange = "propBeforeChange",
    --- 游戏参数改变后
    Change = "propChange",
}

---@alias noteOnObjectConstructData {triggerObject:Object}
---@alias noteOnObjectDestructData {triggerObject:Object}
---@alias noteOnAIDestructData {triggerObject:AI} AI
---@alias noteOnAbilityDestructData {triggerObject:Ability} 技能
---@alias noteOnEffectDestructData {triggerObject:Effect} 特效
---@alias noteOnItemDestructData {triggerObject:Item} 物品
---@alias noteOnUnitDestructData {triggerObject:Unit} 单位
---@alias noteOnTimerDestructData {triggerObject:Timer} 计时器
EVENT.Object = {
    --- 对象创建
    Construct = "ObjectConstruct",
    --- 对象毁灭
    Destruct = "ObjectDestruct",
}

EVENT.Game = {
    --- 游戏初始化执行时(此事件初始化后会自动销毁)
    ---@alias noteOnGameStartData nil
    Init = "gameInit",
    --- 开始游戏(此事件游戏开始后会自动销毁)
    ---@alias noteOnGameStartData nil
    Start = "gameStart",
    --- 进入凌晨
    ---@alias noteOnGameDawnData nil
    Dawn = "gameDawn",
    --- 进入白天
    ---@alias noteOnGameDayData nil
    Day = "gameDay",
    --- 进入正午
    ---@alias noteOnGameNoonData nil
    Noon = "gameNoon",
    --- 进入黑夜
    ---@alias noteOnGameNightData nil
    Night = "gameNight",
}

---@alias noteOnPlayerBase {triggerPlayer:Player}
EVENT.Player = {
    --- 玩家聊天
    ---@alias noteOnPlayerChatData noteOnPlayerBase|{chatString:"聊天的内容",matchedString:"匹配命中的内容"}
    Chat = "playerChat",
    --- 玩家按下Esc
    ---@alias noteOnPlayerEscData noteOnPlayerBase
    Esc = "playerEsc",
    --- 玩家选中单位
    ---@alias noteOnPlayerSelectUnitData noteOnPlayerBase|{triggerUnit:Unit}
    SelectUnit = "playerSelectUnit",
    --- 玩家取消选择单位
    ---@alias noteOnPlayerDeSelectUnitData noteOnPlayerBase|{triggerUnit:Unit}
    DeSelectUnit = "playerDeSelectUnit",
    --- 玩家选中物品
    ---@alias noteOnPlayerSelectItemData noteOnPlayerBase|{triggerItem:Item}
    SelectItem = "playerSelectItem",
    --- 玩家取消选择物品
    ---@alias noteOnPlayerDeSelectItemData noteOnPlayerBase|{triggerUnit:Unit}
    DeSelectItem = "playerDeSelectItem",
    --- 玩家离开游戏
    ---@alias noteOnPlayerQuitData noteOnPlayerBase
    Quit = "playerQuit",
    --- 仓库栏有所变化
    ---@alias noteOnPlayerWarehouseSlotChangeData noteOnPlayerBase|{triggerSlot:WarehouseSlot}
    WarehouseSlotChange = "playerWarehouseSlotChange",
}

---@alias noteOnUnitBase {triggerUnit:Unit,triggerAbility:Ability,triggerItem:Item}
EVENT.Unit = {
    --- 准备攻击
    ---@alias noteOnUnitBeforeAttackData noteOnUnitBase|{targetUnit:Unit}
    BeforeAttack = "unitBeforeAttack",
    --- 攻击
    ---@alias noteOnUnitAttackData noteOnUnitDamageData
    Attack = "unitAttack",
    --- 回避
    ---@alias noteOnUnitAvoidData noteOnUnitBase|{sourceUnit:Unit}
    Avoid = "unitAvoid",
    --- 破防
    ---@alias noteOnUnitBreakArmorData noteOnUnitBase|{targetUnit:Unit,breakType:"无视类型"}
    BreakArmor = "unitBreakArmor",
    --- 护盾减少
    ---@alias noteOnUnitShieldData noteOnUnitBase|{targetUnit:Unit,value:"破盾值"}
    Shield = "unitShield",
    --- 击飞目标
    ---@alias noteOnUnitCrackFlyData noteOnUnitBase|{targetUnit:Unit,distance:"击退距离",height:"击飞高度",duration:"凌空时长"}
    CrackFly = "unitCrackFly",
    --- 暴击目标（自身属性方式）
    ---@alias noteOnUnitCritData noteOnUnitBase|{targetUnit:Unit}
    Crit = "unitCrit",
    --- 暴击目标（调用技能方式）
    ---@alias noteOnUnitCritAbilityData noteOnUnitBase|{targetUnit:Unit}
    CritAbility = "unitCritAbility",
    --- 造成伤害
    ---@alias noteOnUnitDamageData noteOnUnitBase|{targetUnit:Unit,damage:"伤害值",damageSrc:"伤害来源",damageType:"伤害类型"}
    Damage = "unitDamage",
    --- 单位出生
    ---@alias noteOnUnitBornData noteOnUnitBase
    Born = "unitBorn",
    --- 单位死亡
    ---@alias noteOnUnitDeadData noteOnUnitBase|{sourceUnit:Unit}
    Dead = "unitDead",
    --- 单位假死（可以复活的单位被击杀时触发）
    ---@alias noteOnUnitFeignDeadData noteOnUnitDeadData
    FeignDead = "unitFeignDead",
    --- 复活
    ---@alias noteOnUnitRebornData noteOnUnitBase
    Reborn = "unitReborn",
    --- 候住命令
    ---@alias noteOnUnitOrderHoldData noteOnUnitBase
    OrderHold = "unitOrderHold",
    --- 停止命令
    ---@alias noteOnUnitOrderStopData noteOnUnitBase
    OrderStop = "unitOrderStop",
    --- 移动命令
    ---@alias noteOnUnitOrderMoveData noteOnUnitBase|{targetX:number,targetY:number}
    OrderMove = "unitOrderMove",
    --- 攻击命令
    ---@alias noteOnUnitOrderAttackData noteOnUnitBase|{targetX:number,targetY:number}
    OrderAttack = "unitOrderAttack",
    --- 附魔反应
    ---@alias noteOnUnitEnchantData noteOnUnitBase|{sourceUnit:Unit,enchantType:"附魔类型",percent:"加成百分比"}
    Enchant = "unitEnchant",
    --- 攻击吸血
    ---@alias noteOnUnitHPSuckAttackData noteOnUnitBase|{targetUnit:Unit,value:"吸血值",percent:"吸血百分比"}
    HPSuckAttack = "unitHPSuckAttack",
    --- 技能吸血
    ---@alias noteOnUnitHPSuckAbilityData noteOnUnitBase|{targetUnit:Unit,value:"吸血值",percent:"吸血百分比"}
    HPSuckAbility = "unitHPSuckAbility",
    --- 单位受伤
    ---@alias noteOnUnitHurtData noteOnUnitBase|{sourceUnit:Unit,targetUnit:Unit,damage:"伤害值",damageSrc:"伤害来源",damageType:"伤害类型"}
    Hurt = "unitHurt",
    --- 单位受伤前
    ---@alias noteOnUnitBeforeHurtData noteOnUnitHurtData
    BeforeHurt = "unitBeforeHurt",
    --- 全抵抗[防御]
    ---@alias noteOnUnitImmuneDefendData noteOnUnitBase|{sourceUnit:Unit}
    ImmuneDefend = "unitImmuneDefend",
    --- 全抵抗[无敌]
    ---@alias noteOnUnitImmuneInvincibleData noteOnUnitBase|{sourceUnit:Unit}
    ImmuneInvincible = "unitImmuneInvincible",
    --- 全抵抗[减伤]
    ---@alias noteOnUnitImmuneReductionData noteOnUnitBase|{sourceUnit:Unit}
    ImmuneReduction = "unitImmuneReduction",
    --- 免疫[附魔]
    ---@alias noteOnUnitImmuneEnchantData noteOnUnitBase|{sourceUnit:Unit,enchantType:"附魔类型"}
    ImmuneEnchant = "unitImmuneEnchant",
    --- 单位杀敌
    ---@alias noteOnUnitKillData noteOnUnitBase|{targetUnit:Unit}
    Kill = "unitKill",
    --- 闪电链击中目标
    ---@alias noteOnUnitLightningChainData noteOnUnitBase|{targetUnit:Unit,index:"链索引"}
    LightningChain = "unitLightningChain",
    --- 攻击吸魔
    ---@alias noteOnUnitMPSuckAttackData noteOnUnitBase|{targetUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
    MPSuckAttack = "unitMPSuckAttack",
    --- 技能吸魔
    ---@alias noteOnUnitMPSuckAbilityData noteOnUnitBase|{targetUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
    MPSuckAbility = "unitMPSuckAbility",
    --- 移动开始
    ---@alias noteOnUnitMoveStartData noteOnUnitBase|{x:"目标X",y:"目标Y"}
    MoveStart = "unitMoveStart",
    --- 移动停止
    ---@alias noteOnUnitMoveStopData noteOnUnitBase
    MoveStop = "unitMoveStop",
    --- 移动转向
    ---@alias noteOnUnitMoveTurnData noteOnUnitBase|{x:"当前X",y:"当前Y"}
    MoveTurn = "unitMoveTurn",
    --- 移动中
    ---@alias noteOnUnitMovingData noteOnUnitBase|{x:"当前X",y:"当前Y",step:"第几步"}
    Moving = "unitMoving",
    --- 移动路由
    ---@alias noteOnUnitMoveRouteData noteOnUnitBase|{x:"当前X",y:"当前Y"}
    MoveRoute = "unitMoveRoute",
    --- 硬直
    ---@alias noteOnUnitPunishData noteOnUnitBase|{sourceUnit:Unit,percent:"硬直程度",duration:"持续时间"}
    Punish = "unitPunish",
    --- 反伤
    ---@alias noteOnUnitReboundData noteOnUnitDamageData
    Rebound = "unitRebound",
    --- 分裂
    ---@alias noteOnUnitSplitData noteOnUnitBase|{targetUnit:Unit,radius:number}
    Split = "unitSplit",
    --- 眩晕
    ---@alias noteOnUnitStunData noteOnUnitBase|{targetUnit:Unit,duration:number}
    Stun = "unitStun",
    --- 破护盾
    ---@alias noteOnUnitBreakShieldData noteOnUnitBase|{targetUnit:Unit}
    BreakShield = "unitBreakShield",
    --- 等级改变
    ---@alias noteOnUnitLevelChangeData noteOnUnitBase|{value:"变值差额"}
    LevelChange = "unitLevelChange",
    --- 技能栏有所变化
    ---@alias noteOnUnitAbilitySlotChangeData noteOnUnitBase|{triggerSlot:AbilitySlot}
    AbilitySlotChange = "unitAbilitySlotChange",
    --- 物品栏有所变化
    ---@alias noteOnUnitItemSlotChangeData noteOnUnitBase|{triggerSlot:ItemSlot}
    ItemSlotChange = "unitItemSlotChange",
    --- 陷入中止
    ---@alias noteOnUnitInterruptInData noteOnUnitBase
    InterruptIn = "unitInterruptIn",
    --- 脱离中止
    ---@alias noteOnUnitInterruptOutData noteOnUnitBase
    InterruptOut = "unitInterruptOut",
    --- 被
    Be = {
        --- 被准备攻击
        ---@alias noteOnUnitBeBeforeAttackData noteOnUnitBase|{sourceUnit:Unit}
        BeforeAttack = "be:unitBeforeAttack",
        --- 被攻击
        ---@alias noteOnUnitBeAttackData noteOnUnitHurtData
        Attack = "be:unitAttack",
        --- 单位被杀
        ---@alias noteOnUnitBeKillData noteOnUnitBase|{sourceUnit:Unit}
        Kill = "be:unitKill",
        --- 被回避
        ---@alias noteOnUnitBeAvoidData noteOnUnitBase|{targetUnit:Unit}
        Avoid = "be:unitAvoid",
        --- 被破防
        ---@alias noteOnUnitBeBreakArmorData noteOnUnitBase|{sourceUnit:Unit,breakType:"无视类型"}
        BreakArmor = "be:unitBreakArmor",
        --- 被减少护盾
        ---@alias noteOnUnitBeShieldData noteOnUnitBase|{sourceUnit:Unit,value:"减盾值"}
        Shield = "be:unitShield",
        --- 被击飞
        ---@alias noteOnUnitBeCrackFlyData noteOnUnitBase|{sourceUnit:Unit,distance:"击退距离",height:"击飞高度",duration:"凌空时长"}
        CrackFly = "be:unitCrackFly",
        --- 被暴击（本体属性方式）
        ---@alias noteOnUnitBeCritData noteOnUnitBase|{sourceUnit:Unit}
        Crit = "be:unitCrit",
        --- 被暴击（调用技能方式）
        ---@alias noteOnUnitCritAbilityData noteOnUnitBase|{sourceUnit:Unit}
        CritAbility = "be:unitCritAbility",
        --- 被攻击吸血
        ---@alias noteOnUnitBeHPSuckAttackData noteOnUnitBase|{sourceUnit:Unit,value:"吸血值",percent:"吸血百分比"}
        HPSuckAttack = "be:unitHPSuckAttack",
        --- 被技能吸血
        ---@alias noteOnUnitBeHPSuckAbilityData noteOnUnitBase|{sourceUnit:Unit,value:"吸血值",percent:"吸血百分比"}
        HPSuckAbility = "be:unitHPSuckAbility",
        --- 被闪电链击中
        ---@alias noteOnUnitBeLightningChainData noteOnUnitBase|{sourceUnit:Unit,index:"链索引"}
        LightningChain = "be:unitLightningChain",
        --- 被攻击吸魔
        ---@alias noteOnUnitBeMPSuckAttackData noteOnUnitBase|{sourceUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
        MPSuckAttack = "be:unitMPSuckAttack",
        --- 被技能吸魔
        ---@alias noteOnUnitBeMPSuckAbilityData noteOnUnitBase|{sourceUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
        MPSuckAbility = "be:unitMPSuckAbility",
        --- 被反伤
        ---@alias noteOnUnitBeReboundData noteOnUnitHurtData
        Rebound = "be:unitRebound",
        --- 被分裂[核心型]
        ---@alias noteOnUnitBeSplitData noteOnUnitBase|{sourceUnit:Unit,radius:number}
        Split = "be:unitSplit",
        --- 被分裂[扩散型]
        ---@alias noteOnUnitBeSplitSpreadData noteOnUnitBase|{sourceUnit:Unit}
        SplitSpread = "be:unitSplitSpread",
        --- 被眩晕
        ---@alias noteOnUnitBeStunData noteOnUnitBase|{sourceUnit:Unit,duration:number}
        Stun = "be:unitStun",
        --- 被破护盾
        ---@alias noteOnUnitBeBreakShieldData noteOnUnitBase|{sourceUnit:Unit}
        BreakShield = "be:unitBreakShield",
    }
}

---@alias noteOnAbilityBase {triggerAbility:Ability,triggerUnit:Unit}
EVENT.Ability = {
    -- 当单位获得技能
    ---@alias noteOnAbilityGetData noteOnAbilityBase
    Get = "abilityGet",
    --- 单位失去技能
    ---@alias noteOnAbilityLoseData noteOnAbilityBase
    Lose = "abilityLose",
    --- 单位开始施放技能（施法瞬间）
    ---@alias noteOnAbilitySpellData noteOnAbilityBase|{triggerItem:Item,targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
    Spell = "abilitySpell",
    --- 技能生效
    ---@alias noteOnAbilityEffectiveData noteOnAbilitySpellData
    Effective = "abilityEffective",
    --- 技能持续施法每周期时（动作时）
    ---@alias noteOnAbilityCastingData noteOnAbilitySpellData
    Casting = "abilityCasting",
    --- 停止施放技能（吟唱、持续施法有停止状态）
    ---@alias noteOnAbilityStopData noteOnAbilityBase
    Stop = "abilityStop",
    --- 施放技能结束（只有持续施法有结束状态）
    ---@alias noteOnAbilityOverData noteOnAbilityBase
    Over = "abilityOver",
    --- 等级改变
    ---@alias noteOnAbilityLevelChangeData noteOnAbilityBase|{value:"变值差额"}
    LevelChange = "abilityLevelChange",
}

---@alias noteOnItemBase {triggerItem:Item,triggerUnit:Unit}
EVENT.Item = {
    --- 捡取物品
    ---@alias noteOnItemPickData noteOnItemBase
    Pick = "itemPick",
    --- 获得物品
    ---@alias noteOnItemGetData noteOnItemBase
    Get = "itemGet",
    --- 失去物品
    ---@alias noteOnItemLoseData noteOnItemBase
    Lose = "itemLose",
    --- 使用物品
    ---@alias noteOnItemUsedData noteOnItemBase|noteOnAbilityEffectiveData
    Used = "itemUsed",
    --- 丢弃物品
    ---@alias noteOnItemDropData noteOnItemBase|{targetX:number,targetY:number}
    Drop = "itemDrop",
    --- 传递物品
    ---@alias noteOnItemDeliverData noteOnItemBase|{targetUnit:Unit}
    Deliver = "itemDeliver",
    --- 抵押物品（持有人售出）
    ---@alias noteOnItemPawnData noteOnItemBase
    Pawn = "itemPawn",
    --- 等级改变
    ---@alias noteOnItemLevelChangeData noteOnItemBase|{value:"变值差额"}
    LevelChange = "itemLevelChange",
    --- 物品死亡
    ---@alias noteOnItemDeadData noteOnItemBase|{sourceUnit:Unit}
    Dead = "itemDead",
    --- 被
    Be = {
        --- 被攻击
        ---@alias noteOnItemBeAttackData noteOnItemBase|{sourceUnit:Unit,damage:"伤害值"}
        Attack = "be:itemAttack",
    }
}

---@alias noteOnStoreBase {triggerStore:Store}
EVENT.Store = {
    --- 卖出货品
    ---@alias noteOnStoreSellData noteOnStoreBase|{qty:"卖出数量"}
    Sell = "storeSell",
}

---@alias noteOnRegionBase {triggerRegion:Region}
EVENT.Region = {
    --- 进入区域
    ---@alias noteOnRegionEnterData noteOnRegionBase|{triggerUnit:Unit}
    Enter = "rectEnter",
    --- 离开区域
    ---@alias noteOnRegionLeaveData noteOnRegionBase|{triggerUnit:Unit}
    Leave = "rectLeave",
}

---@alias noteOnAuraBase {triggerAura:Aura}
EVENT.Aura = {
    --- 进入领域
    ---@alias noteOnAuraEnterData noteOnAuraBase|{triggerUnit:Unit}
    Enter = "auraEnter",
    --- 离开领域
    ---@alias noteOnAuraLeaveData noteOnAuraBase|{triggerUnit:Unit}
    Leave = "auraLeave",
}

---@alias noteOnDestructableBase {triggerDestructable:number}
EVENT.Destructable = {
    --- 可破坏物死亡
    ---@alias noteOnDestructableDeadData noteOnDestructableBase|{name:"不可靠名称",x:"坐标X",y:"坐标Y"}
    Dead = "destructableDead",
}

---@alias noteOnFrameBase {triggerFrame:Frame}
EVENT.Frame = {
    --- 显示
    ---@alias noteOnFrameShowData noteOnFrameBase
    Show = "frameShow",
    --- 隐藏
    ---@alias noteOnFrameHideData noteOnFrameBase
    Hide = "frameHide",
    --- 左键点击
    ---@alias noteOnFrameLeftClickData noteOnFrameBase|{triggerPlayer:Player}
    LeftClick = "frameLeftClick",
    --- 左键释放
    ---@alias noteOnFrameLeftReleaseData noteOnFrameBase|{triggerPlayer:Player,status:"鼠标是否还在Frame内"}
    LeftRelease = "frameLeftRelease",
    --- 右键点击
    ---@alias noteOnFrameRightClickData noteOnFrameBase|{triggerPlayer:Player}
    RightClick = "frameRightClick",
    --- 右键释放
    ---@alias noteOnFrameRightReleaseData noteOnFrameBase|{triggerPlayer:Player,status:"鼠标是否还在Frame内"}
    RightRelease = "frameRightRelease",
    --- 在上移动
    ---@alias noteOnFrameMoveData noteOnFrameBase|{triggerPlayer:Player}
    Move = "frameMove",
    --- 移入
    ---@alias noteOnFrameEnterData noteOnFrameBase|{triggerPlayer:Player}
    Enter = "frameEnter",
    --- 移出
    ---@alias noteOnFrameLeaveData noteOnFrameBase|{triggerPlayer:Player}
    Leave = "frameLeave",
    --- 滚动
    ---@alias noteOnFrameWheelData noteOnFrameBase|{triggerPlayer:Player,delta:"滚动数值"}
    Wheel = "frameWheel",
    --- 拖拽开始
    ---@alias noteOnFrameDragStartData noteOnFrameBase|{triggerPlayer:Player}
    DragStart = "frameDragStart",
    --- 拖拽结束
    ---@alias noteOnFrameDragStopData noteOnFrameBase|{triggerPlayer:Player}
    DragStop = "frameDragStop",
}

---@alias noteOnAIBase {triggerAI:AI}
EVENT.AI = {
    --- 关连单位
    ---@alias noteOnAILinkData noteOnAIBase|{triggerUnit:Unit}
    Link = "aiLink",
    --- 断连单位
    ---@alias noteOnAIUnlinkData noteOnAIBase|{triggerUnit:Unit}
    Unlink = "aiUnlink",
}