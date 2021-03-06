-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local pelg = PossiblyEngine.locale.get
local build = PossiblyEngine.build
local stringFormat = string.format

PossiblyEngine.listener.register("ADDON_LOADED", function(...)

  local addon = ...

  if addon ~= PossiblyEngine.addonReal then return end

  -- load all our config data
  PossiblyEngine.config.load(PossiblyEngine_ConfigData)

  -- load our previous button states
  PossiblyEngine.buttons.loadStates()

  -- Turbo
  PossiblyEngine.config.read('pe_turbo', false)

  -- Dynamic Cycle
  PossiblyEngine.config.read('pe_dynamic', false)

end)
