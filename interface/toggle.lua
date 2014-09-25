-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.toggle = {}

PossiblyEngine.toggle.create = function(toggle_name, icon, tooltipl1, tooltipl2, callback)
  local toggleCallback = function(self)
    self.checked = not self.checked
    if self.checked then
      PossiblyEngine.buttons.setActive(toggle_name)
    else
      PossiblyEngine.buttons.setInactive(toggle_name)
    end
    PossiblyEngine.config.write('button_states', toggle_name, self.checked)
    if callback then callback(self, mouseButton) end
  end
  PossiblyEngine.buttons.create(toggle_name, icon, toggleCallback, tooltipl1, tooltipl2)
  PossiblyEngine.buttons.loadStates()
end
