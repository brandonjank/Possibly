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

PossiblyEngine.condition.register("debuff.duration", function(target, spell)
    local debuff,_,expires,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return (expires - (GetTime()-(PossiblyEngine.lag/1000)))
    end
    return 0
end)

PossiblyEngine.condition.register("buff.duration", function(target, spell)
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return (expires - (GetTime()-(PossiblyEngine.lag/1000)))
    end
    return 0
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

PossiblyEngine.condition.register("player", function(target, spell)
    return UnitName('player') == UnitName(target)
end)

PossiblyEngine.condition.register("isPlayer", function (target)
    return UnitIsPlayer(target)
end)

PossiblyEngine.condition.register("exists", function(target)
    return (UnitExists(target))
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

PossiblyEngine.condition.register("toggle", function(toggle, spell)
    return PossiblyEngine.condition["modifier.toggle"](toggle)
end)

PossiblyEngine.condition.register("modifier.toggle", function(toggle)
    return PossiblyEngine.config.read('button_states', toggle, false)
end)

PossiblyEngine.condition.register("modifier.taunt", function()
    if PossiblyEngine.condition["modifier.toggle"]('taunt') then
    if UnitThreatSituation("player", "target") then
        local status = UnitThreatSituation("player", target)
        return (status < 3)
    end
    return false
    end
    return false
end)

PossiblyEngine.condition.register("threat", function(target, spell)
    if UnitThreatSituation("player", target) then
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", target)
    return scaledPercent
    end
    return 0
end)

PossiblyEngine.condition.register("agro", function(target, spell)
    if UnitThreatSituation(target) and UnitThreatSituation(target) >= 2 then
    return true
    end
    return false
end)


PossiblyEngine.condition.register("balance.sun", function(target, spell)
    local direction = GetEclipseDirection()
    if direction == 'none' or direction == 'sun' then return true end
end)

PossiblyEngine.condition.register("balance.moon", function(target, spell)
    local direction = GetEclipseDirection()
    if direction == 'moon' then return true end
end)

PossiblyEngine.condition.register("moving", function(target, spell)
    return GetUnitSpeed(target) ~= 0
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

PossiblyEngine.condition.register("health", function(target, spell)
    if UnitExists(target) then
        return math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
    end
    return 0
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

function Distance(a, b)
    local ax, ay, az = ObjectPosition(a)
    local bx, by, bz = ObjectPosition(b)
    local ab = (UnitCombatReach(a))
    local bb = (UnitCombatReach(b))
    local b = ab + bb
    return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - b
end

function UnitsAroundUnit(unit, distance)
    if FireHack then
        local total = 0
        local totalObjects = ObjectCount()
        local onUnit = UnitExists(unit)
        for i = 1, totalObjects do
            local object = ObjectWithIndex(i)
            if ObjectType(object) == 9 and not UnitIsPlayer(object) and not UnitIsUnit(object, unit) then
                local reaction = UnitReaction("player", object)
                local combat = UnitAffectingCombat(object)
                if reaction and reaction <= 4 and combat then
                    if onUnit then
                        local objDistance = math.abs(Distance(object, unit))
                        if objDistance <= distance then
                            total = total + 1
                        end
                    else
                        total = total + 1
                    end
                end
            end
        end
        return total + 1
    else
        return 0
    end
end

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
    count = 0
    for slot = 1, 3 do
    if GetTotemInfo(slot) then count = count + 1 end
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

PossiblyEngine.condition.register('casting.time', function(target, spell)
    local name, startTime, endTime = checkCasting(target)
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

PossiblyEngine.condition.register("friend", function(target, spell)
    return ( UnitCanAttack("player", target) ~= 1 )
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

PossiblyEngine.condition.register("range", function(target, range)
    local minRange, maxRange = rangeCheck:GetRange(target)
    return maxRange
end)

PossiblyEngine.condition.register("level", function(target, range)
    return UnitLevel(target)
end)

PossiblyEngine.condition.register("combat", function(target, range)
    return UnitAffectingCombat(target)
end)

PossiblyEngine.condition.register("time", function(target, range)
    return GetTime() - PossiblyEngine.module.player.combatTime
end)

PossiblyEngine.condition.register("deathin", function(target, range)
    local guid = UnitGUID(target)
    local name = GetUnitName(target)
    if name == "Training Dummy" or name == "Raider's Training Dummy" then
    return 99
    end
    if PossiblyEngine.module.combatTracker.enemy[guid] then
    return PossiblyEngine.module.combatTracker.enemy[guid]['ttd'] or 0
    end
    return 0
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

PossiblyEngine.condition.register("modifier.timeout", function(_, spell, time)
    if PossiblyEngine.timeout.check(spell) then
    return PossiblyEngine.timeout.check(spell)
    else
    PossiblyEngine.timeout.set(spell, function()
        print(spell .. 'finished')
    end, tonumber(time))
    end
    return true
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

PossiblyEngine.condition.register("buffs.spellpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(5) ~= nil)
end)

PossiblyEngine.condition.register("buffs.spellhaste", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

PossiblyEngine.condition.register("buffs.crit", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(7) ~= nil)
end)

PossiblyEngine.condition.register("buffs.mastery", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
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