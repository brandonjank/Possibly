-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local function castSent(unitID, spell)
  if unitID == 'player' then
    PossiblyEngine.parser.lastCast = spell
    if PossiblyEngine.module.queue.spellQueue == spell then
      PossiblyEngine.module.queue.spellQueue = nil
    end
  end
end

PossiblyEngine.listener.register('UNIT_SPELLCAST_SENT', castSent)
