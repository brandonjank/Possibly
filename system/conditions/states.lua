-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local LibDispellable = LibStub("LibDispellable-1.0")

-- unit states for PvP
-- fuckin awesome amirite?

--[[
  state.purge
  state.charm
  state.disarm
  state.disorient
  state.dot
  state.fear
  state.incapacitate
  state.misc
  state.root
  state.silence
  state.sleep
  state.snare
  state.stun
  immune.all
  immune.charm
  immune.disorient
  immune.fear
  immune.incapacitate
  immune.melee
  immune.misc
  immune.silence
  immune.polly
  immune.sleep
  immune.snare
  immune.spell
  immune.stun
]]--

PossiblyEngine.states = { }
PossiblyEngine.states.status = {}
PossiblyEngine.states.status.charm = {
    "^charmed"
}
PossiblyEngine.states.status.disarm = {
    "disarmed"
}
PossiblyEngine.states.status.disorient = {
    "^disoriented"
}
PossiblyEngine.states.status.dot = {
    "damage every.*sec", "damage per.*sec"
}
PossiblyEngine.states.status.fear = {
    "^horrified", "^fleeing", "^feared", "^intimidated", "^cowering in fear",
    "^running in fear", "^compelled to flee"
}
PossiblyEngine.states.status.incapacitate = {
    "^incapacitated", "^sapped"
}
PossiblyEngine.states.status.misc = {
    "unable to act", "^bound", "^frozen.$", "^cannot attack or cast spells",
    "^shackled.$"
}
PossiblyEngine.states.status.root = {
    "^rooted", "^immobil", "^webbed", "frozen in place", "^paralyzed",
    "^locked in place", "^pinned in place"
}
PossiblyEngine.states.status.silence = {
    "^silenced"
}
PossiblyEngine.states.status.sleep = {
    "^asleep"
}
PossiblyEngine.states.status.snare = {
    "^movement.*slowed", "movement speed reduced", "^slowed by", "^dazed",
    "^reduces movement speed"
}
PossiblyEngine.states.status.stun = {
    "^stunned", "^webbed"
}
PossiblyEngine.states.immune = {}
PossiblyEngine.states.immune.all = {
    "dematerialize", "deterrence", "divine shield", "ice block"
}
PossiblyEngine.states.immune.charm = {
    "bladestorm", "desecrated ground", "grounding totem effect", "lichborne"
}
PossiblyEngine.states.immune.disorient = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.states.immune.fear = {
    "berserker rage", "bladestorm", "desecrated ground", "grounding totem",
    "lichborne", "nimble brew"
}
PossiblyEngine.states.immune.incapacitate = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.states.immune.melee = {
    "dispersion", "evasion", "hand of protection", "ring of peace", "touch of karma"
}
PossiblyEngine.states.immune.misc = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.states.immune.silence = {
    "devotion aura", "inner focus", "unending resolve"
}
PossiblyEngine.states.immune.polly = {
    "immune to polymorph"
}
PossiblyEngine.states.immune.sleep = {
    "bladestorm", "desecrated ground", "lichborne"
}
PossiblyEngine.states.immune.snare = {
    "bestial wrath", "bladestorm", "death's advance", "desecrated ground",
    "dispersion", "hand of freedom", "master's call", "windwalk totem"
}
PossiblyEngine.states.immune.spell = {
    "anti-magic shell", "cloak of shadows", "diffuse magic", "dispersion",
    "massspell reflection", "ring of peace", "spell reflection", "touch of karma"
}
PossiblyEngine.states.immune.stun = {
    "bestial wrath", "bladestorm", "desecrated ground", "icebound fortitude",
    "grounding totem", "nimble brew"
}

PossiblyEngine.condition.register("state.purge", function(target, spell)
  if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
  end
  return false
end)

PossiblyEngine.condition.register("state.charm", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.charm, 'debuff')
end)

PossiblyEngine.condition.register("state.disarm", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.disarm, 'debuff')
end)

PossiblyEngine.condition.register("state.disorient", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.disorient, 'debuff')
end)

PossiblyEngine.condition.register("state.dot", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.dot, 'debuff')
end)

PossiblyEngine.condition.register("state.fear", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.fear, 'debuff')
end)

PossiblyEngine.condition.register("state.incapacitate", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.incapacitate, 'debuff')
end)

PossiblyEngine.condition.register("state.misc", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.misc, 'debuff')
end)

PossiblyEngine.condition.register("state.root", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.root, 'debuff')
end)

PossiblyEngine.condition.register("state.silence", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.silence, 'debuff')
end)

PossiblyEngine.condition.register("state.sleep", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.sleep, 'debuff')
end)

PossiblyEngine.condition.register("state.snare", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.snare, 'debuff')
end)

PossiblyEngine.condition.register("state.stun", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.status.stun, 'debuff')
end)

PossiblyEngine.condition.register("immune.all", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.all)
end)

PossiblyEngine.condition.register("immune.charm", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.charm)
end)

PossiblyEngine.condition.register("immune.disorient", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.disorient)
end)

PossiblyEngine.condition.register("immune.fear", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.fear)
end)

PossiblyEngine.condition.register("immune.incapacitate", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.incapacitate)
end)

PossiblyEngine.condition.register("immune.melee", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.melee)
end)

PossiblyEngine.condition.register("immune.misc", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.misc)
end)

PossiblyEngine.condition.register("immune.silence", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.silence)
end)

PossiblyEngine.condition.register("immune.poly", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.polly)
end)

PossiblyEngine.condition.register("immune.sleep", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.sleep)
end)

PossiblyEngine.condition.register("immune.snare", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.snare)
end)

PossiblyEngine.condition.register("immune.spell", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.spell)
end)

PossiblyEngine.condition.register("immune.stun", function(target, spell)
  return PossiblyEngine.tooltip.scan(target, PossiblyEngine.states.immune.stun)
end)
