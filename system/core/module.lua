-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.module = {}
local module = PossiblyEngine.module

function module.register(name, struct)
  module[name] = struct
end

function module.unregister(name)
  module[name] = nil
end
