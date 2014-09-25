-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.module.register("tooltip", {

})
PossiblyEngine.module.tooltip.patterns = { }
PossiblyEngine.module.tooltip.patterns.purge = {
    "alter time", "ancient hysteria", "bloodlust", "divine favor", "divine insight",
    "divine plea", "dominate mind", "fear ward", "ghost wolf", "hand of freedom",
    "hand of protection", "hand of purity", "hand of sacrifice", "heroism",
    "ice barrier", "ice floes", "ice ward", "incanter's ward", "innervate",
    "levitate", "power infusion", "power word: shield", "speed of light",
    "slow fall", "temporal shield", "time warp"
}
PossiblyEngine.module.tooltip.patterns.status = {}
PossiblyEngine.module.tooltip.patterns.status.charm = {
    "^charmed"
}
PossiblyEngine.module.tooltip.patterns.status.disarm = {
    "disarmed"
}
PossiblyEngine.module.tooltip.patterns.status.disorient = {
    "^disoriented"
}
PossiblyEngine.module.tooltip.patterns.status.dot = {
    "damage every.*sec", "damage per.*sec"
}
PossiblyEngine.module.tooltip.patterns.status.fear = {
    "^horrified", "^fleeing", "^feared", "^intimidated", "^cowering in fear",
    "^running in fear", "^compelled to flee"
}
PossiblyEngine.module.tooltip.patterns.status.incapacitate = {
    "^incapacitated", "^sapped"
}
PossiblyEngine.module.tooltip.patterns.status.misc = {
    "unable to act", "^bound", "^frozen.$", "^cannot attack or cast spells",
    "^shackled.$"
}
PossiblyEngine.module.tooltip.patterns.status.root = {
    "^rooted", "^immobil", "^webbed", "frozen in place", "^paralyzed",
    "^locked in place", "^pinned in place"
}
PossiblyEngine.module.tooltip.patterns.status.silence = {
    "^silenced"
}
PossiblyEngine.module.tooltip.patterns.status.sleep = {
    "^asleep"
}
PossiblyEngine.module.tooltip.patterns.status.snare = {
    "^movement.*slowed", "movement speed reduced", "^slowed by", "^dazed",
    "^reduces movement speed"
}
PossiblyEngine.module.tooltip.patterns.status.stun = {
    "^stunned", "^webbed"
}
PossiblyEngine.module.tooltip.patterns.immune = {}
PossiblyEngine.module.tooltip.patterns.immune.all = {
    "dematerialize", "deterrence", "divine shield", "ice block"
}
PossiblyEngine.module.tooltip.patterns.immune.charm = {
    "bladestorm", "desecrated ground", "grounding totem effect", "lichborne"
}
PossiblyEngine.module.tooltip.patterns.immune.disorient = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.module.tooltip.patterns.immune.fear = {
    "berserker rage", "bladestorm", "desecrated ground", "grounding totem effect",
    "lichborne", "nimble brew"
}
PossiblyEngine.module.tooltip.patterns.immune.incapacitate = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.module.tooltip.patterns.immune.melee = {
    "dispersion", "evasion", "hand of protection", "ring of peace", "touch of karma"
}
PossiblyEngine.module.tooltip.patterns.immune.misc = {
    "bladestorm", "desecrated ground"
}
PossiblyEngine.module.tooltip.patterns.immune.silence = {
    "devotion aura", "inner focus", "unending resolve"
}
PossiblyEngine.module.tooltip.patterns.immune.sleep = {
    "bladestorm", "desecrated ground", "lichborne"
}
PossiblyEngine.module.tooltip.patterns.immune.snare = {
    "bestial wrath", "bladestorm", "death's advance", "desecrated ground",
    "dispersion", "hand of freedom", "master'scall", "windwalk totem"
}
PossiblyEngine.module.tooltip.patterns.immune.spell = {
    "anti-magic shell", "cloak of shadows", "diffuse magic", "dispersion",
    "mass spell reflection", "ring ofpeace", "spell reflection", "touch of karma"
}
PossiblyEngine.module.tooltip.patterns.immune.stun = {
    "bestialwrath", "bladestorm", "desecrated ground", "icebound fortitude",
    "grounding totem effect", "nimble brew"
}

PossiblyEngine.module.tooltip.parseBuffs = function(pattern)
  local f = CreateFrame('GameTooltip', 'MyTooltip', UIParent, 'GameTooltipTemplate')
  for i=1,40 do
    f:SetOwner(UIParent, 'ANCHOR_NONE')
    f:SetUnitBuff('player', i)
    local text = MyTooltipTextLeft2:GetText()
    if string.find(text, pattern) then
      return true
    end
  end
end

PossiblyEngine.module.tooltip.parseDebuffs = function(pattern)
  local f = CreateFrame('GameTooltip', 'MyTooltip', UIParent, 'GameTooltipTemplate')
  for i=1,40 do
    f:SetOwner(UIParent, 'ANCHOR_NONE')
    f:SetUnitDebuff('player', i)
    local text = MyTooltipTextLeft2:GetText()
    if string.find(text, pattern) then
      return true
    end
  end
end