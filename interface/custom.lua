
PossiblyEngine.rotation.list_custom = (function()
  local classId = select(3, UnitClass("player"))
  local mySpecId = PossiblyEngine.module.player.specID


  --info = { }
  --info.isTitle = false
  --info.notCheckable = true
  --info.text = '|cff2c9800Rotation Manager|r'
  --info.func = function()
  --  PossiblyEngine.interface.manager()
  --end
  --UIDropDownMenu_AddButton(info)


  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = pelg('rtn_default')
  UIDropDownMenu_AddButton(info)

  for specId,_ in pairs(PossiblyEngine.rotation.rotations) do
    if specId == mySpecId then
      info = { }
      info.text = PossiblyEngine.rotation.specId[specId] or PossiblyEngine.module.player.specName
      info.value = info.text
      info.checked = (PossiblyEngine.rotation.currentStringComp == info.text or PossiblyEngine.rotation.currentStringComp == "")
      info.func = function()
        local text = PossiblyEngine.rotation.specId[specId] or PossiblyEngine.module.player.specName
        PossiblyEngine.rotation.currentStringComp = text
        PossiblyEngine.rotation.activeRotation = PossiblyEngine.rotation.rotations[specId]
        if PossiblyEngine.rotation.oocrotations[PossiblyEngine.module.player.specID] then
          PossiblyEngine.rotation.activeOOCRotation = PossiblyEngine.rotation.oocrotations[PossiblyEngine.module.player.specID]
        else
          PossiblyEngine.rotation.activeOOCRotation = false
        end
        PossiblyEngine.buttons.resetButtons()
        if PossiblyEngine.rotation.buttons[specId] then
          PossiblyEngine.rotation.add_buttons()
        end
        PossiblyEngine.print(pelg('rtn_switch') .. text)
        PossiblyEngine.config.write('lastRotation_' .. mySpecId, '')
      end
      UIDropDownMenu_AddButton(info)
    end
  end

  info = { }
  info.isTitle = true
  info.notCheckable = true
  info.text = pelg('rtn_custom')
  UIDropDownMenu_AddButton(info)

  if PossiblyEngine.rotation.custom[mySpecId] then
    for _,rotation in pairs(PossiblyEngine.rotation.custom[mySpecId]) do
      info = { }
      info.text = rotation.desc
      info.value = info.text
      info.checked = (PossiblyEngine.rotation.currentStringComp == info.text)
      info.func = function()
        local text = rotation.desc
        PossiblyEngine.rotation.currentStringComp = text
        PossiblyEngine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          PossiblyEngine.rotation.activeOOCRotation = rotation.oocrotation
        else
          PossiblyEngine.rotation.activeOOCRotation = false
        end
        PossiblyEngine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        PossiblyEngine.print(pelg('rtn_switch') .. text)
        PossiblyEngine.config.write('lastRotation_' .. mySpecId, PossiblyEngine.rotation.currentStringComp)
      end
      UIDropDownMenu_AddButton(info)
    end
  else
    info = { }
    info.isTitle = false
    info.notCheckable = true
    info.text = pelg('rtn_nocustom')
    UIDropDownMenu_AddButton(info)
  end



end)

PossiblyEngine.rotation.loadLastRotation = function ()
  local specID = PossiblyEngine.module.player.specID

  local lastRotation = PossiblyEngine.config.read('lastRotation_' .. specID, '')
  if PossiblyEngine.rotation.custom[specID] and lastRotation ~= '' then
    for _, rotation in pairs(PossiblyEngine.rotation.custom[specID]) do
      if rotation.desc == lastRotation then
        local text = rotation.desc
        PossiblyEngine.rotation.currentStringComp = text
        PossiblyEngine.rotation.activeRotation = rotation.spellTable
        if rotation.oocrotation then
          PossiblyEngine.rotation.activeOOCRotation = rotation.oocrotation
        else
          PossiblyEngine.rotation.activeOOCRotation = false
        end
        PossiblyEngine.buttons.resetButtons()
        if rotation.buttons then
          rotation.buttons()
        end
        PossiblyEngine.print(pelg('rtn_switch') .. text)
        break
      end
    end
  end
end
