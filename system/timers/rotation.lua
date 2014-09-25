-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetSpellInfo = GetSpellInfo

PossiblyEngine.cycleTime = PossiblyEngine.cycleTime or 50

PossiblyEngine.cycle = function(skip_verify)

  local turbo = PossiblyEngine.config.read('pe_turbo', false)
  local cycle =
    IsMounted() ~= 1
    and UnitInVehicle("player") ~= 1
    and PossiblyEngine.module.player.combat
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID

  if cycle or skip_verify then
    local stickyValue = GetCVar("deselectOnClick")
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

      if target == "ground" then
        CastSpellByName(name)
        CastAtLocation(Target:GetLocation())
      elseif string.sub(target, -7) == ".ground" then
        target = string.sub(target, 0, -8)
        CastSpellByName(name)
        CastAtLocation(GetObjectFromUnitID(target):GetLocation())
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
	  
	 -- if target ~= "ground" then
        --PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName((target or 'target')) .. " )", 'spell_cast')
	 -- else
        --PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on the ground!", 'spell_cast')
     -- end

    end
    SetCVar("deselectOnClick", stickyValue)
  end
end

PossiblyEngine.timer.register("rotation", function()
    PossiblyEngine.cycle()
end, PossiblyEngine.cycleTime)

PossiblyEngine.timer.register("oocrotation", function()
  local cycle =
    IsMounted() ~= 1
    and UnitInVehicle("player") ~= 1
    and PossiblyEngine.module.player.combat ~= true
    and PossiblyEngine.config.read('button_states', 'MasterToggle', false)
    and PossiblyEngine.module.player.specID ~= 0
    and PossiblyEngine.rotation.activeOOCRotation ~= false

  if cycle then
    local stickyValue = GetCVar("deselectOnClick")
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

      if target ~= "ground" then
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on ( " .. UnitName((target or 'target')) .. " )", 'spell_cast')
      else
        PossiblyEngine.debug.print("Casting |T"..icon..":10:10|t ".. name .. " on the ground!", 'spell_cast')
      end

      PossiblyEngine.buttons.icon('MasterToggle', icon)

      if target == "ground" then
        SetCVar("deselectOnClick", "0")
        CameraOrSelectOrMoveStart(1) -- this is unlocked
        CastSpellByName(name)
        CameraOrSelectOrMoveStop(1) -- this isn't unlocked
        SetCVar("deselectOnClick", "1")
        if icon then
          PossiblyEngine.actionLog.insert('Ground Cast', name, icon, "ground")
        end
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
    end
    SetCVar("deselectOnClick", stickyValue)
  end
end, PossiblyEngine.cycleTime)
