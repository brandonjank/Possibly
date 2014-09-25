-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.module.register("combatTracker", {
  current = 0,
  expire = 15,
  friendly = { },
  enemy = { },
  dead = { },
  named = { },
  blacklist = { },
  healthCache = { },
  healthCacheCount = { },
})

PossiblyEngine.module.combatTracker.aquireHealth = function(guid, maxHealth, name)
  if maxHealth then health = UnitHealthMax else health = UnitHealth end
  local inGroup = GetNumGroupMembers()
  if inGroup then
    if IsInRaid("player") then
      for i=1,inGroup do
        if guid == UnitGUID("RAID".. i .. "TARGET") then
          return health("RAID".. i .. "TARGET")
        end
      end
    else
      for i=1,inGroup do
        if guid == UnitGUID("PARTY".. i .. "TARGET") then
          return health("PARTY".. i .. "TARGET")
        end
      end
      if guid == UnitGUID("PLAYERTARGET") then
        return health("PLAYERTARGET")
      end
    end
  else
    print(guid, UnitGUID("PLAYERTARGET"))
    if guid == UnitGUID("PLAYERTARGET") then
      return health("PLAYERTARGET")
    end
    if guid == UnitGUID("MOUSEOVER") then
      return health("MOUSEOVER")
    end
  end
  -- All health checks failed, do we have a cache of this units health ?
  if maxHealth then
    if PossiblyEngine.module.combatTracker.healthCache[name] ~= nil then
      return PossiblyEngine.module.combatTracker.healthCache[name]
    end
  end
  return false
end

PossiblyEngine.module.combatTracker.combatCheck = function()
  local inGroup = GetNumGroupMembers()
  local inCombat = false
  if inGroup then
    if IsInRaid("player") then
      for i = 1, inGroup do
        if UnitAffectingCombat("RAID".. i) then return true end
      end
    else
      for i = 1, inGroup do
        if UnitAffectingCombat("PARTY".. i) then return true end
      end
    end
    if UnitAffectingCombat("PLAYER") then return true end
  else
    if UnitAffectingCombat("PLAYER") then return true end
  end
  return false
end

PossiblyEngine.timer.register("updateCTHealth", function()
  if PossiblyEngine.module.combatTracker.combatCheck() then
    for guid,table in pairs(PossiblyEngine.module.combatTracker.enemy) do
      local health = PossiblyEngine.module.combatTracker.aquireHealth(guid)
      if health then
        -- attempt to aquire max health again
        if PossiblyEngine.module.combatTracker.enemy[guid]['maxHealth'] == false then
          local name = PossiblyEngine.module.combatTracker.enemy[guid]['name']
          PossiblyEngine.module.combatTracker.enemy[guid]['maxHealth'] = PossiblyEngine.module.combatTracker.aquireHealth(guid, true, name)
        end

        PossiblyEngine.module.combatTracker.enemy[guid].health = health
      end
    end
  else
    PossiblyEngine.module.combatTracker.cleanCT()
  end
end, 100)

PossiblyEngine.module.combatTracker.damageUnit = function(guid, damage)
  if PossiblyEngine.module.combatTracker.enemy[guid] then
    if damage ~= nil and type(damage) == "number" then
      if PossiblyEngine.module.combatTracker.enemy[guid] and PossiblyEngine.module.combatTracker.enemy[guid]['health'] then
        local newHealth = PossiblyEngine.module.combatTracker.enemy[guid]['health'] - damage
        if newHealth >= 0 then
          PossiblyEngine.module.combatTracker.enemy[guid]['health'] = newHealth
        end
      elseif PossiblyEngine.module.combatTracker.enemy[guid] and PossiblyEngine.module.combatTracker.enemy[guid]['maxHealth'] then
        local newHealth = PossiblyEngine.module.combatTracker.enemy[guid]['maxHealth'] - damage
        if newHealth >= 0 then
          PossiblyEngine.module.combatTracker.enemy[guid]['health'] = newHealth
        end
      end
      if not PossiblyEngine.module.combatTracker.enemy[guid]['time'] then
        PossiblyEngine.module.combatTracker.enemy[guid]['time'] = time()
      end
      unit = PossiblyEngine.module.combatTracker.enemy[guid]
      if unit and unit['maxHealth'] and unit['health'] then
        local T = unit.time
        local N = time()
        local M = unit.maxHealth
        local H = unit.health
        local S = T - N
        local D = M - H
        local P = D / S
        local R = math.floor(math.abs(H / P))
        if R > 3600 then R = 1 end
        PossiblyEngine.module.combatTracker.enemy[guid]['ttd'] = R
      end
    end
  end
end

PossiblyEngine.module.combatTracker.insert = function(guid, unitname, timestamp)
  if PossiblyEngine.module.combatTracker.enemy[guid] == nil then

    local maxHealth = PossiblyEngine.module.combatTracker.aquireHealth(guid, true, unitname)
    local health = PossiblyEngine.module.combatTracker.aquireHealth(guid)

    PossiblyEngine.module.combatTracker.enemy[guid] = { }
    PossiblyEngine.module.combatTracker.enemy[guid]['maxHealth'] = maxHealth
    PossiblyEngine.module.combatTracker.enemy[guid]['health'] = health
    PossiblyEngine.module.combatTracker.enemy[guid]['name'] = unitname
    PossiblyEngine.module.combatTracker.enemy[guid]['time'] = false

    if maxHealth then
      -- we got a health value from aquire, store it for later usage
      if PossiblyEngine.module.combatTracker.healthCacheCount[unitname] then
        -- we've alreadt seen this type, average it
        local currentAverage = PossiblyEngine.module.combatTracker.healthCache[unitname]
        local currentCount = PossiblyEngine.module.combatTracker.healthCacheCount[unitname]
        local newAverage = (currentAverage + maxHealth) / 2
        PossiblyEngine.module.combatTracker.healthCache[unitname] = newAverage
        PossiblyEngine.module.combatTracker.healthCacheCount[unitname] = currentCount + 1
      else
        -- this is new to use, save it
        PossiblyEngine.module.combatTracker.healthCache[unitname] = maxHealth
        PossiblyEngine.module.combatTracker.healthCacheCount[unitname] = 1
      end
    end

  end
end

PossiblyEngine.module.combatTracker.cleanCT = function()
  -- clear tables but save the memory
  for k,_ in pairs(PossiblyEngine.module.combatTracker.enemy) do
    PossiblyEngine.module.combatTracker.enemy[k] = nil
  end
  for k,_ in pairs(PossiblyEngine.module.combatTracker.blacklist) do
    PossiblyEngine.module.combatTracker.blacklist[k] = nil
  end
end

PossiblyEngine.module.combatTracker.remove = function(guid)
  PossiblyEngine.module.combatTracker.enemy[guid] = nil
end

PossiblyEngine.module.combatTracker.tagUnit = function(guid, name)
  if not PossiblyEngine.module.combatTracker.blacklist[guid] then
    PossiblyEngine.module.combatTracker.insert(guid, name)
  end
end

PossiblyEngine.module.combatTracker.killUnit = function(guid)
  PossiblyEngine.module.combatTracker.remove(guid, name)
  PossiblyEngine.module.combatTracker.blacklist[guid] = true
end