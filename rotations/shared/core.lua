PossiblyEngine.rotation.shared = {
	-- Shared spells for all rotations
}


-- No one was supposed to use this, fucking retarded...
PossiblyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return PossiblyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for _, unit in pairs(PossiblyEngine.raid.roster) do
      if UnitDebuff(unit.unit, spell) then
        PossiblyEngine.dsl.parsedTarget = unit.unit
        return true
      end
    end
  end,
})
