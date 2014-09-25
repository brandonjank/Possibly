-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("ADDON_ACTION_FORBIDDEN", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == PossiblyEngine.addonName then
    StaticPopup1:Hide()
    PossiblyEngine.full = false
    PossiblyEngine.debug.print("Event Forbidden: " .. event, 'action_block')
  end
end)
