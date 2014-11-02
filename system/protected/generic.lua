-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Function prototypes

PossiblyEngine.protected.generic_check = false

function PossiblyEngine.protected.Generic()
	if not PossiblyEngine.protected.method and not PossiblyEngine.faceroll.rolling then
		pcall(RunMacroText, "/run PossiblyEngine.protected.generic_check = true")
		if PossiblyEngine.protected.generic_check then
			PossiblyEngine.protected.unlocked = true
			PossiblyEngine.protected.method = "generic"
			PossiblyEngine.timer.unregister('detectUnlock')
			PossiblyEngine.print('Detected a generic Lua unlock!  Some advanced features will not work.')

			function Cast(spell, target)
				if type(spell) == "number" then
					CastSpellByID(spell, target)
				else
					CastSpellByName(spell, target)
				end
			end

			function CastGround(spell, target)
				local stickyValue = GetCVar("deselectOnClick")
				SetCVar("deselectOnClick", "0")
				CameraOrSelectOrMoveStart(1)
				Cast(spell)
				CameraOrSelectOrMoveStop(1)
				SetCVar("deselectOnClick", "1")
				SetCVar("deselectOnClick", stickyValue)
			end

			function Macro(text)
				return RunMacroText(text)
			end

			function UseItem(name, target)
				return UseItemByName(name, target)
			end

		else
			PossiblyEngine.faceroll.rolling = true
			PossiblyEngine.faceroll.noticed = false
		end
	elseif PossiblyEngine.faceroll.rolling and not PossiblyEngine.faceroll.noticed then
		PossiblyEngine.print('No unlock found, now in FaceRoll mode, /reload your UI to check again.')
		PossiblyEngine.faceroll.noticed = true
	end
end
