-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetClassInfoByID = GetClassInfoByID

PossiblyEngine.rotation = {
  rotations = { },
  oocrotations =  { },
  custom = { },
  ooccustom = { },
  cdesc = { },
  buttons = { },
  specId = { },
  classSpecId = { },
  currentStringComp = "",
  activeRotation = false,
  activeOOCRotation = false,
}

PossiblyEngine.rotation.specId[62] = pelg('arcane_mage')
PossiblyEngine.rotation.specId[63] = pelg('fire_mage')
PossiblyEngine.rotation.specId[64] = pelg('frost_mage')
PossiblyEngine.rotation.specId[65] = pelg('holy_paladin')
PossiblyEngine.rotation.specId[66] = pelg('protection_paladin')
PossiblyEngine.rotation.specId[70] = pelg('retribution_paladin')
PossiblyEngine.rotation.specId[71] = pelg('arms_warrior')
PossiblyEngine.rotation.specId[72] = pelg('furry_warrior')
PossiblyEngine.rotation.specId[73] = pelg('protection_warrior')
PossiblyEngine.rotation.specId[102] = pelg('balance_druid')
PossiblyEngine.rotation.specId[103] = pelg('feral_combat_druid')
PossiblyEngine.rotation.specId[104] = pelg('guardian_druid')
PossiblyEngine.rotation.specId[105] = pelg('restoration_druid')
PossiblyEngine.rotation.specId[250] = pelg('blood_death_knight')
PossiblyEngine.rotation.specId[251] = pelg('frost_death_knight')
PossiblyEngine.rotation.specId[252] = pelg('unholy_death_knight')
PossiblyEngine.rotation.specId[253] = pelg('beast_mastery_hunter')
PossiblyEngine.rotation.specId[254] = pelg('marksmanship_hunter')
PossiblyEngine.rotation.specId[255] = pelg('survival_hunter')
PossiblyEngine.rotation.specId[256] = pelg('discipline_priest')
PossiblyEngine.rotation.specId[257] = pelg('holy_priest')
PossiblyEngine.rotation.specId[258] = pelg('shadow_priest')
PossiblyEngine.rotation.specId[259] = pelg('assassination_rogue')
PossiblyEngine.rotation.specId[260] = pelg('combat_rogue')
PossiblyEngine.rotation.specId[261] = pelg('subtlety_rogue')
PossiblyEngine.rotation.specId[262] = pelg('elemental_shaman')
PossiblyEngine.rotation.specId[263] = pelg('enhancement_shaman')
PossiblyEngine.rotation.specId[264] = pelg('restoration_shaman')
PossiblyEngine.rotation.specId[265] = pelg('affliction_warlock')
PossiblyEngine.rotation.specId[266] = pelg('demonology_warlock')
PossiblyEngine.rotation.specId[267] = pelg('destruction_warlock')
PossiblyEngine.rotation.specId[268] = pelg('brewmaster_monk')
PossiblyEngine.rotation.specId[269] = pelg('windwalker_monk')
PossiblyEngine.rotation.specId[270] = pelg('mistweaver_monk')

PossiblyEngine.rotation.classSpecId[62] = 8
PossiblyEngine.rotation.classSpecId[63] = 8
PossiblyEngine.rotation.classSpecId[64] = 8
PossiblyEngine.rotation.classSpecId[65] = 2
PossiblyEngine.rotation.classSpecId[66] = 2
PossiblyEngine.rotation.classSpecId[70] = 2
PossiblyEngine.rotation.classSpecId[71] = 1
PossiblyEngine.rotation.classSpecId[72] = 1
PossiblyEngine.rotation.classSpecId[73] = 1
PossiblyEngine.rotation.classSpecId[102] = 11
PossiblyEngine.rotation.classSpecId[103] = 11
PossiblyEngine.rotation.classSpecId[104] = 11
PossiblyEngine.rotation.classSpecId[105] = 11
PossiblyEngine.rotation.classSpecId[250] = 6
PossiblyEngine.rotation.classSpecId[251] = 6
PossiblyEngine.rotation.classSpecId[252] = 6
PossiblyEngine.rotation.classSpecId[253] = 3
PossiblyEngine.rotation.classSpecId[254] = 3
PossiblyEngine.rotation.classSpecId[255] = 3
PossiblyEngine.rotation.classSpecId[256] = 5
PossiblyEngine.rotation.classSpecId[257] = 5
PossiblyEngine.rotation.classSpecId[258] = 5
PossiblyEngine.rotation.classSpecId[259] = 4
PossiblyEngine.rotation.classSpecId[260] = 4
PossiblyEngine.rotation.classSpecId[261] = 4
PossiblyEngine.rotation.classSpecId[262] = 7
PossiblyEngine.rotation.classSpecId[263] = 7
PossiblyEngine.rotation.classSpecId[264] = 7
PossiblyEngine.rotation.classSpecId[265] = 9
PossiblyEngine.rotation.classSpecId[266] = 9
PossiblyEngine.rotation.classSpecId[267] = 9
PossiblyEngine.rotation.classSpecId[268] = 10
PossiblyEngine.rotation.classSpecId[269] = 10
PossiblyEngine.rotation.classSpecId[270] = 10

PossiblyEngine.rotation.register = function(specId, spellTable, arg1, arg2)
  local name = PossiblyEngine.rotation.specId[specId] or GetClassInfoByID(specId)

  local buttons, oocrotation = nil, nil

  if type(arg1) == "table" then
    oocrotation = arg1
  end
  if type(arg1) == "function" then
    buttons = arg1
  end
  if type(arg2) == "table" then
    oocrotation = arg2
  end
  if type(arg2) == "function" then
    buttons = arg2
  end

  PossiblyEngine.rotation.rotations[specId] = spellTable

  if oocrotation then
    PossiblyEngine.rotation.oocrotations[specId] = oocrotation
  end

  if buttons and type(buttons) == 'function' then
    PossiblyEngine.rotation.buttons[specId] = buttons
  end

  PossiblyEngine.debug.print('Loaded Rotation for ' .. name, 'rotation')
end


PossiblyEngine.rotation.register_custom = function(specId, _desc, _spellTable, arg1, arg2)

  local _oocrotation, _buttons = false

  if type(arg1) == "table" then
    _oocrotation = arg1
  end
  if type(arg1) == "function" then
    _buttons = arg1
  end
  if type(arg2) == "table" then
    _oocrotation = arg2
  end
  if type(arg2) == "function" then
    _buttons = arg2
  end

  if _oocrotation then
    PossiblyEngine.rotation.ooccustom[specId] = _oocrotation
  end

  if not PossiblyEngine.rotation.custom[specId] then
    PossiblyEngine.rotation.custom[specId] = { }
  end

  table.insert(PossiblyEngine.rotation.custom[specId], {
    desc = _desc,
    spellTable = _spellTable,
    oocrotation = _oocrotation,
    buttons = _buttons,
  })

  PossiblyEngine.debug.print('Loaded Custom Rotation for ' .. PossiblyEngine.rotation.specId[specId], 'rotation')
end

-- Lower memory used, no need in storing rotations for other classes
PossiblyEngine.rotation.auto_unregister = function()
  local classId = select(3, UnitClass("player"))
  for specId,_ in pairs(PossiblyEngine.rotation.rotations) do
    if PossiblyEngine.rotation.classSpecId[specId] ~= classId and specId ~= classId then
      local name = PossiblyEngine.rotation.specId[specId] or GetClassInfoByID(specId)
      PossiblyEngine.debug.print('AutoUnloaded Rotation for ' .. name, 'rotation')
      PossiblyEngine.rotation.classSpecId[specId] = nil
      PossiblyEngine.rotation.specId[specId] = nil
      PossiblyEngine.rotation.rotations[specId] = nil
      PossiblyEngine.rotation.buttons[specId] = nil
    end
  end
  collectgarbage('collect')
end

PossiblyEngine.rotation.add_buttons = function()
  -- Default Buttons
  if PossiblyEngine.rotation.buttons[PossiblyEngine.module.player.specID] then
    PossiblyEngine.rotation.buttons[PossiblyEngine.module.player.specID]()
  end

  -- Custom Buttons
  if PossiblyEngine.rotation.custom[PossiblyEngine.module.player.specID] then
    for _, rotation in pairs(PossiblyEngine.rotation.custom[PossiblyEngine.module.player.specID]) do
      if PossiblyEngine.rotation.currentStringComp == rotation.desc then
        if rotation.buttons then
          rotation.buttons()
        end
      end
    end
  end
end
