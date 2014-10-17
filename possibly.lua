-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine = {
  addonName = "Possibly",
  addonColor = "EE2200",
  version = "6.0.2r4"
}

function PossiblyEngine.print(message)
  print('|c00'..PossiblyEngine.addonColor..'['..PossiblyEngine.addonName..']|r ' .. message)
end
