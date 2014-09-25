-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.command.help = {

}

PossiblyEngine.command.register_help = function(key, help)
  PossiblyEngine.command.help[key] = help
end

PossiblyEngine.command.register_handler({'version', 'ver', 'v'}, function()
  PossiblyEngine.command.print('|cff' .. PossiblyEngine.addonColor .. 'PossiblyEngine |r' .. PossiblyEngine.version)
end)
PossiblyEngine.command.register_help('version', pelg('help_version'))

PossiblyEngine.command.register_handler({'help', '?', 'wat'}, function()
  PossiblyEngine.command.print('|cff' .. PossiblyEngine.addonColor .. 'PossiblyEngine |r' .. PossiblyEngine.version)
  for command, help in pairs(PossiblyEngine.command.help) do
    PossiblyEngine.command.print('|cff' .. PossiblyEngine.addonColor .. '/pe ' ..command .. '|r ' .. help)
  end
end)
PossiblyEngine.command.register_help('help', pelg('help_help'))

PossiblyEngine.command.register_handler({'cycle', 'pew', 'run'}, function()
  PossiblyEngine.cycle(true)
end)
PossiblyEngine.command.register_help('cycle', pelg('help_cycle'))

PossiblyEngine.command.register_handler({'toggle'}, function()
  PossiblyEngine.buttons.toggle('MasterToggle')
end)
PossiblyEngine.command.register_handler({'enable'}, function()
  PossiblyEngine.buttons.setActive('MasterToggle')
end)
PossiblyEngine.command.register_handler({'disable'}, function()
  PossiblyEngine.buttons.setInactive('MasterToggle')
end)

PossiblyEngine.command.register_help('toggle', pelg('help_toggle'))

PossiblyEngine.command.register_handler({'cd', 'cooldown', 'cooldowns'}, function()
  PossiblyEngine.buttons.toggle('cooldowns')
end)
PossiblyEngine.command.register_help('cd', pelg('cooldowns_tooltip'))

PossiblyEngine.command.register_handler({'kick', 'interrupts', 'interrupt', 'silence'}, function()
  PossiblyEngine.buttons.toggle('interrupt')
end)
PossiblyEngine.command.register_help('kick', pelg('interrupt_tooltip'))


PossiblyEngine.command.register_handler({'aoe', 'multitarget'}, function()
  PossiblyEngine.buttons.toggle('multitarget')
end)
PossiblyEngine.command.register_help('aoe', pelg('multitarget_tooltip'))


PossiblyEngine.command.register_handler({'ct', 'combattracker', 'ut', 'unittracker', 'tracker'}, function()
  UnitTracker.toggle()
end)
PossiblyEngine.command.register_help('ct', pelg('help_ct'))

PossiblyEngine.command.register_handler({'al', 'log', 'actionlog'}, function()
  PE_ActionLog:Show()
end)
PossiblyEngine.command.register_help('al', pelg('help_al'))

PossiblyEngine.command.register_handler({'lag', 'cycletime'}, function()
  PE_CycleLag:Show()
end)

PossiblyEngine.command.register_handler({'turbo', 'godmode'}, function()
  local state = PossiblyEngine.config.toggle('pe_turbo')
  if state then
    PossiblyEngine.print(pelg('turbo_enable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 10)
    PossiblyEngine.cycleTime = 10
  else
    PossiblyEngine.print(pelg('turbo_disable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 100)
    PossiblyEngine.cycleTime = 100
  end
end)
PossiblyEngine.command.register_help('turbo', pelg('help_turbo'))


PossiblyEngine.command.register_handler({'bvt'}, function()
  local state = PossiblyEngine.config.toggle('buttonVisualText')
  PossiblyEngine.buttons.resetButtons()
  PossiblyEngine.rotation.add_buttons()
end)

