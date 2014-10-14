-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.
--[[
PossiblyEngine.keys = {
  frame = CreateFrame("Frame", "PE_CaptureKeyFrame", WorldFrame),
  states = { }
}

PossiblyEngine.keys.frame:EnableKeyboard(true)
PossiblyEngine.keys.frame:SetPropagateKeyboardInput(true)

PossiblyEngine.keys.frame:SetScript("OnKeyDown", function(self, key)
  PossiblyEngine.keys.setState(key, true)
end)

PossiblyEngine.keys.frame:SetScript("OnKeyUp", function(self, key)
  PossiblyEngine.keys.setState(key, nil)
end)

PossiblyEngine.keys.getState = function(key)
  return PossiblyEngine.keys.states[key] or false
end

PossiblyEngine.keys.setState = function(key, state)
  PossiblyEngine.keys.states[key] = state
end]]