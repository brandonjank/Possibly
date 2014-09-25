-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("UNIT_HEALTH_FREQUENT", function(unitID)
  PossiblyEngine.raid.updateHealth(unitID)
end)
