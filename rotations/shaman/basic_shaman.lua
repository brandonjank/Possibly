-- Class ID 7 - The Naturalist
PossiblyEngine.rotation.register(7, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Buffs
  { "Lightning Shield", "!player.buff(Lightning Shield)" },

  -- Survival
  { "Healing Surge", "player.health <= 75" },
  
  -- Rotation
  { "Primal Strike" },
  { "Earth Shock" },
  { "Lightning Bolt" },
  
  ------------------
  -- End Rotation --
  ------------------
  
  }
)
