-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local function castStop(unitID)
  if unitID == 'player' then
    PossiblyEngine.module.player.casting = false
  elseif unitID == 'pet' then
    PossiblyEngine.module.pet.casting = false
  end
end

PossiblyEngine.listener.register('UNIT_SPELLCAST_STOP', castStop)
