-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetTime = GetTime
local GetSpellBookIndex = GetSpellBookIndex
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitClassification = UnitClassification
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local stringFind = string.find
local stringLower = string.lower
local stringGmatch = string.gmatch

local PossiblyEngineTempTable1 = { }
local rangeCheck = LibStub("LibRangeCheck-2.0")
local LibDispellable = LibStub("LibDispellable-1.0")
local LibBoss = LibStub("LibBoss-1.0")

local UnitBuff = function(target, spell, owner)
    local buff, count, caster, expires, spellID
    if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
        i = i + 1
        buff,_,_,count,_,_,expires,caster,_,_,spellID = _G['UnitBuff'](target, i)
        if not owner then
        if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
        if spellID == tonumber(spell) then go = false end
        end
    end
    else
    buff,_,_,count,_,_,expires,caster = _G['UnitBuff'](target, spell)
    end
    return buff, count, expires, caster
end

local UnitDebuff = function(target, spell, owner)
    local debuff, count, caster, expires, spellID
    if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
        i = i + 1
        debuff,_,_,count,_,_,expires,caster,_,_,spellID,_,_,_,power = _G['UnitDebuff'](target, i)
        if not owner then
        if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
        if spellID == tonumber(spell) then go = false end
        end
    end
    else
    debuff,_,_,count,_,_,expires,caster = _G['UnitDebuff'](target, spell)
    end
    return debuff, count, expires, caster, power
end

PossiblyEngine.condition.register("dispellable", function(target, spell)
    if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("buff", function(target, spell)
    local buff,_,_,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("buff.any", function(target, spell)
    local buff,_,_,caster = UnitBuff(target, spell, "any")
    if not not buff then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("buff.count", function(target, spell)
    local buff,count,_,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return count
    end
    return 0
end)

PossiblyEngine.condition.register("debuff", function(target, spell)
    local debuff,_,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("debuff.any", function(target, spell)
    local debuff,_,_,caster = UnitDebuff(target, spell, "any")
    if not not debuff then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("debuff.count", function(target, spell)
    local debuff,count,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return count
    end
    return 0
end)

PossiblyEngine.condition.register("debuff.remains", function(target, spell)
  local debuff,_,expires,caster = UnitDebuff(target, spell)
  if not not debuff and (caster == 'player' or caster == 'pet') then
    return (expires - GetTime())
  end
  return 0
end)

-- TODO: should be the initial duration when cast.
PossiblyEngine.condition.register("debuff.duration", function(target, spell)
    local debuff,_,expires,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

PossiblyEngine.condition.register("buff.remains", function(target, spell)
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

-- TODO: should be the initial duration when cast.
PossiblyEngine.condition.register("buff.duration", function(target, spell)
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
      return (expires - GetTime())
    end
    return 0
end)

--[[
PossiblyEngine.condition.register("aura.", function(target, spell)
    local guid = UnitGUID(target)
    if guid then
        local unit = PossiblyEngine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            local track = false
            if aura['damage'] and not aura['heal'] then
                track = aura['damage']
            elseif aura['heal'] and not aura['damage'] then
                track = aura['heal']
            end
            if track then
                return track.
            end
        end
    end
    return false
end)
]]

local function smartQueryTracker(target, spell, key)
    local guid = UnitGUID(target)
    if guid then
        local unit = PossiblyEngine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            if aura then
                local track = false
                if key == 'stacks' or key == 'time' then
                    track = aura
                else
                    if aura['damage'] and not aura['heal'] then
                        track = aura['damage']
                    elseif aura['heal'] and not aura['damage'] then
                        track = aura['heal']
                    end
                end
                if track then
                    return track[key]
                end
            end
        end
    end
    return false
end

PossiblyEngine.condition.register("aura.crit", function(target, spell)
    return smartQueryTracker(target, spell, 'crit')
end)

PossiblyEngine.condition.register("aura.crits", function(target, spell)
    return smartQueryTracker(target, spell, 'crits')
end)

PossiblyEngine.condition.register("aura.avg", function(target, spell)
    return smartQueryTracker(target, spell, 'avg')
end)

PossiblyEngine.condition.register("aura.last", function(target, spell)
    return smartQueryTracker(target, spell, 'last')
end)

PossiblyEngine.condition.register("aura.low", function(target, spell)
    return smartQueryTracker(target, spell, 'low')
end)

PossiblyEngine.condition.register("aura.high", function(target, spell)
    return smartQueryTracker(target, spell, 'high')
end)

PossiblyEngine.condition.register("aura.total", function(target, spell)
    return smartQueryTracker(target, spell, 'total')
end)

PossiblyEngine.condition.register("aura.stacks", function(target, spell)
    return smartQueryTracker(target, spell, 'stacks')
end)

PossiblyEngine.condition.register("aura.time", function(target, spell)
    return smartQueryTracker(target, spell, 'time')
end)

PossiblyEngine.condition.register("aura.uptime", function(target, spell)
    return smartQueryTracker(target, spell, 'time') - GetTime()
end)

PossiblyEngine.condition.register("stance", function(target, spell)
    return GetShapeshiftForm()
end)

PossiblyEngine.condition.register("form", function(target, spell)
    return GetShapeshiftForm()
end)

PossiblyEngine.condition.register("seal", function(target, spell)
    return GetShapeshiftForm()
end)

PossiblyEngine.condition.register("focus", function(target, spell)
    return UnitPower(target, SPELL_POWER_FOCUS)
end)

PossiblyEngine.condition.register("holypower", function(target, spell)
    return UnitPower(target, SPELL_POWER_HOLY_POWER)
end)

PossiblyEngine.condition.register("shadoworbs", function(target, spell)
    return UnitPower(target, SPELL_POWER_SHADOW_ORBS)
end)

PossiblyEngine.condition.register("energy", function(target, spell)
    return UnitPower(target, SPELL_POWER_ENERGY)
end)

PossiblyEngine.condition.register("timetomax", function(target, spell)
    local max = UnitPowerMax(target)
    local curr = UnitPower(target)
    local regen = select(2, GetPowerRegen(target))
    return (max - curr) * (1.0 / regen)
end)

PossiblyEngine.condition.register("tomax", function(target, spell)
    return PossiblyEngine.condition["timetomax"](toggle)
end)

PossiblyEngine.condition.register("rage", function(target, spell)
    return UnitPower(target, SPELL_POWER_RAGE)
end)

PossiblyEngine.condition.register("chi", function(target, spell)
    return UnitPower(target, SPELL_POWER_CHI)
end)

PossiblyEngine.condition.register("demonicfury", function(target, spell)
    return UnitPower(target, SPELL_POWER_DEMONIC_FURY)
end)

PossiblyEngine.condition.register("embers", function(target, spell)
    return UnitPower(target, SPELL_POWER_BURNING_EMBERS, true)
end)

PossiblyEngine.condition.register("soulshards", function(target, spell)
    return UnitPower(target, SPELL_POWER_SOUL_SHARDS)
end)

PossiblyEngine.condition.register("behind", function(target, spell)
    return PossiblyEngine.module.player.behind
end)

PossiblyEngine.condition.register("infront", function(target, spell)
    return PossiblyEngine.module.player.infront
end)

PossiblyEngine.condition.register("disarmable", function(target, spell)
    return PossiblyEngine.module.disarm.check(target)
end)

PossiblyEngine.condition.register("combopoints", function()
    return GetComboPoints('player', 'target')
end)

PossiblyEngine.condition.register("alive", function(target, spell)
    if UnitExists(target) and UnitHealth(target) > 0 then
    return true
    end
    return false
end)

PossiblyEngine.condition.register('dead', function (target)
    return UnitIsDeadOrGhost(target)
end)

PossiblyEngine.condition.register('swimming', function ()
    return IsSwimming()
end)

PossiblyEngine.condition.register("target", function(target, spell)
    return ( UnitGUID(target .. "target") == UnitGUID(spell) )
end)

--[[
PossiblyEngine.condition.register("player", function(target, spell)
    return UnitName('player') == UnitName(target)
end)--]]

PossiblyEngine.condition.register("player", function (target)
    return UnitIsPlayer(target)
end)

PossiblyEngine.condition.register("exists", function(target)
    return (UnitExists(target))
end)

PossiblyEngine.condition.register("modifier.looting", function()
    return GetNumLootItems() > 0
end)

PossiblyEngine.condition.register("modifier.shift", function()
    return IsShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.control", function()
    return IsControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.alt", function()
    return IsAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.lshift", function()
    return IsLeftShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.lcontrol", function()
    return IsLeftControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.lalt", function()
    return IsLeftAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.rshift", function()
    return IsRightShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.rcontrol", function()
    return IsRightControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.ralt", function()
    return IsRightAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

PossiblyEngine.condition.register("modifier.player", function()
    return UnitIsPlayer("target")
end)

PossiblyEngine.condition.register("classification", function (target, spell)
    if not spell then return false end
    local classification = UnitClassification(target)
    if stringFind(spell, '[%s,]+') then
    for classificationExpected in stringGmatch(spell, '%a+') do
        if classification == stringLower(classificationExpected) then
        return true
        end
    end
    return false
    else
    return UnitClassification(target) == stringLower(spell)
    end
end)

PossiblyEngine.condition.register('boss', function (target, spell)
    local classification = UnitClassification(target)
    if spell == 'true' and (classification == 'rareelite' or classification == 'rare') then
    return true
    end
    if classification == 'worldboss' or LibBoss[UnitId(target)] then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("id", function(target, id)
    local expectedID = tonumber(id)
    if expectedID and UnitID(target) == expectedID then
        return true
    end
    return false
end)

PossiblyEngine.condition.register("toggle", function(toggle)
    return PossiblyEngine.condition["modifier.toggle"](toggle)
end)

PossiblyEngine.condition.register("modifier.toggle", function(toggle)
    return PossiblyEngine.config.read('button_states', toggle, false)
end)

PossiblyEngine.condition.register("modifier.taunt", function()
    if PossiblyEngine.condition["modifier.toggle"]('taunt') then
        if UnitThreatSituation("player", "target") then
            local status = UnitThreatSituation("player", "target")
            return (status < 3)
        end
        return false
    end
    return false
end)

PossiblyEngine.condition.register("threat", function(target)
    if UnitThreatSituation("player", target) then
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", target)
    return scaledPercent
    end
    return 0
end)

PossiblyEngine.condition.register("agro", function(target)
    if UnitThreatSituation(target) and UnitThreatSituation(target) >= 2 then
    return true
    end
    return false
end)


PossiblyEngine.condition.register("balance.sun", function(target)
    local direction = GetEclipseDirection()
    if direction and direction == "sun" then return true end
    return false
end)

PossiblyEngine.condition.register("balance.moon", function(target)
    local direction = GetEclipseDirection()
    if direction and direction == "moon" then return true end
    return false
end)

--[[
PossiblyEngine.condition.register("balance.eclipsechange", function(target, spell)
  -- Eclipse power goes from -100 to 100, and its use as solar or lunar power is determined by what buff is active on the player.
  -- Buffs activate at -100 and 11 respectively and remain on the player until the power crosses the 0 threshold.
  -- moon == moving toward Lunar Eclipse
  -- sun == moving toward Solar Eclipse
  -- /script print("Eclipse direction: "..GetEclipseDirection().."  Eclipse: "..UnitPower("player", 8))
    if not spell then return false end
    local direction = GetEclipseDirection()
    if not direction or direction == "none" then return false end
    local name, _, _, _, _, _, casttime, _, _ = GetSpellInfo(spell)
    if name and casttime then casttime = casttime / 1000 else return false end
    local eclipse = UnitPower("player", 8)
    local timetozero = 0
    local eclipsepersecond = 5

    -- Euphoria Check
    local group = GetActiveSpecGroup()
    local _, _, _, selected, active = GetTalentInfo(7, 1, group)
    if selected and active then
      eclipsepersecond = 10
    end

    if direction == "moon" and eclipse > 0 then
      timetozero = eclipse / eclipsepersecond
    elseif direction == "moon" and eclipse <= 0 then
      timetozero = ( 100 + ( 100 - math.abs(eclipse) ) ) / eclipsepersecond
    elseif direction == "sun" and eclipse >= 0 then
      timetozero = ( 100 + ( 100 - eclipse ) ) / eclipsepersecond
    elseif direction == "sun" and eclipse < 0 then
      timetozero = math.abs(eclipse) / eclipsepersecond
    end

    if timetozero > casttime then return true end
    return false
end)
]]--

PossiblyEngine.condition.register("balance.eclipse", function(target)
    local eclipse = UnitPower("player", 8)
    return eclipse
end)

PossiblyEngine.condition.register("moving", function(target)
    local speed, _ = GetUnitSpeed(target)
    return speed ~= 0
end)

local movingCache = { }
PossiblyEngine.condition.register("lastmoved", function(target)
    if target == 'player' then
        if not PossiblyEngine.module.player.moving then
            return GetTime() - PossiblyEngine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving and moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = true
                    return false
                elseif moving then
                    return false
                elseif not moving then
                    movingCache[guid].moving = false
                    return GetTime() - movingCache[guid].last
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

PossiblyEngine.condition.register("movingfor", function(target)
    if target == 'player' then
        if PossiblyEngine.module.player.moving then
            return GetTime() - PossiblyEngine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                    return false
                elseif moving then
                    return GetTime() - movingCache[guid].last
                elseif not moving then
                    movingCache[guid].moving = false
                    return false
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

-- DK Power

PossiblyEngine.condition.register("runicpower", function(target, spell)
    return UnitPower(target, SPELL_POWER_RUNIC_POWER)
end)

PossiblyEngine.condition.register("runes.count", function(target, rune)
    rune = string.lower(rune)
    if rune == 'frost' then
    local r1 = select(3, GetRuneCooldown(5))
    local r2 = select(3, GetRuneCooldown(6))
    local f1 = GetRuneType(5)
    local f2 = GetRuneType(6)
    if (r1 and f1 == 3) and (r2 and f2 == 3) then
        return 2
    elseif (r1 and f1 == 3) or (r2 and f2 == 3) then
        return 1
    else
        return 0
    end
    elseif rune == 'blood' then
    local r1 = select(3, GetRuneCooldown(1))
    local r2 = select(3, GetRuneCooldown(2))
    local b1 = GetRuneType(1)
    local b2 = GetRuneType(2)
    if (r1 and b1 == 1) and (r2 and b2 == 1) then
        return 2
    elseif (r1 and b1 == 1) or (r2 and b2 == 1) then
        return 1
    else
        return 0
    end
    elseif rune == 'unholy' then
    local r1 = select(3, GetRuneCooldown(3))
    local r2 = select(3, GetRuneCooldown(4))
    local u1 = GetRuneType(3)
    local u2 = GetRuneType(4)
    if (r1 and u1 == 2) and (r2 and u2 == 2) then
        return 2
    elseif (r1 and u1 == 2) or (r2 and u2 == 2) then
        return 1
    else
        return 0
    end
    elseif rune == 'death' then
        local r1 = select(3, GetRuneCooldown(1))
        local r2 = select(3, GetRuneCooldown(2))
        local r3 = select(3, GetRuneCooldown(3))
        local r4 = select(3, GetRuneCooldown(4))
        local d1 = GetRuneType(1)
        local d2 = GetRuneType(2)
        local d3 = GetRuneType(3)
        local d4 = GetRuneType(4)
        local total = 0
        if (r1 and d1 == 4) then
            total = total + 1
        end
        if (r2 and d2 == 4) then
            total = total + 1
        end
        if (r3 and d3 == 4) then
            total = total + 1
        end
        if (r4 and d4 == 4) then
            total = total + 1
        end
        return total
    end
    return 0
end)

PossiblyEngine.condition.register("runes.depleted", function(target, spell)
    local regeneration_threshold = 1
    for i=1,6,2 do
        local start, duration, runeReady = GetRuneCooldown(i)
        local start2, duration2, runeReady2 = GetRuneCooldown(i+1)
        if not runeReady and not runeReady2 and duration > 0 and duration2 > 0 and start > 0 and start2 > 0 then
            if (start-GetTime()+duration)>=regeneration_threshold and (start2-GetTime()+duration2)>=regeneration_threshold then
                return true
            end
        end
    end
    return false
end)

PossiblyEngine.condition.register("runes", function(target, rune)
    return PossiblyEngine.condition["runes.count"](target, rune)
end)

PossiblyEngine.condition.register("health", function(target)
    if UnitExists(target) then
        return math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
    end
    return 0
end)

PossiblyEngine.condition.register("health.actual", function(target)
    return UnitHealth(target)
end)

PossiblyEngine.condition.register("health.max", function(target)
    return UnitHealthMax(target)
end)

PossiblyEngine.condition.register("mana", function(target, spell)
    if UnitExists(target) then
        return math.floor((UnitMana(target) / UnitManaMax(target)) * 100)
    end
    return 0
end)

PossiblyEngine.condition.register("raid.health", function()
    return PossiblyEngine.raid.raidPercent()
end)

PossiblyEngine.condition.register("modifier.multitarget", function()
    return PossiblyEngine.condition["modifier.toggle"]('multitarget')
end)

PossiblyEngine.condition.register("modifier.cooldowns", function()
    return PossiblyEngine.condition["modifier.toggle"]('cooldowns')
end)

PossiblyEngine.condition.register("modifier.cooldown", function()
    return PossiblyEngine.condition["modifier.toggle"]('cooldowns')
end)

PossiblyEngine.condition.register("modifier.interrupts", function()
    if PossiblyEngine.condition["modifier.toggle"]('interrupt') then
    local stop = PossiblyEngine.condition["casting"]('target')
    if stop then SpellStopCasting() end
    return stop
    end
    return false
end)

PossiblyEngine.condition.register("modifier.interrupt", function()
    if PossiblyEngine.condition["modifier.toggle"]('interrupt') then
    return PossiblyEngine.condition["casting"]('target')
    end
    return false
end)

PossiblyEngine.condition.register("modifier.last", function(target, spell)
    return PossiblyEngine.parser.lastCast == GetSpellName(spell)
end)

PossiblyEngine.condition.register("enchant.mainhand", function()
    return (select(1, GetWeaponEnchantInfo()) == 1)
end)

PossiblyEngine.condition.register("enchant.offhand", function()
    return (select(4, GetWeaponEnchantInfo()) == 1)
end)

PossiblyEngine.condition.register("totem", function(target, totem)
    for index = 1, 4 do
        local _, totemName, startTime, duration = GetTotemInfo(index)
        if totemName == GetSpellName(totem) then
            return true
        end
    end
    return false
end)

PossiblyEngine.condition.register("totem.duration", function(target, totem)
    for index = 1, 4 do
      local _, totemName, startTime, duration = GetTotemInfo(index)
      if totemName == GetSpellName(totem) then
          return floor(startTime + duration - GetTime())
      end
    end
    return 0
end)

PossiblyEngine.condition.register("mushrooms", function ()
    local count = 0
    for slot = 1, 3 do
    if GetTotemInfo(slot) then
        count = count + 1 end
    end
    return count
end)

local function checkChanneling(target)
    local name_, _, _, _, startTime, endTime, _, notInterruptible = UnitChannelInfo(target)
    if name then return name, startTime, endTime, notInterruptible end

    return false
end

local function checkCasting(target)
    local name, startTime, endTime, notInterruptible = checkChanneling(target)
    if name then return name, startTime, endTime, notInterruptible end

    local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(target)
    if name then return name, startTime, endTime, notInterruptible end

    return false
end

PossiblyEngine.condition.register("busy", function(target, spell)
  local name, startTime, endTime, notInterruptible = checkCasting(target)
  if name or GetNumLootItems() > 0 then
    return true
  end
  return false
end)

PossiblyEngine.condition.register('casting.time', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if name then return (endTime - startTime) / 1000 end
    return false
end)

PossiblyEngine.condition.register('casting.delta', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return secondsLeft, castLength
    end
    return false
end)

PossiblyEngine.condition.register('casting.percent', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return ((secondsLeft/castLength)*100)
    end
    return false
end)

PossiblyEngine.condition.register('channeling', function (target, spell)
    return checkChanneling(target)
end)

PossiblyEngine.condition.register("casting", function(target, spell)
    local castName,_,_,_,_,endTime,_,_,notInterruptibleCast = UnitCastingInfo(target)
    local channelName,_,_,_,_,endTime,_,notInterruptibleChannel = UnitChannelInfo(target)
    spell = GetSpellName(spell)
    if (castName == spell or channelName == spell) and not not spell then
    return true
    elseif notInterruptibleCast == false or notInterruptibleChannel == false then
    return true
    end
    return false
end)

PossiblyEngine.condition.register('interruptsAt', function (target, spell)
    if PossiblyEngine.condition['modifier.toggle']('interrupt') then
    if UnitName('player') == UnitName(target) then return false end
    local stopAt = tonumber(spell) or 95
    local secondsLeft, castLength = PossiblyEngine.condition['casting.delta'](target)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
        SpellStopCasting()
        return true
    end
    end
    return false
end)

PossiblyEngine.condition.register('interruptAt', function (target, spell)
    if PossiblyEngine.condition['modifier.toggle']('interrupt') then
    if UnitName('player') == UnitName(target) then return false end
    local stopAt = tonumber(spell) or 95
    local secondsLeft, castLength = PossiblyEngine.condition['casting.delta'](target)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
        return true
    end
    end
    return false
end)

PossiblyEngine.condition.register("spell.cooldown", function(target, spell)
    local start, duration, enabled = GetSpellCooldown(spell)
    if not start then return false end
    if start ~= 0 then
      return (start + duration - GetTime())
    end
    return 0
end)

PossiblyEngine.condition.register("spell.recharge", function(target, spell)
    local charges, maxCharges, start, duration = GetSpellCharges(spell)
    if not start then return false end
    if start ~= 0 then
      return (start + duration - GetTime())
    end
    return 0
end)

PossiblyEngine.condition.register("spell.usable", function(target, spell)
    return (IsUsableSpell(spell) ~= nil)
end)

PossiblyEngine.condition.register("spell.exists", function(target, spell)
    if GetSpellBookIndex(spell) then
    return true
    end
    return false
end)

PossiblyEngine.condition.register("spell.casted", function(target, spell)
    return PossiblyEngine.module.player.casted(GetSpellName(spell))
end)

PossiblyEngine.condition.register("spell.charges", function(target, spell)
    return select(1, GetSpellCharges(spell))
end)

PossiblyEngine.condition.register("spell.cd", function(target, spell)
    return PossiblyEngine.condition["spell.cooldown"](target, spell)
end)

PossiblyEngine.condition.register("spell.range", function(target, spell)
    local spellIndex, spellBook = GetSpellBookIndex(spell)
    if not spellIndex then return false end
    return spellIndex and IsSpellInRange(spellIndex, spellBook, target)
end)

PossiblyEngine.condition.register("spell.castingtime", function(target, spell)
    local name, _, _, _, _, _, castingTime, _, _ = GetSpellInfo(spell)
    if name and castingTime then
      return castingTime / 1000
    end
    return 9999
end)

PossiblyEngine.condition.register("talent", function(args)
    local row, col = strsplit(",", args, 2)
    return hasTalent(tonumber(row), tonumber(col))
end)

PossiblyEngine.condition.register("friend", function(target, spell)
    return ( not UnitCanAttack("player", target) )
end)

PossiblyEngine.condition.register("enemy", function(target, spell)
    return ( UnitCanAttack("player", target) )
end)

PossiblyEngine.condition.register("glyph", function(target, spell)
    local spellId = tonumber(spell)
    local glyphName, glyphId

    for i = 1, 6 do
    glyphId = select(4, GetGlyphSocketInfo(i))
    if glyphId then
        if spellId then
        if select(4, GetGlyphSocketInfo(i)) == spellId then
            return true
        end
        else
        glyphName = GetSpellName(glyphId)
        if glyphName:find(spell) then
            return true
        end
        end
    end
    end
    return false
end)

PossiblyEngine.condition.register("range", function(target)
    return PossiblyEngine.condition["distance"](target)
end)

PossiblyEngine.condition.register("distance", function(target)
    if Distance then
        return math.floor(Distance(target, 'player'))
    else -- fall back to libRangeCheck
        local minRange, maxRange = rangeCheck:GetRange(target)
        return maxRange or minRange
    end
end)

PossiblyEngine.condition.register("level", function(target, range)
    return UnitLevel(target)
end)

PossiblyEngine.condition.register("combat", function(target, range)
    return UnitAffectingCombat(target)
end)

PossiblyEngine.condition.register("time", function(target, range)
    if PossiblyEngine.module.player.combatTime then
        return GetTime() - PossiblyEngine.module.player.combatTime
    end
    return false
end)

PossiblyEngine.condition.register("ooctime", function(target, range)
    if PossiblyEngine.module.player.oocombatTime then
        return GetTime() - PossiblyEngine.module.player.oocombatTime
    end
    return false
end)

local deathTrack = { }
PossiblyEngine.condition.register("deathin", function(target, range)
    local guid = UnitGUID(target)
    if deathTrack[target] and deathTrack[target].guid == guid then
        local start = deathTrack[target].time
        local currentHP = UnitHealth(target)
        local maxHP = deathTrack[target].start
        local diff = maxHP - currentHP
        local dura = GetTime() - start
        local hpps = diff / dura
        local death = currentHP / hpps
        if death == math.huge then
            return 8675309
        elseif death < 0 then
            return 0
        else
            return death
        end
    elseif deathTrack[target] then
        table.empty(deathTrack[target])
    else
        deathTrack[target] = { }
    end
    deathTrack[target].guid = guid
    deathTrack[target].time = GetTime()
    deathTrack[target].start = UnitHealth(target)
    return 8675309
end)

PossiblyEngine.condition.register("ttd", function(target, range)
    return PossiblyEngine.condition["deathin"](target)
end)

PossiblyEngine.condition.register("role", function(target, role)
    role = role:upper()

    local damageAliases = { "DAMAGE", "DPS", "DEEPS" }

    local targetRole = UnitGroupRolesAssigned(target)
    if targetRole == role then return true
    elseif role:find("HEAL") and targetRole == "HEALER" then return true
    else
    for i = 1, #damageAliases do
        if role == damageAliases[i] then return true end
    end
    end

    return false
end)

PossiblyEngine.condition.register("name", function (target, expectedName)
    return UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

PossiblyEngine.condition.register("modifier.party", function()
    return IsInGroup()
end)

PossiblyEngine.condition.register("modifier.raid", function()
    return IsInRaid()
end)

PossiblyEngine.condition.register("party", function(target)
    return UnitInParty(target)
end)

PossiblyEngine.condition.register("raid", function(target)
    return UnitInRaid(target)
end)

PossiblyEngine.condition.register("modifier.members", function()
    return (GetNumGroupMembers() or 0)
end)

PossiblyEngine.condition.register("creatureType", function (target, expectedType)
    return UnitCreatureType(target) == expectedType
end)

PossiblyEngine.condition.register("class", function (target, expectedClass)
    local class, _, classID = UnitClass(target)

    if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
    else
    return expectedClass == class
    end
end)

PossiblyEngine.condition.register("falling", function()
    return IsFalling()
end)

PossiblyEngine.condition.register("timeout", function(args)
    local name, time = strsplit(",", args, 2)
    if tonumber(time) then
        if PossiblyEngine.timeout.check(name) then
            return false
        end
        PossiblyEngine.timeout.set(name, tonumber(time))
        return true
    end
    return false
end)

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }

PossiblyEngine.condition.register("hashero", function(unit, spell)
    for i = 1, #heroismBuffs do
      if UnitBuff('player', GetSpellName(heroismBuffs[i])) then
          return true
      end
    end
    return false
end)

PossiblyEngine.condition.register("hashero.remains", function(unit, spell)
    for i = 1, #heroismBuffs do
      local buff,_,expires,caster = UnitBuff('player', GetSpellName(heroismBuffs[i]))
      if buff and expires then
        return (expires - GetTime())
      end
    end
    return 0
end)

PossiblyEngine.condition.register("buffs.stats", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(1) ~= nil)
end)

PossiblyEngine.condition.register("buffs.stamina", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(2) ~= nil)
end)

PossiblyEngine.condition.register("buffs.attackpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(3) ~= nil)
end)

PossiblyEngine.condition.register("buffs.attackspeed", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

PossiblyEngine.condition.register("buffs.haste", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

PossiblyEngine.condition.register("buffs.spellpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(5) ~= nil)
end)

PossiblyEngine.condition.register("buffs.crit", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

PossiblyEngine.condition.register("buffs.critical", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

PossiblyEngine.condition.register("buffs.criticalstrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

PossiblyEngine.condition.register("buffs.mastery", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(7) ~= nil)
end)

PossiblyEngine.condition.register("buffs.multistrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)

PossiblyEngine.condition.register("buffs.multi", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)

PossiblyEngine.condition.register("buffs.vers", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)

PossiblyEngine.condition.register("buffs.versatility", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)

PossiblyEngine.condition.register("charmed", function(unit, _)
    return (UnitIsCharmed(unit) == true)
end)

PossiblyEngine.condition.register("vengeance", function(unit, spell)
    local vengeance = select(15, _G['UnitBuff']("player", GetSpellName(132365)))
    if not vengeance then
        return 0
    end
    if spell then
        return vengeance
    end
    return vengeance / UnitHealthMax("player") * 100
end)

PossiblyEngine.condition.register("area.enemies", function(unit, distance)
    if UnitsAroundUnit then
        local total = UnitsAroundUnit(unit, tonumber(distance))
        return total
    end
    return 0
end)

PossiblyEngine.condition.register("ilevel", function(unit, _)
    return math.floor(select(1,GetAverageItemLevel()))
end)

PossiblyEngine.condition.register("firehack", function(unit, _)
    return FireHack or false
end)

PossiblyEngine.condition.register("offspring", function(unit, _)
    return type(opos) == 'function' or false
end)

PossiblyEngine.condition.register("ininstance", function(unit, type)
    local inInstance, instanceType = IsInInstance()
    if inInstance and not type then
      return true
    end
    if inInstance and type and instanceType == type then
      return true
    end
    return false
end)

PossiblyEngine.condition.register("spell.wontcap", function(unit, spell)
  local inactiveRegen, activeRegen = GetPowerRegen()
  local name, _, _, castTime = GetSpellInfo(spell)
  if name and inactiveRegen then
    if UnitAffectingCombat(unit) then local regen = activeRegen else local regen = inactiveRegen end
    if castTime == 0 then castTime = 1500 end
    local cast_regen = castTime/1000 * regen
    local power_type, _ = UnitPowerType(unit)
    local power_deficit = UnitPowerMax(unit, power_type) - UnitPower(unit, power_type)
    return cast_regen < power_deficit
  end
  return false
end)
