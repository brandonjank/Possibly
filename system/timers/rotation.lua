-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetSpellInfo = GetSpellInfo

PossiblyEngine.current_spell = false

PossiblyEngine.cycleTime = PossiblyEngine.cycleTime or 50


-- faceroll

PossiblyEngine.faceroll.faceroll = function()
  if PossiblyEngine.faceroll.rolling then
    local spell, target
    if PossiblyEngine.module.player.combat and PossiblyEngine.rotation.activeRotation then
      spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeRotation)
    elseif not PossiblyEngine.module.player.combat and PossiblyEngine.rotation.activeOOCRotation then
      spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeOOCRotation, 'player')
    end

    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end
      if UnitExists(target) or target == 'ground' or string.sub(target, -7) == ".ground" then
        PossiblyEngine.buttons.icon('MasterToggle', icon)
        PossiblyEngine.current_spell = name
      else
        PossiblyEngine.current_spell = false
      end
    else
      PossiblyEngine.current_spell = false
    end
  end
end

PossiblyEngine.timer.register("faceroll", function()
  PossiblyEngine.faceroll.faceroll()
end, 50)

PossiblyEngine.cycle = function(skip_verify)

  local turbo = PossiblyEngine.config.read('pe_turbo', false)
  local cycle =
    ( IsMounted() == false or UnitBuff("player", GetSpellInfo(164222)) )
    and UnitInVehicle("player") == false
    and PossiblyEngine.module.player.combat
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID
    and (PossiblyEngine.protected.unlocked or IsMacClient())

  if cycle or skip_verify and PossiblyEngine.rotation.activeRotation then

    local spell, target = false

    local queue = PossiblyEngine.module.queue.spellQueue
    if queue ~= nil and PossiblyEngine.parser.can_cast(queue) then
      spell = queue
      target = 'target'
      PossiblyEngine.module.queue.spellQueue = nil
    elseif PossiblyEngine.parser.lastCast == queue then
      PossiblyEngine.module.queue.spellQueue = nil
    else
      spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeRotation)
    end

    if not spell then
      spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeRotation)
    end

    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end

      PossiblyEngine.buttons.icon('MasterToggle', icon)
      PossiblyEngine.current_spell = name

      if target == "ground" then
        CastGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        CastGround(name, target)
      else
        if spellID == 110309 then
          Macro("/target " .. target)
          target = "target"
        end

        -- some spells just won't cast normally, so we use macros
        if spellID == 139139 then -- Insanity for spriests
          Macro('/cast ' .. GetSpellName(15407))
        else
          Cast(name, target or "target")
        end

        if spellID == 110309 then
          Macro("/targetlasttarget")
        end
        if icon then
          PossiblyEngine.actionLog.insert('Spell Cast', name, icon, target or "target")
        end
      end

      if target ~= "ground" and UnitExists(target or 'target') then
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName(target or 'target') .. " )", 'spell_cast')
      else
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on the ground!", 'spell_cast')
      end

    end

  end
end

PossiblyEngine.timer.register("rotation", function()
  PossiblyEngine.cycle()
end, PossiblyEngine.cycleTime)

PossiblyEngine.ooc_cycle = function()
  local cycle =
    ( IsMounted() == false or UnitBuff("player", GetSpellInfo(164222)) )
    and UnitInVehicle("player") == false
    and not PossiblyEngine.module.player.combat
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID ~= 0
    and PossiblyEngine.rotation.activeOOCRotation ~= false
    and (PossiblyEngine.protected.unlocked or IsMacClient())

  if cycle and PossiblyEngine.rotation.activeOOCRotation then
    local spell, target = ''
    spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeOOCRotation, 'player')

    if target == nil then target = 'player' end
    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon = GetSpellInfo(spellID)
      end

      PossiblyEngine.buttons.icon('MasterToggle', icon)
      PossiblyEngine.current_spell = name

      if target == "ground" then
        CastGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        CastGround(name, target)
      else
        if spellID == 110309 then
          Macro("/target " .. target)
          target = "target"
        end
        Cast(name, target)
        if spellID == 110309 then
          Macro("/targetlasttarget")
        end
        if icon then
          PossiblyEngine.actionLog.insert('Spell Cast', name, icon, target)
        end
      end

      if target ~= "ground" and UnitExists(target or 'target') then
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName(target or 'target') .. " )", 'spell_cast')
      else
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on the ground!", 'spell_cast')
      end

      --soon... soon
      --Purrmetheus.api:UpdateIntent("default", PossiblyEngine.ooc_cycle, name, nil, target or "target")

    end
  end
end

PossiblyEngine.timer.register("oocrotation", function()
  PossiblyEngine.ooc_cycle()
end, PossiblyEngine.cycleTime)


PossiblyEngine.timer.register("detectUnlock", function()
  if PossiblyEngine.config.read('button_states', 'MasterToggle', false) then
    PossiblyEngine.protected.FireHack()
    PossiblyEngine.protected.OffSpring()
    PossiblyEngine.protected.Generic()
  end
end, 1000)
