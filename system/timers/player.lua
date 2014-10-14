-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.
local behindResolution = 2
PossiblyEngine.timer.register("player", function()
  if not PossiblyEngine.module.player.behind then
    PossiblyEngine.module.player.behind = true
  end
end, 3000)