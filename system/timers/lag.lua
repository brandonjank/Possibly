-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local warningSent = false

PossiblyEngine.timer.register("lag", function()
  local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
  PossiblyEngine.lag = latencyWorld
  -- Dynamic rotation timing
  if PossiblyEngine.config.read('pe_dynamic', false) then
    if PossiblyEngine.lag < 500 then
      PossiblyEngine.cycleTime = PossiblyEngine.lag
      PossiblyEngine.timer.updatePeriod("rotation", PossiblyEngine.cycleTime)
      PossiblyEngine.debug.print("Dynamic Cycle Update: " .. PossiblyEngine.cycleTime .. "ms" , 'dynamic')
    end
  else
    PossiblyEngine.cycleTime = PossiblyEngine.config.read('dyncycletime', 100)
  end
end, 2000)
