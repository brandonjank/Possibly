-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Function prototypes

PossiblyEngine.protected.generic_check = false

function PossiblyEngine.protected.Generic()
	if not PossiblyEngine.protected.method then
		pcall(RunMacroText, "/run PossiblyEngine.protected.generic_check = true")
		if PossiblyEngine.protected.generic_check then
			PossiblyEngine.protected.unlocked = true
			PossiblyEngine.protected.method = "generic"
			PossiblyEngine.timer.unregister('detectUnlock')
			PossiblyEngine.print('Detected a generic Lua unlock!  Some advanced features will not work.')
		end
	end
end