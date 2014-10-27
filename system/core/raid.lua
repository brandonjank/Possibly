-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.raid = {
  roster = {}
}

local max = math.max
local GetSpellInfo = GetSpellInfo
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitCanAssist = UnitCanAssist
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInParty = UnitInParty
local UnitInRange = UnitInRange
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsFriend = UnitIsFriend
local UnitUsingVehicle = UnitUsingVehicle

local function canHeal(unit)
  if UnitExists(unit)
     and UnitCanAssist('player', unit)
     and UnitIsFriend('player', unit)
     and UnitIsConnected(unit)
     and not UnitIsDeadOrGhost(unit)
     and not UnitUsingVehicle(unit) then

     if UnitInParty(unit) and not UnitInRange(unit) then
       return false
     end

     return true
  end

  return false
end

local function getGroupMembers()
  local start, groupMembers = 0, GetNumGroupMembers()

  if IsInRaid() then
    start = 1
  elseif groupMembers > 0 then
    groupMembers = groupMembers - 1
  end

  return start, groupMembers
end

local ancientBarrierDebuffs = { GetSpellInfo(142861), GetSpellInfo(142863), GetSpellInfo(142864), GetSpellInfo(142865) }
local function ancientBarrier(unit)
  if not UnitDebuff(unit, ancientBarrierDebuffs[1]) then
    return false
  end

	local amount
	for i = 2, 4 do
		amount = select(15, UnitDebuff(unit, ancientBarrierDebuffs[i]))
		if amount then
      return amount
		end
	end

	return false
end

local function updateHealth(index)
  if not PossiblyEngine.raid.roster[index] then
    return
  end

  local unit = PossiblyEngine.raid.roster[index].unit

  local incomingHeals = UnitGetIncomingHeals(unit) or 0
  local absorbs = UnitGetTotalHealAbsorbs(unit) or 0

  local health = UnitHealth(unit) + incomingHeals - absorbs
  local maxHealth = UnitHealthMax(unit)

  local ancientBarrierShield = ancientBarrier(unit)
  if ancientBarrierShield then
    health = ancientBarrierShield
  end

  PossiblyEngine.raid.roster[index].health = health / maxHealth * 100
  PossiblyEngine.raid.roster[index].healthMissing = max(0, maxHealth - health)
  PossiblyEngine.raid.roster[index].maxHealth = maxHealth
end

local unitLookup = {}
PossiblyEngine.raid.updateHealth = function (unit)
  if type(unit) == 'number' then
    return updateHealth(unit)
  end

  return updateHealth(unitLookup[unit])
end

PossiblyEngine.raid.build = function ()
  local _, groupMembers = getGroupMembers()
  local rosterLength = #PossiblyEngine.raid.roster
  local prefix = (IsInRaid() and 'raid') or 'party'

  local i, unit
  for i = -2, groupMembers do
    unit = (i == -2 and 'focus') or (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i

    if not PossiblyEngine.raid.roster[i] then PossiblyEngine.raid.roster[i] = {} end
    if not unitLookup[unit] then unitLookup[unit] = i end

    PossiblyEngine.raid.roster[i].unit = unit
    if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitIsConnected(unit) then
      PossiblyEngine.raid.roster[i].class = select(3, UnitClass(unit))
      PossiblyEngine.raid.roster[i].role = UnitGroupRolesAssigned(unit)
      updateHealth(i)
    end
  end

  if groupMembers > rosterLength then
    return
  end

  for i = groupMembers + 1, rosterLength do
    PossiblyEngine.raid.roster[i] = nil
  end
end

PossiblyEngine.raid.lowestHP = function ()
  local lowestUnit = 'player'
  local lowest = 100

  for _, unit in pairs(PossiblyEngine.raid.roster) do
    if canHeal(unit.unit) and unit.health and unit.health < lowest then
      lowest = unit.health
      lowestUnit = unit.unit
    end
  end

  return lowestUnit
end

PossiblyEngine.raid.raidPercent = function ()
  local start, groupMembers = getGroupMembers()
  local rosterLength = #PossiblyEngine.raid.roster

  if groupMembers == 0 then
    return PossiblyEngine.raid.roster[0].health
  end

  local total = 0
  local groupCount = 0

  local unit
  for i = start, groupMembers do
    unit = PossiblyEngine.raid.roster[i]
    if unit and unit.health then
      total = total + PossiblyEngine.raid.roster[i].health
      groupCount = groupCount + 1
    end
  end

  return total / groupCount
end

PossiblyEngine.raid.needsHealing = function (threshold)
  if not threshold then threshold = 80 end

  local start, groupMembers = getGroupMembers()
  local needsHealing = 0
  local unit
  for i = start, groupMembers do
    unit = PossiblyEngine.raid.roster[i]
    if canHeal(unit.unit) and unit.health and unit.health <= threshold then
      needsHealing = needsHealing + 1
    end
  end

  return needsHealing
end

PossiblyEngine.raid.tank = function ()
  local tank = 'player'
  local highestUnit

  local lowest, highest = 100, 0
  for _, unit in pairs(PossiblyEngine.raid.roster) do
    if canHeal(unit.unit) then
      if unit.role == 'TANK' then
        if unit.health and unit.health < lowest then
          lowest = unit.health
          tank = unit.unit
        end
      else
        if unit.maxHealth and unit.maxHealth > highest then
          highest = unit.maxHealth
          highestUnit = unit.unit
        end
      end
    end
  end

  if GetNumGroupMembers() > 0 and tank == 'player' then
    tank = highestUnit
  end

  return tank
end

PossiblyEngine.raid.check = function (fn)
  local count = 0

  local start, groupMembers = getGroupMembers()
  local unit
  for i = start, groupMembers do
    if fn(PossiblyEngine.raid.roster[i]) then
      PossiblyEngine.dsl.parsedTarget = PossiblyEngine.raid.roster[i].unit
      count = count + 1
    end
  end

  return count
end
