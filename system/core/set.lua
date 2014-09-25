-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Sets are a simple storage engine

PossiblyEngine.set = {
    set = { }
}

PossiblyEngine.set.new = function ()
    return PossiblyEngine.set
end

PossiblyEngine.set.add = function (key, value)
    PossiblyEngine.set.set[key] = value
end

PossiblyEngine.set.remove = function (key)
    PossiblyEngine.set.set[key] = nil
end
PossiblyEngine.set.contains = function (key)
    return PossiblyEngine.set.set[key] ~= nil
end


PossiblyEngine.rotations = PossiblyEngine.set.new()