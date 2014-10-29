-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("ADDON_ACTION_BLOCKED", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == PossiblyEngine.addonReal then
    StaticPopup1:Hide()
    PossiblyEngine.full = false
    PossiblyEngine.debug.print("Event Blocked: " .. event, 'action_block')
  end
end)
