-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local GetSpellInfo = GetSpellInfo

local ignoreSpells = { 75 }

PossiblyEngine.listener.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local turbo = PossiblyEngine.config.read('pe_turbo', false)
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    local name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spell)
    if PossiblyEngine.module.queue.spellQueue == name then
      PossiblyEngine.module.queue.spellQueue = nil
    end
    PossiblyEngine.actionLog.insert('Spell Cast Succeed', name, icon)
    PossiblyEngine.module.player.cast(spell)
    PossiblyEngine.module.player.infront = true
  end
end)
