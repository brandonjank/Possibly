-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Function prototypes
Distance = false
UnitsAroundUnit = false
FaceUnit = false
IterateObjects = false
LineOfSight = false

PossiblyEngine.protected = {
	unlocked = false
}

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
	Cast(spell, target)
	CameraOrSelectOrMoveStop(1)
	SetCVar("deselectOnClick", "1")
	SetCVar("deselectOnClick", stickyValue)
end

function Macro(text)
	return RunMacroText(text)
end

function UseItem(name, target)
	UseItemByName(name, target)
end