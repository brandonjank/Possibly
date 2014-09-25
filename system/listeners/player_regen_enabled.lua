-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("PLAYER_REGEN_ENABLED", function(...)
  PossiblyEngine.module.player.combat = false
  PossiblyEngine.module.combatTracker.cleanCT()
  PossiblyEngine.interface.cleanCT()
end)
