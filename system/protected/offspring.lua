-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Functions that require OffSpring

function PossiblyEngine.protected.OffSpring()

	if oexecute then

		PossiblyEngine.faceroll.rolling = false

		PossiblyEngine.pmethod = "OffSpring"

		function Cast(spell, target)
			if type(spell) == "number" then
				if target then
					oexecute("CastSpellByID(".. spell ..", \""..target.."\")")
				else
					oexecute("CastSpellByID(".. spell ..")")
				end
			else
				if target then
					oexecute("CastSpellByName(\"".. spell .."\", \""..target.."\")")
				else
					oexecute("CastSpellByName(\"".. spell .."\")")
				end
			end
		end

		local CastGroundOld = CastGround
		function CastGround(spell, target)
			if UnitExists(target) then
				Cast(spell, target)
				oclick(target)
				return
			end
			CastGroundOld(spell, target) -- try the old one ?
		end

		function LineOfSight(a, b)
			if a ~= 'player' then
				PossiblyEngine.print('OffSpring does not support LoS from an arbitrary unit, only player.')
			end
			return olos(b) == 0
		end

		function Macro(text)
			oexecute("RunMacroText(\""..text.."\")")
		end

	    function Distance(a, b)
	        if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
	            local ax, ay, az, ar = opos(a)
	            local bx, by, bz, br = opos(b)
	            return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
	        end
	        return 0
	    end

	    function FaceUnit(unit)
	        if UnitExists(unit) and UnitIsVisible(unit) then
	            oface(unit)
	        end
	    end

	    function UseItem(name, target)
	    	if type(spell) == "number" then
				if target then
					oexecute("UseItemByName(".. spell ..", \""..target.."\")")
				else
					oexecute("UseItemByName(".. spell ..")")
				end
			else
				if target then
					oexecute("UseItemByName(\"".. spell .."\", \""..target.."\")")
				else
					oexecute("UseItemByName(\"".. spell .."\")")
				end
			end
		end

		PossiblyEngine.protected.unlocked = true
		PossiblyEngine.protected.method = "offspring"
		PossiblyEngine.timer.unregister('detectUnlock')
	    PossiblyEngine.print('Detected OffSpring!')

	end

end