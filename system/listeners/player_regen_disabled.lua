-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("PLAYER_REGEN_DISABLED", function(...)
  PossiblyEngine.module.player.combat = true
  PossiblyEngine.module.player.combatTime = GetTime()
end)
