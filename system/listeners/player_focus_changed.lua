-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("PLAYER_FOCUS_CHANGED", function(...)
  PossiblyEngine.module.player.focus = Unit
end)

PossiblyEngine.listener.register("PLAYER_TARGET_CHANGED", function(...)
  if PossiblyEngine.faceroll.rolling then
  	PossiblyEngine.faceroll.activeFrame:Hide()
  end
end)
