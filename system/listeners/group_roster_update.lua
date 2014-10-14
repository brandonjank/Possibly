-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.listener.register("GROUP_ROSTER_UPDATE", function(...)
  PossiblyEngine.raid.build()
end)