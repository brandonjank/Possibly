-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local function resolveGround(spell, target)
  if FireHack then
    CastSpellByName(spell)
    CastAtPosition(ObjectPosition(target))
  else
    local stickyValue = GetCVar("deselectOnClick")
    SetCVar("deselectOnClick", "0")
    CameraOrSelectOrMoveStart(1) -- this is unlocked
    CastSpellByName(spell)
    CameraOrSelectOrMoveStop(1) -- this isn't unlocked
    SetCVar("deselectOnClick", "1")
    SetCVar("deselectOnClick", stickyValue)
  end
end

local GetSpellInfo = GetSpellInfo

PossiblyEngine.current_spell = false

PossiblyEngine.cycleTime = PossiblyEngine.cycleTime or 50

PossiblyEngine.cycle = function(skip_verify)

  local turbo = PossiblyEngine.config.read('pe_turbo', false)
  local cycle =
    IsMounted() == false
    and UnitInVehicle("player") == false
    and PossiblyEngine.module.player.combat
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID

  if cycle or skip_verify then
    
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
        name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellID)
      end

      PossiblyEngine.buttons.icon('MasterToggle', icon)
      PossiblyEngine.current_spell = name

      if target == "ground" then
        resolveGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        resolveGround(name, target)
      else
        if spellID == 110309 then
          RunMacroText("/target " .. target)
          target = "target"
        end
        CastSpellByName(name, target or "target")
        if spellID == 110309 then
          RunMacroText("/targetlasttarget")
        end
        if icon then
          PossiblyEngine.actionLog.insert('Spell Cast', name, icon, target or "target")
        end
      end

      if target ~= "ground" then
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName((target or 'target')) or 'Unknown' .. " )", 'spell_cast')
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
    IsMounted() == false
    and UnitInVehicle("player") == false
    and not PossiblyEngine.module.player.combat
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID ~= 0
    and PossiblyEngine.rotation.activeOOCRotation ~= false

  if cycle then
    local spell, target = ''
    spell, target = PossiblyEngine.parser.table(PossiblyEngine.rotation.activeOOCRotation, 'player')

    if target == nil then target = 'player' end
    if spell then
      local spellIndex, spellBook = GetSpellBookIndex(spell)
      local spellID, name, icon
      if spellBook ~= nil then
        _, spellID = GetSpellBookItemInfo(spellIndex, spellBook)
        name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellIndex, spellBook)
      else
        spellID = spellIndex
        name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellID)
      end

      PossiblyEngine.buttons.icon('MasterToggle', icon)
      PossiblyEngine.current_spell = name

      if target == "ground" then
        resolveGround(name, 'target')
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        resolveGround(name, target)
      else
        if spellID == 110309 then
          RunMacroText("/target " .. target)
          target = "target"
        end
        CastSpellByName(name, target)
        if spellID == 110309 then
          RunMacroText("/targetlasttarget")
        end
        if icon then
          PossiblyEngine.actionLog.insert('Spell Cast', name, icon, target)
        end
      end

      if target ~= "ground" then
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName((target or 'target')) or 'Unknown' .. " )", 'spell_cast')
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
