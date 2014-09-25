-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.condition = {

}

PossiblyEngine.condition.register = function(name, evaluation)
  PossiblyEngine.condition[name] = evaluation
end

PossiblyEngine.condition.unregister = function(name)
  PossiblyEngine.condition[name] = nil
end
