-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- This shit fires all the time... wtf blizz, don't be stupid.
PossiblyEngine.listener.register("PLAYER_SPECIALIZATION_CHANGED", function(unitID)
  if unitID ~= 'player' then return end

  PossiblyEngine.module.player.updateSpec()
end)
