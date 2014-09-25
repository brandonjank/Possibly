-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local function channelStart(unitID)
  if unitID == 'player' then
    if PossiblyEngine.module.queue.spellQueue == name then
      PossiblyEngine.module.queue.spellQueue = nil
    end
    PossiblyEngine.module.player.casting = true
    PossiblyEngine.parser.lastCast = UnitCastingInfo('player')
  elseif unitID == 'pet' then
    PossiblyEngine.module.pet.casting = true
  end
end

PossiblyEngine.listener.register('UNIT_SPELLCAST_CHANNEL_START', channelStart)
