-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.faceroll = {
	buttonMap = { },
	lastFrame = false,
	rolling = false
}

PossiblyEngine.faceroll.activeFrame = CreateFrame('Frame', 'activeCastFrame', UIParent)
local activeFrame = PossiblyEngine.faceroll.activeFrame
activeFrame:SetWidth(32)
activeFrame:SetHeight(32)
activeFrame:SetPoint("CENTER", UIParent, "CENTER")
activeFrame.texture = activeFrame:CreateTexture()
activeFrame.texture:SetTexture("Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8")
activeFrame.texture:SetVertexColor(0, 1, 0, 1)
activeFrame.texture:SetAllPoints(activeFrame)
activeFrame:SetFrameStrata('HIGH')
activeFrame:Hide()

local function showActiveSpell()
	if not PossiblyEngine.protected.method then
		local current_spell = PossiblyEngine.current_spell
		local spellButton = PossiblyEngine.faceroll.buttonMap[current_spell]
		if spellButton and current_spell then
			activeFrame:Show()
			activeFrame:SetPoint("CENTER", spellButton, "CENTER")
		else
			activeFrame:Hide()
		end
	else
		PossiblyEngine.faceroll.activeFrame:Hide()
		PossiblyEngine.timer.unregister("visualCast")
	end
end
PossiblyEngine.timer.register("visualCast", showActiveSpell, 50)
