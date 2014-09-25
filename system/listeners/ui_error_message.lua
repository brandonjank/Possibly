-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("UI_ERROR_MESSAGE", function(...)
  local error = ...
  if error == SPELL_FAILED_NOT_BEHIND then
    PossiblyEngine.module.player.behind = false
    PossiblyEngine.module.player.behindTime = time()
  elseif error == SPELL_FAILED_UNIT_NOT_INFRONT then
    PossiblyEngine.module.player.infront = false
    PossiblyEngine.module.player.infrontTime = time()
  elseif error == SPELL_FAILED_TARGET_NO_RANGED_WEAPONS then
    PossiblyEngine.module.disarm.fail()
  elseif error == SPELL_FAILED_BAD_TARGETS then
    PossiblyEngine.module.disarm.fail(PossiblyEngine.parser.lastCast)
  end
end)
