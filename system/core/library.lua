-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.


-- User loaded library ? yes please!
PossiblyEngine.library = {
  libs = { }
}

PossiblyEngine.library.register = function(name, lib)
  if PossiblyEngine.library.libs[name] then
    PossiblyEngine.debug.print("Cannot overwrite library:" .. name, 'library')
    return false
  end
  PossiblyEngine.library.libs[name] = lib
end

PossiblyEngine.library.fetch = function(name)
  return PossiblyEngine.library.libs[name]
end

PossiblyEngine.library.parse = function(event, evaluation, target)
  if target == nil then target = "target" end
  local call = string.sub(evaluation, 2)
  local func
  -- this will work most of the time... I hope :)
  if string.sub(evaluation, -1) == ')' then
    -- the user calls the function for us
    func = loadstring('local target = "'..target..'";return PossiblyEngine.library.libs.' .. call .. '')
  else
    -- we need to call the function
    func = loadstring('local target = "'..target..'";return PossiblyEngine.library.libs.' .. call .. '(target)')
  end
  local eval = func and func(target, event) or false
  return eval
end