-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

if PossiblyEngine.hardcore_debug == true then
  SetCVar('scriptProfile', 0) -- enable profiling
  PossiblyEngine.timer.register("profiling", function()
    UpdateAddOnCPUUsage()
    UpdateAddOnMemoryUsage()
    PossiblyEngine.cpu = GetAddOnCPUUsage(PossiblyEngine.addonName)
    PossiblyEngine.mem = GetAddOnMemoryUsage(PossiblyEngine.addonName)
    print(PossiblyEngine.cpu)
    print(PossiblyEngine.mem)
  end, 1000)
end
