local isDef = function(path)
    local i = string.find(path, ":")
    return i == 1
end

---@private
---@alias noteSlkUnit {modelAlias,Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
---@return {_id:string}
function _slk_unit(_v) FRAMEWORK_SETTING(_SLK_UNIT(_v)) end

---@private
---@return {_id:string}
function _slk_ability(_v) FRAMEWORK_SETTING(_SLK_ABILITY(_v)) end

---@private
---@return {_id:string}
function _slk_destructable(_v) FRAMEWORK_SETTING(_SLK_DESTRUCTABLE(_v)) end

--- 只支持组件包
---@param typeName string
---@return void
function _assets_selection(typeName) end

--- 只支持ttf
---@param ttfName string
---@return void
function _assets_font(ttfName) end

--- 只支持tga
---@param tga string
---@return void
function _assets_loading(tga) end

--- 只支持tga
---@param tga string
---@return void
function _assets_preview(tga) end

--- 原生首符号加:冒号
--- 只支持tga
---@param path string
---@param alias string|nil
---@return void
function _assets_icon(path, alias)
    if (path) then
        path = string.trim(string.gsub(path, "%.tga", ""))
        alias = alias or path
        FRAMEWORK_ICON[alias] = path
    end
end

--- 原生首符号加:冒号
--- 只支持mdx,自动贴图路径必须war3mapTextures开头，文件放入assets/war3mapTextures内
---@param path string
---@param alias string|nil
---@return void
function _assets_model(path, alias)
    if (path) then
        path = string.gsub(path, "%.mdx", "")
        path = string.gsub(path, "%.mdl", "")
        path = string.trim(path)
        if (alias == nil or alias == "") then
            alias = path
        end
        FRAMEWORK_MODEL[alias] = path
    end
end

--- 不支持原生音频！
--- 只支持mp3
--- 音效建议使用：48000HZ 192K 单通道
--- 音乐建议使用：48000HZ 320K
---@type fun(path:string, alias:string|nil, soundType:string | "vcm"| "v3d" | "bgm" | "vwp"):void
function _assets_sound(path, alias, soundType)
    if (path) then
        path = string.trim(string.gsub(path, "%.mp3", ""))
        alias = alias or path
        FRAMEWORK_SOUND[soundType][alias] = path
    end
end

--- 只支持UI套件
--- UI套件需按要求写好才能被正确调用！
---@type fun(kit:string):void
function _assets_ui(kit) end

--- 只支持Plugins插件
--- Plugins插件需按要求写好才能被正确调用！
---@type fun(kit:string):void
function _assets_plugins(kit) end

---@param _v noteSlkUnit
---@return noteSlkUnit
function _assets_speech_extra(_v) return _v end

--- 只支持原生单位语音
---@param path string
---@param alias string|nil
---@param extra table<string,noteSlkUnit>
---@return void
function _assets_speech(path, alias, extra)
    if (path ~= nil) then
        path = string.trim(path)
        if (alias == nil) then
            alias = path
        end
        if (false == isDef(path)) then
            print("Speech must be default voice:", path)
            return
        else
            path = string.sub(path, 2)
        end
        _slk_unit({})
        FRAMEWORK_SPEECH[alias] = true
        if (type(extra) == "table") then
            for _, e in pairx(extra) do
                if (type(e) == "table") then
                    _slk_unit({})
                end
            end
        end
    end
end

--- 原生首符号加:冒号
--- 只支持mdx,自动贴图路径必须war3mapTextures开头，文件放入assets/war3mapTextures内
---@alias noteAssetsDestOptions {targType:string,fogVis:number,showInMM:number,occH:number,colorR:number,colorG:number,colorB:number,minScale:number,maxScale:number,numVar:number,selectable:boolean,selSize:number,selcircsize:number,texID:number,texFile:string}
---@param path string
---@param alias string|nil
---@param extra noteAssetsDestOptions
function _assets_destructable(path, alias, extra)
    if (path) then
        path = string.gsub(path, "%.mdx", "")
        path = string.gsub(path, "%.mdl", "")
        path = string.trim(path)
        if (alias == nil or alias == "") then
            alias = path
        end
        _slk_destructable({})
        FRAMEWORK_DESTRUCTABLE[alias] = path
    end
end